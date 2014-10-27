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

    run('rm %s', project_path('kaggle-cookie.txt'))

def extract_data():
    unzip_files = ['offers.csv.gz', 'sampleSubmission.csv.gz',
                   'testHistory.csv.gz', 'trainHistory.csv.gz']

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

def create_tables():
    copy_file('create_tables.sql')
    psql('create_tables.sql')
    load_data('offers', project_path('data/offers.csv'))
    load_data('transactions',
              project_path('data/reduced_transactions.csv'))
    load_data('offer_performance',
              project_path('data/trainHistory.csv'))

def create_views():
    copy_file('create_views.sql')
    psql('create_views.sql')

def load_data(table, fname):
    run('''sudo -u postgres psql -d kaggle -c "COPY %s FROM '%s' CSV HEADER"''' %
        (table, fname))

def deploy():
    setup_env()
    install_packages()
    download_data()
    extract_data()
    setup_db()
    create_tables()

    print "Complete"

