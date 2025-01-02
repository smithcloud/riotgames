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
        stage('Run Sonarqube') {
            environment {
                scannerHome = tool 'sonarqube-tools'; 
            }
            steps {
                withSonarQubeEnv(credentialsId: 'sonar-credentials', installationName: 'sonar-server') {
                    // Add the sonar.java.binaries property pointing to compiled classes
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=demo-project -Dsonar.sources=src -Dsonar.java.binaries=target/classes"
                }
            }
        }    
        stage ('Build') {
            steps {
                withEnv (["AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}", "AWS_ACCOUNT=${env.AWS_ACCOUNT}", "AWS_REPOSITORY=${env.BACKEND_AWS_REPOSITORY}"]) {
                    sh "chmod +x gradlew"
                    sh "./gradlew build"
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                    sh "docker build -t ${AWS_REPOSITORY} ."
                    sh "docker tag ${AWS_REPOSITORY} ${AWS_REPOSITORY}:backend.${VERSION}-${env.BUILD_ID}"
                    sh "docker push ${AWS_REPOSITORY}:backend.${VERSION}-${env.BUILD_ID}"
                }
            }
        }
        stage ('Deploy') {
            steps {
                withEnv (["AWS_REPOSITORY=${env.BACKEND_AWS_REPOSITORY}"]) {
                    sh "aws eks update-kubeconfig --name ws-qa-cluster"
                    // sh "helm uninstall ws-backend -n ws"
                    sh "helm repo add ws-backend-chart https://gmstcl.github.io/ws-backend-chart/"
                    sh "helm repo update"
                    sh "helm install ws-backend --set backend.image=${AWS_REPOSITORY}:backend.${VERSION}-${env.BUILD_ID} ws-backend-chart/ws-backend -n ws"
                    sh "kubectl get pods -n ws"
                }
            }
        }
    }
}
