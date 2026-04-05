import os
import uuid
import boto3
import watchtower, logging
from flask import Flask, request
from flask_sqlalchemy import SQLAlchemy
from .log_formatter import StructuredFormatter

def create_app(config_overrides=None): 
    logging.basicConfig(level=logging.INFO)

    app = Flask(__name__, static_folder='app', static_url_path="/") 
 
    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv("SQLALCHEMY_DATABASE_URI", "sqlite:///db.sqlite")
    if config_overrides: 
        app.config.update(config_overrides)
 
    handler = watchtower.CloudWatchLogHandler(
            log_group_name="taskoverflow",
            boto3_client=boto3.client("logs", region_name="us-east-1")
    )
    handler.setFormatter(StructuredFormatter())
    app.logger.addHandler(handler)
    logging.getLogger().addHandler(handler)
    logging.getLogger('werkzeug').addHandler(handler)
    logging.getLogger("sqlalchemy.engine").addHandler(handler)
    logging.getLogger("sqlalchemy.engine").setLevel(logging.INFO)
   
    requests = logging.getLogger("requests")
    requests.addHandler(handler)

    @app.before_request
    def before_request():
        request.environ['REQUEST_ID'] = str(uuid.uuid4())
        requests.info("Request started")

    @app.after_request
    def after_request(response):
        requests.info("Request finished")
        return response

    # Load the models 
    from todo.models import db 
    from todo.models.todo import Todo 
    db.init_app(app) 

    # Create the database tables 
    with app.app_context(): 
        db.create_all() 
        db.session.commit() 
 
    # Register the blueprints 
    from todo.views.routes import api 
    app.register_blueprint(api) 

    app.add_url_rule('/', 'index', lambda: app.send_static_file('index.html'))

    return app
