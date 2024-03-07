import jwt
from datetime import datetime, timedelta
from functools import wraps
from flask import request, jsonify, current_app

def token_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        token = request.headers.get('Authorization')

        if not token:
            return jsonify({'message': 'Token is missing'}), 401

        try:
            secret_key = current_app.config['SECRET_KEY']
            data = jwt.decode(token, secret_key, algorithms=['HS256'])
            current_user = data
        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token has expired'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'message': 'Invalid token'}), 401

        # Pass current_user as a keyword argument to the wrapped function
        return func(current_user=current_user, *args, **kwargs)

    return wrapper

def generate_jwt_token(email, role_id):
    payload = {
        'sub': email,
        'role_id': role_id,
        'iat': datetime.utcnow(),
        'exp': datetime.utcnow() + timedelta(days=1)
    }

    secret_key = current_app.config['SECRET_KEY']

    token = jwt.encode(payload, secret_key, algorithm='HS256')
    return token

def superadmin_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        current_user = kwargs.get('current_user')

        if not current_user or current_user.get('role_id') != 3:
            return jsonify({'message': 'Access denied. Superadmin privileges required.'}), 403

        return func(current_user=current_user, *args, **kwargs)

    return wrapper
