pipeline {
    agent any
    environment {
        VERSION = """${sh(
                     returnStdout: true,
                     script: 'cat VERSION'
                     )}"""
    }
    stages {
        stage('Pre-Build') {
            steps {
                sh 'aws --version'
                sh 'docker --version'
            }
        }
        stage ('Build') {
            steps {
                withEnv (["AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}", "AWS_ACCOUNT=${env.AWS_ACCOUNT}", "AWS_REPOSITORY=${env.AWS_REPOSITORY}"]) {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                    sh "docker build -t ${AWS_REPOSITORY} ."
                    sh "docker tag ${AWS_REPOSITORY} ${AWS_REPOSITORY}:champions.${VERSION}-${env.BUILD_ID}"
                    sh "docker push ${AWS_REPOSITORY}:champions.${VERSION}-${env.BUILD_ID}"
                }
            }
        }
    }
}

    stages {
        stage('Pre-Build') {
            steps {
                sh 'VERSION="1.0.0"'
                sh 'echo $VERSION > profile'
            }
        }
        stage ('Build') {
            steps {
                sh 'env'
            }
        }
    }