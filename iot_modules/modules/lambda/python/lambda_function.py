import json

def lambda_handler(event, context):
    # Simple example logic
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
