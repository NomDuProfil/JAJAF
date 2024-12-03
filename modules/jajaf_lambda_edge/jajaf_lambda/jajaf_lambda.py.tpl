import boto3

def lambda_handler(event, context):
    ssm_client = boto3.client("ssm", region_name="us-east-1")
    parameter_name = "${jajaf_ssm_name}"

    client_ip = event["Records"][0]["cf"]["request"]["clientIp"]

    response = ssm_client.get_parameter(Name=parameter_name)
    allowed_ips = response["Parameter"]["Value"].split(",")

    if client_ip in allowed_ips:
        return event["Records"][0]["cf"]["request"]
    else:
        return {
            "status": "403",
            "statusDescription": "Forbidden",
            "body": "Access denied"
        }
