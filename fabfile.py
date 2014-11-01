from fabric.api import run, cd, env, put
import os.path
import datetime

PROJECT_DIR = '/home/ec2-user/kaggle-repeat'

def project_path(path):
    return os.path.join(PROJECT_DIR, path)

def copy_file(name):
    put(name, project_path(name))

def psql(fname):
    run('psql -d kaggle -f %s' % project_path(fname))

env.use_ssh_config = True

def setup_env():
    run('mkdir -p %s' % PROJECT_DIR)
    run('sudo chmod -R a+rx /home/ec2-user')

def install_packages():
    run('sudo yum install -y postgresql93-server postgresql93 python-psycopg2')

def download_data():
    urls = [
        'https://www.kaggle.com/c/acquire-valued-shoppers-challenge/download/offers.csv.gz',
        'https://www.kaggle.com/c/acquire-valued-shoppers-challenge/download/sampleSubmission.csv.gz',
        'https://www.kaggle.com/c/acquire-valued-shoppers-challenge/download/testHistory.csv.gz',
        'https://www.kaggle.com/c/acquire-valued-shoppers-challenge/download/trainHistory.csv.gz',
        'https://www.kaggle.com/c/acquire-valued-shoppers-challenge/download/transactions.csv.gz'
    ]

    copy_file('kaggle-cookie.txt')

    run('mkdir -p %s' % project_path('data'))

    with cd(project_path('data')):

        for url in urls:
            save_as = url.split('/')[-1]
            run('wget -x --trust-server-names --load-cookies ../kaggle-cookie.txt "%s" -O %s' % (url, save_as))

    run('rm %s' % project_path('kaggle-cookie.txt'))

def extract_data(transactions=False):
    unzip_files = ['offers.csv.gz', 'sampleSubmission.csv.gz',
                   'testHistory.csv.gz', 'trainHistory.csv.gz']
    if transactions:
        unzip_files.append('transactions.csv.gz')

    with cd(project_path('data')):
        for fn in unzip_files:
            run('gunzip %s' % fn)

def reduce_data():
    copy_file('reduce_data.py')

    with cd(project_path('.')):
        run('python reduce_data.py --offers data/offers.csv --output data/reduced_transactions.csv data/transactions.csv.gz')

def send_scripts():
    copy_file('reduce_data.py')
    copy_file('create_tables.sql')

def setup_db():
    run('sudo service postgresql93 initdb')
    run('sudo /etc/init.d/postgresql93 start')
    run('sudo -u postgres createuser ec2-user')
    run('sudo -u postgres createdb kaggle -O ec2-user')

def reset_db():
    run('sudo -u postgres psql -d kaggle -c "drop schema public cascade;'
        'create schema public; grant all on schema public to \\\\"ec2-user\\\\""')

def create_tables(tx_data='data/reduced_transactions.csv', cleanup=False):
    copy_file('create_tables.sql')
    psql('create_tables.sql')
    load_data('offers', project_path('data/offers.csv'))
    load_data('transactions',
              project_path(tx_data))
    load_data('offer_performance',
              project_path('data/trainHistory.csv'))

    if cleanup:
        run('rm %s' % project_path(tx_data))

def create_views():
    copy_file('create_views.sql')
    psql('create_views.sql')

def create_features():
    copy_file('create_features.sql')
    psql('create_features.sql')

def load_data(table, fname):
    run('''sudo -u postgres psql -d kaggle -c "COPY %s FROM '%s' CSV HEADER"''' %
        (table, fname))

def save_data(table, fname):
    run('''sudo -u postgres psql -d kaggle -c "COPY %s TO '%s' CSV HEADER"''' %
        (table, fname))

def deploy():
    setup_env()
    install_packages()
    download_data()
    extract_data()
    setup_db()
    create_tables()

    print "Complete"

def deploy_full():
    setup_env()
    install_packages()
    download_data()
    extract_data(transactions=True)
    setup_db()
    create_tables('data/transactions.csv', cleanup=True)
    create_views()
    create_features()
    save_data('f_customer_category', project_path('data/features.csv'))



