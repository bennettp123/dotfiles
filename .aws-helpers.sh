aws-list-instances() {
  aws ec2 describe-instances $@ |
    jq '.Reservations[]?.Instances[]? | .InstanceId + ", " + .InstanceType + ", " + .PrivateIpAddress + ", " + .PrivateDnsName + ", " + (.Tags[]? // [] | select(.Key?=="Name") | .Value) + ", " + .PublicIpAddress'
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
  aws ec2 describe-vpcs $@ |
    jq -rM '.Vpcs[] | .CidrBlock + ", " + .VpcId + ", " + (.Tags[]? | select(.Key == "Name") | .Value)' |
    sort
}

aws-list-subnets() {
  aws ec2 describe-subnets $@ |
    jq -rM '.Subnets[] | .CidrBlock + ", " + .SubnetId + ", " + .AvailabilityZone + (.Tags[]? | select(.Key=="Name") | .Value)' |
    sort
}

aws-list-images() {
  aws ec2 describe-images --owners=self $@ |
    jq -rM '.Images[] | .CreationDate + " " + .ImageId + " " + .State + " " + .Name + " " + "\"" + .Description + "\""' |
    sort -r
}

aws-list-rds-instances() {
  aws rds describe-db-instances $@ |
    jq -rM '.DBInstances[] | .DBInstanceIdentifier + ", " + .DBInstanceClass + ", " + .Engine + " v" + .EngineVersion + ", " + .AvailabilityZone + ", " + .DBInstanceStatus' |
    sort
}

aws-login-ecr() {
  AWS_PROFILE=wandigital \
    aws ecr get-login-password |
    docker login -u AWS https://949304525094.dkr.ecr.ap-southeast-2.amazonaws.com --password-stdin
}

ssw-ecs-shell() {
  CONTAINER="${1:-php-fpm}"
  [ "${CONTAINER}" = 'php-fpm' ] || [ "${CONTAINER}" = 'nginx' ] ||
    echo "warning: unrecognized container '${CONTAINER}' (expected one of 'php-fpm' or 'nginx')" >&2

  ENV="${2:-dev}"
  [ "${ENV}" = 'dev' ] || [ "${ENV}" = 'prd' ] ||
    echo "warning: unrecognized env ${ENV} (expected 'dev' or 'prd')" >&2
  (
    set -eo pipefail
    CLUSTER="$(AWS_PROFILE=wandigital aws ecs list-clusters | jq -cr '.clusterArns[]' | grep ssw-shared-"${ENV}" | head -n1)"
    SERVICE="$(AWS_PROFILE=wandigital aws ecs list-services --cluster "${CLUSTER}" | jq -cr '.serviceArns[]' | grep ssw-shared-"${ENV}" | head -n1)"
    TASK="$(AWS_PROFILE=wandigital aws ecs list-tasks --cluster "${CLUSTER}" --service "${SERVICE}" | jq -cr '.taskArns[]' | head -n1)"
    echo "cluster: ${CLUSTER}" >&2
    echo "service: ${SERVICE}" >&2
    echo "task: ${TASK}" >&2
    echo >&2
    echo "launching:" >&2
    echo "    AWS_PROFILE=wandigital aws ecs execute-command --interactive \\" >&2
    echo "        --cluster \"${CLUSTER}\" \\" >&2
    echo "        --task \"${TASK}\" \\" >&2
    echo "        --container '${CONTAINER}' --command bash" >&2
    echo >&2
    echo >&2
    if [ "${CONTAINER}" = 'php-fpm' ]; then
      echo 'HINT: connect to the database using one of the following commands:' >&2
      echo '  _dbla:' >&2
      echo '    mysql --user="${DB_USER}" --password="${DB_PASSWORD}" --host="${DB_HOST}" --port="${DB_PORT}" "${DB_NAME}"' >&2
      echo '  _wan:' >&2
      echo '    mysql --user="${DB_USER}" --password="${DB_PASSWORD}" --host="${DB_HOST}" --port="${DB_PORT}" "${DB_NAME_TWO}"' >&2
      echo >&2
      echo >&2
    fi
    AWS_PROFILE=wandigital aws ecs execute-command --interactive --cluster "${CLUSTER}" --task "${TASK}" --container "${CONTAINER}" --command bash
  )
}
