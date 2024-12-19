pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'printenv'
            }
        }
        stage ('Publish ECR') {
            steps {
                withEnv (["AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}", "AWS_ACCOUNT=${env.AWS_ACCOUNT}", "AWS_REPOSITORY=${env.AWS_REPOSITORY}"]) {
                    sh "aws ecr get-login-password --region $(AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.$(AWS_DEFAULT_REGION}.amazonaws.com"
                    sh "docker build -t ${env.AWS_REPOSITORY} ."
                    sh "docker tag ${env.AWS_REPOSITORY} ${env.AWS_REPOSITORY}:champions.v1.${env.BUILD_ID}"
                    sh "docker push ${env.AWS_REPOSITORY}:champions.v1.${env.BUILD_ID}"
                }
            }
        }
    }
}