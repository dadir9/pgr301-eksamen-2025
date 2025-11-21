"""
Unit tests for Lambda function
"""

import json
import pytest
import sys
import os
from unittest.mock import MagicMock

# Mock boto3 before importing app
sys.modules['boto3'] = MagicMock()

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from app import lambda_handler, handle_default, handle_process


def test_lambda_handler_default():
    """Test default Lambda handler"""
    event = {
        'body': json.dumps({'action': 'default'})
    }
    context = {}

    response = lambda_handler(event, context)

    assert response['statusCode'] == 200
    body = json.loads(response['body'])
    assert body['success'] is True
    assert 'result' in body


def test_handle_default():
    """Test default handler function"""
    result = handle_default('test')

    assert result['action'] == 'default'
    assert result['environment'] == 'test'
    assert 'message' in result
    assert 'features' in result


def test_handle_process():
    """Test process handler function"""
    body = {
        'data': ['item1', 'item2', 'item3']
    }

    result = handle_process(body)

    assert result['action'] == 'process'
    assert result['processed']['itemCount'] == 3
    assert len(result['processed']['results']) == 3


def test_lambda_handler_error():
    """Test Lambda handler error handling"""
    event = {
        'body': 'invalid json'
    }
    context = {}

    response = lambda_handler(event, context)

    # Should handle error gracefully
    assert response['statusCode'] == 200 or response['statusCode'] == 500