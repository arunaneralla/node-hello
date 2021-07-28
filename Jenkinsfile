pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="511572627495"
        AWS_DEFAULT_REGION="us-east-1" 
        IMAGE_REPO_NAME="container-images"
        IMAGE_TAG="202107"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        //GIT_URL = "https://github.com/arunaneralla/node-hello.git"
        AWS_CREDENTIALS_ID = 'awsCredentials'
        APP_HOST_USER = "ubuntu"
        APP_HOST_NAME = "52.54.71.192"
    }
   
    stages {
      /*stage('Logging into AWS ECR') {
        steps {
          script {
            sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
          }  
        }
      }*/
      //Checkout SCM
      stage('Cloning Git') {
        steps {
          checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/arunaneralla/node-hello.git']]])     
        }
      }
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
        script {
          //sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}"
          docker.withRegistry("https://${REPOSITORY_URI}", "ecr:us-east-1:${AWS_CREDENTIALS_ID}") {
            dockerImage.push()
          }
        }
      }
    }

    // Uploading Docker images into AWS ECR
    stage('Deploy to app host') {
     steps{  
        script {
          sh "scp deploy.sh ${APP_HOST_USER}@${APP_HOST_NAME}:~/"
          sh "ssh ${APP_HOST_USER}@${APP_HOST_NAME} \"chmod +x deploy.sh\""
          sh "ssh ${APP_HOST_USER}@${APP_HOST_NAME} ./deploy.sh"
        }
      }
    }
  }  
}