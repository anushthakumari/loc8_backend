import os

class AppConfig:
    DEBUG = True
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'your_default_secret_key'
    MYSQL_HOST = os.environ.get('MYSQL_HOST') or 'localhost'
    MYSQL_USER = os.environ.get('MYSQL_USER') or 'your_default_mysql_user'
    MYSQL_PASSWORD = os.environ.get('MYSQL_PASSWORD') or ''
    MYSQL_DB = os.environ.get('MYSQL_DB') or 'your_default_mysql_db'
