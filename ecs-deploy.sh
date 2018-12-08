#!/bin/sh
#
# Tells the ECS service to force a new rolling deployment. This will cause
# it to spin up however many new tasks from the `latest`-tagged container,
# insert them into the task pool, and then remove the old ones.
#

source ./env.sh

aws ecs update-service \
    --profile $AWS_PROFILE \
    --region $AWS_REGION \
    --cluster $ECS_CLUSTER \
    --service $ECS_SERVICE \
    --desired-count $TASK_COUNT \
    --force-new-deployment \
