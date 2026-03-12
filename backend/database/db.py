from flask_sqlalchemy import SQLAlchemy

# Single db instance used across all models
db = SQLAlchemy()

def init_db(app):
    """Initialize database with Flask app"""
    db.init_app(app)
    with app.app_context():
        db.create_all()
    return db