from datetime import datetime
import gzip

def reduce_transaction_data():
    """
    Read transactions.csv.gz line by line and only include examples for
    categories and companies for whom we have offer information

    Approach is described here:
        https://github.com/MLWave/kaggle_acquire-valued-shoppers-challenge/blob/master/gen_vw_features.py
    """

    start = datetime.now()

    offer_categories = set()
    offer_companies = set()

    for i, line in enumerate(open('data/offers.csv')):
        if i > 0:
            data = line.split(',')
            offer_categories.add(data[1])
            offer_companies.add(data[3])

    print "Categories:", offer_categories
    print "Companies:", offer_companies

    with open('data/reduced_transactions.csv', 'wb') as output_file:
        reduced_count = 0
        for i, line in enumerate(gzip.open('data/transactions.csv.gz')):
            if i==0:
                output_file.write(line)
            else:
                data = line.split(',')
                if data[3] in offer_categories or data[4] in offer_companies:
                    output_file.write(line)
                    reduced_count += 1
            if i % 5000000 == 0:
                print i, reduced_count, datetime.now() - start

        



if __name__ == '__main__':
    reduce_transaction_data()

