// pipeline {
//     agent any
//     stages {
//         stage('Build') {
//             steps {
//                 sh 'printenv'
//             }
//         }
//         stage ('Publish ECR') {
//             steps {
//                 withEnv (["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}", "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}", "AWS_ACCOUNT=${env.AWS_ACCOUNT}"]) {
//                     sh "aws ecr get-login-password --region ${env.AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com"
//                     sh "docker build -t dev-backend-repo ."
//                     sh "docker tag dev-backend-repo:latest 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo:latest"
//                     sh "docker push 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo:latest"
//                 }
//             }
//         }
//     }
// }

pipeline {
   tools {
        maven 'Maven'
    }
    agent {label 'slave-node-label'}
    environment {
        registry = "226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo"
    }    
        stage ('Build') {
          steps {
            sh 'mvn clean install'           
            }
        }
        
            // Building Docker images
        stage('Building image') {
          steps{
            script {
              sh 'docker build -t 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo:v1.$BUILD_ID .'
              sh 'docker tag 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo:v1.$BUILD_ID 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo:v1.$BUILD_ID'
             }
           }
         }
   
    // Uploading Docker images into AWS ECR
       stage('Pushing to ECR') {
         steps{  
           script {
             sh 'aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com' 
             sh 'docker push 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo:v1.$BUILD_ID'
             sh 'docker rmi 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo:v1.$BUILD_ID 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo:v1.$BUILD_ID' // Delete docker images from server 
           }
          }
         }
    }
}