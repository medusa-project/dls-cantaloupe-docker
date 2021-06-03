#!/bin/sh
#
# Builds a Docker image and pushes it to AWS ECR.
#

source ./env.sh

eval $(aws ecr get-login --no-include-email --region $AWS_REGION --profile $AWS_PROFILE)

# add version tag
TAG=$APP_NAME:$CANTALOUPE_VERSION
docker tag $TAG $ECR_HOST/$TAG
docker push $ECR_HOST/$TAG

# add latest tag
TAG=$APP_NAME:latest
docker tag $TAG $ECR_HOST/$TAG
docker push $ECR_HOST/$TAG
