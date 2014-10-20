from datetime import datetime
import argparse
import gzip
import sys

def read_offers(offer_file):
    categories = set()
    companies = set()

    for i, line in enumerate(offer_file):
        if i > 0:
            data = line.split(',')
            categories.add(data[1])
            companies.add(data[3])
    return categories, companies


def reduce_transaction_data(transaction_file, output_file, categories, companies):
    """
    Read the transaction file line by line and only include examples for
    categories and companies that appear in the supplied sets
    """

    start = datetime.now()


    reduced_count = 0
    for i, line in enumerate(transaction_file):
        if i==0:
            output_file.write(line)
        else:
            data = line.split(',')
            if data[3] in categories or data[4] in companies:
                output_file.write(line)
                reduced_count += 1
        if i % 5000000 == 0:
            sys.stderr.write(str((i, reduced_count, datetime.now() - start)))
            sys.stderr.write('\n')

def open_gz(fname):
    if fname.endswith(".gz"):
        return gzip.open(fname)
    return open(fname)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Reduce transaction data')
    parser.add_argument('input_file')
    parser.add_argument('--offers', dest='offers_file')
    parser.add_argument('--output', dest='output_file')
    parser.add_argument('--categories', type=str, nargs='+')
    parser.add_argument('--companies', type=str, nargs='+')

    args = parser.parse_args()

    output_file = sys.stdout
    if args.output_file:
        output_file = open(args.output_file, 'wb')

    input_file = open_gz(args.input_file)

    if args.offers_file:
        offers_file = open_gz(args.offers_file)
        categories, companies = read_offers(offers_file)
        reduce_transaction_data(input_file, output_file, categories, companies)
    else:
        reduce_transaction_data(input_file, output_file, args.categories,
                                args.companies)


    if output_file != sys.stdout:
        output_file.close()

