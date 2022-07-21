#!/bin/bash

## Set the following ##
#######################
# Note: A list of the current ASG's can be found with the following command
# `aws autoscaling describe-auto-scaling-groups | jq '.[] | .[] | (.AutoScalingGroupName) + " " + .Instances[0].InstanceType'`
# ENV is set to pickup from your aws configuration, however this can be hard-coded if you wish.  

ENV="simplebet-np-cc" 
FUNCTION="data"
####################


printf "\n\033[0;35m**** Starting script ****\033[0m\n\n"

printf "ENV: \033[0;33m${AWS_PROFILE}\033[0m\n"
printf "FUNCTION: \033[0;33m${FUNCTION}\033[0m\n\n"

read -p "Continue?(y|n): " CONTINUE

case "${CONTINUE}" in
  y|Y)
    echo "" > /dev/null 2>&1
  ;;
  n|N)
    printf "\n\033[0;35mExiting script\n\n\033[0m"
    exit 0
  ;;
  esac

for NG in $(aws eks list-nodegroups --cluster-name "${ENV}" | jq -r '.nodegroups[]')
  do
    # Get the instance type
    INSTANCE_TYPE=$(aws eks describe-nodegroup --cluster-name "${ENV}" --nodegroup-name "${NG}" | jq -r '.[].tags."k8s.io/cluster-autoscaler/node-template/label/instance"')
    ASG=$(aws eks describe-nodegroup --cluster-name "${ENV}" --nodegroup-name "${NG}" | jq -r '.[].resources.autoScalingGroups[0].name')
  
    # Define the list of tags to apply to the ASG - defined here to take advantage of the output from the var $INSTANCE_TYPE
    TAG_LIST="Key=\"k8s.io/cluster-autoscaler/enabled\",Value=true Key=\"k8s.io/cluster-autoscaler/${ENV}\",Value=owned Key=\"kubernetes.io/cluster/${ENV}\",Value=owned Key=\"k8s.io/cluster-autoscaler/node-template/taint/function=${FUNCTION}\",Value=NoSchedule Key=function,Value=${FUNCTION} Key=\"k8s.io/cluster-autoscaler/node-template/label/instance\",Value=${INSTANCE_TYPE}"
    printf "\nUpdating tags on:\n ASG: \033[0;33m${ASG}\n\033[0m NG: \033[0;33m${NG}\033[0m\n"

    # Add all tags to this node_group's ASG
    for TAG in ${TAG_LIST}
      do
        #echo "${TAG}"
        aws autoscaling create-or-update-tags --tags ResourceId="${ASG}",ResourceType=auto-scaling-group,${TAG},PropagateAtLaunch=true --region=us-east-1
    done

    printf " New tags:\n"
    aws autoscaling describe-tags --filters Name=auto-scaling-group,Values="${ASG}" | jq -r '.Tags[] | "  " + (.Key) + " : " + .Value'

done

printf "\n\033[0;35m**** End Script ******\033[0m\n\n"