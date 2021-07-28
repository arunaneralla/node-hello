echo "Starting to deploy docker image to an app host.."
DOCKER_IMAGE=container-images/202107
docker pull $DOCKER_IMAGE
docker ps -q --filter ancestor=$DOCKER_IMAGE | xargs -r docker stop
docker run -d -p 8080:8080 $DOCKER_IMAGE