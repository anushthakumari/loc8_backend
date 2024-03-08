
import os
from flask import Blueprint, request, jsonify
from app.utils.helpers import token_required
from config.config import AppConfig
from werkzeug.utils import secure_filename
from scripts.video_processing_script import video_processing

video_bp = Blueprint('videos', __name__)

@video_bp.route('/upload', methods=['POST',])
@token_required
def upload(current_user):
    video_file = request.files['video']
    zone_id = request.form['zone_id']
    state_id = request.form['state_id']
    city_id = request.form['city_id']

    if video_file is None or video_file.filename == "":
        return jsonify({"error": "no file"})

    dest = os.path.join(AppConfig.UPLOAD_FOLDER, secure_filename(video_file.filename))
    video_file.save(dest)

    # Call video_processing function
    vcd = video_processing(dest)
    vcd2 = str(vcd)
    vcd3 = vcd2[0:2]

    # Remove the uploaded video file
    os.remove(dest)

    # Process the result and send the response
    return jsonify({"Result": vcd2}), 200
