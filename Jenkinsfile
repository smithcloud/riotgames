pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        VERSION = sh(script: 'cat VERSION', returnStdout: true).trim()
        SONAR_HOST_URL = 'http://43.202.94.145:9000'
        SONAR_AUTH_TOKEN = credentials('jenkins-sonar')
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
        stage('Docker Build & Push') {
            steps {
                withEnv([
                    "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}",
                    "AWS_ACCOUNT=${env.AWS_ACCOUNT}",
                    "AWS_REPOSITORY=${env.BACKEND_AWS_REPOSITORY}"
                ]) {
                    sh "chmod +x gradlew"
                    sh "./gradlew build"
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                    sh "docker build -t ${AWS_REPOSITORY} ."
                    sh "docker tag ${AWS_REPOSITORY} ${AWS_REPOSITORY}:backend.${VERSION}-${env.BUILD_ID}"
                    sh "docker push ${AWS_REPOSITORY}:backend.${VERSION}-${env.BUILD_ID}"
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                    sh '''
                    mvn clean verify sonar:sonar \
                    -Dsonar.projectKey=demo \
                    -Dsonar.projectName="Demo Project" \
                    -Dsonar.host.url=$SONAR_HOST_URL \
                    -Dsonar.login=$SONAR_AUTH_TOKEN
                    '''
                    echo 'SonarQube Analysis Completed'
            }
        }
        stage('Deploy') {
            steps {
                withEnv(["AWS_REPOSITORY=${env.BACKEND_AWS_REPOSITORY}"]) {
                    sh "aws eks update-kubeconfig --name ws-qa-cluster"
                    sh "helm repo add ws-backend-chart https://gmstcl.github.io/ws-backend-chart/"
                    sh "helm repo update"
                    sh "helm uninstall ws-backend -n ws"
                    sh "helm install ws-backend --set backend.image=${AWS_REPOSITORY}:backend.${VERSION}-${env.BUILD_ID} ws-backend-chart/ws-backend -n ws"
                    sh "sleep 20"
                    sh "kubectl get pods -n ws"
                    sh "kubectl exec -it deployment/backend -n ws -- /bin/bash"
                    sh "curl -w %{http_code} localhost:8080/api/health"
                }
            }
        }
    }
}
