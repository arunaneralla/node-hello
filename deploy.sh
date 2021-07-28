echo "Starting to deploy docker image to an app host.."
DOCKER_IMAGE=container-images
IMAGE_TAG=202107
docker pull $DOCKER_IMAGE:$IMAGE_TAG
docker ps -q --filter ancestor=$DOCKER_IMAGE:$IMAGE_TAG | xargs -r docker stop
docker run -d -p 8080:8080 $DOCKER_IMAGE:$IMAGE_TAG