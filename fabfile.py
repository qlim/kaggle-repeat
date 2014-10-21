from fabric.api import run, cd, env, put
import os.path
import datetime

PROJECT_DIR = '/home/ec2-user/kaggle-repeat'

def project_path(path):
    return os.path.join(PROJECT_DIR, path)

env.use_ssh_config = True

def setup_env():
    run('mkdir -p %s' % PROJECT_DIR)

def download_data():
    urls = [
        'https://www.kaggle.com/c/acquire-valued-shoppers-challenge/download/offers.csv.gz',
        'https://www.kaggle.com/c/acquire-valued-shoppers-challenge/download/sampleSubmission.csv.gz',
        'https://www.kaggle.com/c/acquire-valued-shoppers-challenge/download/testHistory.csv.gz',
        'https://www.kaggle.com/c/acquire-valued-shoppers-challenge/download/trainHistory.csv.gz',
        'https://www.kaggle.com/c/acquire-valued-shoppers-challenge/download/transactions.csv.gz'
    ]

    put('kaggle-cookie.txt', project_path('kaggle-cookie.txt')) 

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
    put('reduce_data.py', project_path('reduce_data.py'))

    with cd(project_path('.')):
        run('python reduce_data.py --offers data/offers.csv --output data/reduced_transactions.csv data/transactions.csv.gz')

def send_scripts():
    put('reduce_data.py', project_path('reduce_data.py'))

def deploy():
    setup_env()
    download_data()
    extract_data()

    print "Complete"

