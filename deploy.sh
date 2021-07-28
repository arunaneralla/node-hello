echo "Starting to deploy docker image to an app host.."
#eval $(aws ecr get-login --no-include-email | sed 's|https://||')
DOCKER_IMAGE=container-images
IMAGE_TAG=202107
aws ecr get-login-password --region region | docker login --username AWS --password-stdin 511572627495.dkr.ecr.us-east-1.amazonaws.com
docker pull 511572627495.dkr.ecr.us-east-1.amazonaws.com/$DOCKER_IMAGE:$IMAGE_TAG
docker ps -q --filter ancestor=$DOCKER_IMAGE:$IMAGE_TAG | xargs -r docker stop
docker run -d -p 8080:8080 $DOCKER_IMAGE:$IMAGE_TAG