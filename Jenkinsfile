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
                withEnv (["AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}", "AWS_ACCOUNT=${env.AWS_ACCOUNT}", "AWS_REPOSITORY=${env.BACKEND_AWS_REPOSITORY}"]) {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                    sh "docker build -t ${AWS_REPOSITORY} ."
                    sh "docker tag ${AWS_REPOSITORY} ${AWS_REPOSITORY}:match_history.${VERSION}-${env.BUILD_ID}"
                    sh "docker push ${AWS_REPOSITORY}:match_history.${VERSION}-${env.BUILD_ID}"
                }
            }
        }
        stage ('Deploy') {
            steps {
                //withEnv (["MYSQL_USERNAME=${env.MYSQL_USERNAME}", "MYSQL_PASSWORD=${env.MYSQL_PASSWORD}", "MYSQL_HOST=${env.MYSQL_HOST}", "MYSQL_DB=${env.MYSQL_DB}"]) {
                    sh "aws eks update-kubeconfig --name riotgames-qa-cluster"
                    sh "helm uninstall riotgames-frontend -n frontend"
                    sh "helm repo add riotgames-frontend-chart https://smithcloud.github.io/riotgames-frontend-chart/"
                    sh "helm repo update"
                    sh "helm install riotgames-frontend --set match_history.image='226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/riotgames-frontend:match_history.1.0-31' --set match_history.value='http://riotgames-qa-backend-1677050497.ap-northeast-2.elb.amazonaws.com' riotgames-frontend-chart/charts -n frontend"
                //}
            }
        }
    }
}
