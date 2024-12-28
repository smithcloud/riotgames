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
                sh 'eksctl version'
                sh 'kubectl version --client'
            }
        }
        stage ('Build') {
            steps {
                withEnv (["AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}", "AWS_ACCOUNT=${env.AWS_ACCOUNT}", "AWS_REPOSITORY=${env.FRONTEND_AWS_REPOSITORY}"]) {
                    sh "docker pull node:22-alpine"
                    sh "docker run -it --rm --entrypoint sh node:22-alpine"
                    sh "node -v"
                    sh "npm -v"
                    sh "npm i"
                    sh "NODE_OPTIONS=--openssl-legacy-provider npm run build"
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                    sh "docker build -t ${AWS_REPOSITORY} ."
                    sh "docker tag ${AWS_REPOSITORY} ${AWS_REPOSITORY}:champions.${VERSION}-${env.BUILD_ID}"
                    sh "docker push ${AWS_REPOSITORY}:match_history.${VERSION}-${env.BUILD_ID}"
                }
            }
        }
    }
}
