import boto3
import os

s3 = boto3.client("s3")

def handler(event, context):
    bucket = os.environ["BACKUP_BUCKET"]

    file_path = "/var/task/main.py" 

    s3.upload_file(file_path, bucket, "main.py")

    return {"status": "OK"}
