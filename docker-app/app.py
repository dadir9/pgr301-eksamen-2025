"""
Sample Flask Application for Docker Container
College Assignment - Demonstrates containerization
"""

from flask import Flask, jsonify, request
import os
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Create Flask app
app = Flask(__name__)

# Configuration
PORT = int(os.environ.get('PORT', 8000))
ENVIRONMENT = os.environ.get('ENVIRONMENT', 'development')
APP_NAME = os.environ.get('APP_NAME', 'college-docker-app')


@app.route('/')
def home():
    """Home endpoint"""
    return jsonify({
        'message': 'Welcome to College Docker Application',
        'app': APP_NAME,
        'environment': ENVIRONMENT,
        'timestamp': datetime.now().isoformat(),
        'endpoints': [
            '/',
            '/health',
            '/api/info',
            '/api/process'
        ]
    })


@app.route('/health')
def health():
    """Health check endpoint for container orchestration"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat()
    }), 200


@app.route('/api/info')
def info():
    """Application information endpoint"""
    return jsonify({
        'application': APP_NAME,
        'version': '1.0.0',
        'environment': ENVIRONMENT,
        'container': {
            'hostname': os.environ.get('HOSTNAME', 'unknown'),
            'platform': os.name
        },
        'features': [
            'RESTful API',
            'Health Checks',
            'JSON Processing',
            'Container Ready'
        ]
    })


@app.route('/api/process', methods=['POST'])
def process_data():
    """Process incoming data"""
    try:
        data = request.get_json()

        if not data:
            return jsonify({
                'error': 'No data provided'
            }), 400

        # Simple processing logic
        processed = {
            'received': data,
            'processedAt': datetime.now().isoformat(),
            'itemCount': len(data) if isinstance(data, (list, dict)) else 1,
            'status': 'processed'
        }

        # Log the processing
        logger.info(f"Processed data with {processed['itemCount']} items")

        return jsonify({
            'success': True,
            'result': processed
        })

    except Exception as e:
        logger.error(f"Error processing data: {str(e)}")
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


@app.errorhandler(404)
def not_found(e):
    """Handle 404 errors"""
    return jsonify({
        'error': 'Endpoint not found',
        'status': 404
    }), 404


@app.errorhandler(500)
def internal_error(e):
    """Handle 500 errors"""
    logger.error(f"Internal server error: {str(e)}")
    return jsonify({
        'error': 'Internal server error',
        'status': 500
    }), 500


if __name__ == '__main__':
    logger.info(f"Starting {APP_NAME} on port {PORT}")
    app.run(
        host='0.0.0.0',
        port=PORT,
        debug=(ENVIRONMENT == 'development')
    )