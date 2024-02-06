
aws-list-instances ()
{
    aws ec2 describe-instances $@ \
     | jq '.Reservations[]?.Instances[]? | .InstanceId + ", " + .InstanceType + ", " + .PrivateIpAddress + ", " + .PrivateDnsName + ", " + (.Tags[]? // [] | select(.Key?=="Name") | .Value) + ", " + .PublicIpAddress'
}

