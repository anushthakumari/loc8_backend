from flask import Blueprint, request, jsonify
from app.utils.helpers import token_required

video_bp = Blueprint('video', __name__)

@video_bp.route('/upload', methods=['POST', 'GET'])
def upload():
    return jsonify({'message': 'Invalid credentials'})