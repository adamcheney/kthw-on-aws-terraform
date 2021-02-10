#!/usr/bin/env bash
aws_desc="/usr/local/bin/aws ec2 describe-instances";
jq="/usr/local/bin/jq"
jq_publicip='.Reservations[].Instances[] | select(.State.Name=="running") | .PublicIpAddress'
jq_privateip='.Reservations[].Instances[] | select(.State.Name=="running") | .PrivateIpAddress'
for instance in worker-0 worker-1 worker-2
do
  # jsonnode=$(${aws_desc} --filters "Name=tag:node,Values=${instance}")
  # extip=$(${jq} ${jq_publicip} \'${jsonnode}\')
  extip=$(${aws_desc} --filters "Name=tag:node,Values=${instance}" | ${jq} "${jq_publicip}")
  intip=$(${aws_desc} --filters "Name=tag:node,Values=${instance}" | ${jq} "${jq_privateip}")

  # intip=$(${aws_desc} --filters "Name=tag:node,Values=${instance}" | ${jq} ${jq_privateip})
  # echo "Node ${instance}:\n Ext: ${extip}\n Int: ${intip}\n"
  echo "Node:        ${instance}"
  echo "Internal IP: ${intip}"
  echo "External IP: ${extip}"
done


# aws_desc="/usr/local/bin/aws ec2 describe-instances" \
# jq="/usr/local/bin/jq" \
# jq_publicip='.Reservations[].Instances[] | select(.State.Name=="running") | .PublicIpAddress' \
# jq_privateip='.Reservations[].Instances[] | select(.State.Name=="running") | .PrivateIpAddress' \
# instance=worker-1 \
# echo "(${aws_desc} --filters \"Name=tag:node,Values=${instance}\" | ${jq} ${jq_publicip}" \
# echo $extip

# for instance in worker-0 worker-1 worker-2
# do
#   extip=$(${aws_desc} --filters "Name=tag:node,Values=${instance}" | ${jq} ${jq_publicip})
#   intip=$(${aws_desc} --filters "Name=tag:node,Values=${instance}" | ${jq} ${jq_privateip})
#   echo "Node ${instance}:\n Ext: ${extip}\n Int: ${intip}\n"
# done

