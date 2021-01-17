#!/usr/bin/env zsh

for role in control worker
do
  for index in 0 1 2
  do
    instanceid=$(aws ec2 describe-instances --filters "Name=tag:node,Values=${role}-${index}" | \
                 jq -j '.Reservations[].Instances[].InstanceId')
    alias ${role}-${index}='aws ssm start-session --target ${instanceid}'
  done
done