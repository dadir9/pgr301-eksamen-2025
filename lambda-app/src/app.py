"""
College Assignment Lambda Function
Demonstrates serverless computing with AWS Lambda
"""

import json
import os
import boto3
import logging
from datetime import datetime

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS clients
s3_client = boto3.client('s3')

def lambda_handler(event, context):
    """
    Main Lambda handler function
    Processes incoming requests and interacts with S3
    """
    try:
        # Log the incoming event
        logger.info(f"Received event: {json.dumps(event)}")

        # Parse request body if it exists
        body = json.loads(event.get('body', '{}')) if event.get('body') else {}

        # Get environment variables
        environment = os.environ.get('ENVIRONMENT', 'unknown')
        s3_bucket = os.environ.get('S3_BUCKET', None)

        # Process based on action
        action = body.get('action', 'default')

        if action == 'upload':
            result = handle_upload(body, s3_bucket)
        elif action == 'list':
            result = handle_list(s3_bucket)
        elif action == 'process':
            result = handle_process(body)
        else:
            result = handle_default(environment)

        # Return success response
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'success': True,
                'timestamp': datetime.now().isoformat(),
                'environment': environment,
                'result': result
            })
        }

    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'success': False,
                'error': str(e)
            })
        }


def handle_upload(body, s3_bucket):
    """Handle file upload to S3"""
    if not s3_bucket:
        raise ValueError("S3 bucket not configured")

    file_name = body.get('fileName', f"file-{datetime.now().timestamp()}.txt")
    file_content = body.get('content', 'Sample content')

    # Upload to S3
    s3_client.put_object(
        Bucket=s3_bucket,
        Key=f"uploads/{file_name}",
        Body=file_content,
        ContentType='text/plain'
    )

    logger.info(f"Uploaded file {file_name} to S3 bucket {s3_bucket}")

    return {
        'action': 'upload',
        'fileName': file_name,
        'bucket': s3_bucket,
        'status': 'uploaded'
    }


def handle_list(s3_bucket):
    """List files in S3 bucket"""
    if not s3_bucket:
        return {
            'action': 'list',
            'message': 'S3 bucket not configured',
            'files': []
        }

    try:
        response = s3_client.list_objects_v2(
            Bucket=s3_bucket,
            MaxKeys=10
        )

        files = []
        if 'Contents' in response:
            files = [
                {
                    'key': obj['Key'],
                    'size': obj['Size'],
                    'lastModified': obj['LastModified'].isoformat()
                }
                for obj in response['Contents']
            ]

        return {
            'action': 'list',
            'bucket': s3_bucket,
            'fileCount': len(files),
            'files': files
        }

    except Exception as e:
        logger.error(f"Error listing S3 objects: {str(e)}")
        return {
            'action': 'list',
            'error': str(e),
            'files': []
        }


def handle_process(body):
    """Process data and return results"""
    data = body.get('data', [])

    # Simple data processing example
    processed = {
        'itemCount': len(data),
        'processedAt': datetime.now().isoformat(),
        'summary': {
            'total': len(data),
            'processed': len(data),
            'failed': 0
        }
    }

    # Simulate some processing
    if isinstance(data, list):
        processed['results'] = [
            {'id': i, 'value': item, 'status': 'processed'}
            for i, item in enumerate(data)
        ]

    return {
        'action': 'process',
        'processed': processed
    }


def handle_default(environment):
    """Default handler for basic requests"""
    return {
        'action': 'default',
        'message': 'Lambda function is working!',
        'environment': environment,
        'timestamp': datetime.now().isoformat(),
        'features': [
            'S3 Integration',
            'Data Processing',
            'API Gateway',
            'CloudWatch Logging'
        ]
    }