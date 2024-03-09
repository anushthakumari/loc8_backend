from flask import Flask
from flask_cors import CORS
from config.config import AppConfig
from app.utils.db_helper import init_db
import os

app = Flask(__name__, static_url_path="/processed_videos", static_folder="../instance")
app.config.from_object(AppConfig)

app.mysql = init_db(app) 

CORS(app)

os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

from app.routes.auth_routes import auth_bp
from app.routes.video_routes import video_bp
from app.routes.admin_routes import admin_bp
from app.routes.location_routes import location_bp

app.register_blueprint(auth_bp, url_prefix='/auth')
app.register_blueprint(video_bp, url_prefix='/videos')
app.register_blueprint(admin_bp, url_prefix='/admin')
app.register_blueprint(location_bp, url_prefix='/location')
