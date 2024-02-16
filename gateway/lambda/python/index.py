import json

def lambda_handler(event, context):
    try:
        message = 'Hello, AWS Lambda with Python!'

        return {
            'statusCode': 200,
            'body': json.dumps({'message': message, 'data': 'hades-lobo-PYTHON'})
        }
    except Exception as e:
        print('Error:', e)
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Internal Server Error'})
        }
