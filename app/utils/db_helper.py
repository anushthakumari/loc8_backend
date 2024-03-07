from flask import current_app
from flask_mysqldb import MySQL

def init_db(app):
    mysql = MySQL(app)
    return mysql

def query_db(query, args=(), one=False):
    cursor = current_app.mysql.connection.cursor()
    cursor.execute(query, args)
    columns = [column[0] for column in cursor.description]
    data = cursor.fetchone() if one else cursor.fetchall()
    cursor.close()

    if not data:
        return None

    result = [dict(zip(columns, row)) for row in data] if not one else dict(zip(columns, data))
    return result
