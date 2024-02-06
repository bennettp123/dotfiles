
aws-list-instances ()
{
    aws ec2 describe-instances $@ \
     | jq '.Reservations[]?.Instances[]? | .InstanceId + ", " + .InstanceType + ", " + .PrivateIpAddress + ", " + .PrivateDnsName + ", " + (.Tags[]? // [] | select(.Key?=="Name") | .Value) + ", " + .PublicIpAddress'
}

aws-elb-health() {
	aws elb describe-instance-health --load-balancer-name $@ | jq '.InstanceStates[] | .InstanceId + ": " + .State'
}

aws-elb-instances() {
	for instance in $(aws elb describe-instance-health --load-balancer-name $@ | jq '.InstanceStates[].InstanceId'); do
		aws-list-instances --instance-ids ${instance}
	done
}

aws-list-vpcs() {
	aws ec2 describe-vpcs $@ \
		| jq -rM '.Vpcs[] | .CidrBlock + ", " + .VpcId + ", " + (.Tags[]? | select(.Key == "Name") | .Value)' \
		| sort
}

aws-list-subnets() {
	aws ec2 describe-subnets $@ \
		| jq -rM '.Subnets[] | .CidrBlock + ", " + .SubnetId + ", " + .AvailabilityZone + (.Tags[]? | select(.Key=="Name") | .Value)' \
		| sort
}

aws-list-images() {
	aws ec2 describe-images --owners=self $@ \
		| jq -rM '.Images[] | .CreationDate + " " + .ImageId + " " + .State + " " + .Name + " " + "\"" + .Description + "\""' \
		| sort -r
}

aws-list-rds-instances() {
	aws rds describe-db-instances $@ \
		| jq -rM '.DBInstances[] | .DBInstanceIdentifier + ", " + .DBInstanceClass + ", " + .Engine + " v" + .EngineVersion + ", " + .AvailabilityZone + ", " + .DBInstanceStatus' \
		| sort
}

