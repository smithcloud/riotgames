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
                //withEnv (["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}", "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}", "AWS_ACCOUNT=${env.AWS_ACCOUNT}"]) {
                    sh "aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com"
                    sh "docker build -t dev-backend-repo ."
                    sh "docker tag dev-backend-repo:latest 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo:latest"
                    sh "docker push 226347592148.dkr.ecr.ap-northeast-2.amazonaws.com/dev-backend-repo:latest"
                }
            }
        }
    }
}

// pipeline {
//     environment {
//         registryCredential = 'ecr-repo'
//         dockerImage = ''
//     }
//     agent any
//     stages {
//         stage('Build image') {
//             steps {
//                 sh 'docker build -t ecr-repo .'
//                 sh 'docker tag ecr-repo:latest 532003114460.dkr.ecr.ap-northeast-2.amazonaws.com/ecr-repo:latest'
//                 echo 'Build image...'
//             }
//         }
//         stage('Push to ECR') {
//             steps {
//                 script {
//                     docker.withRegistry(
//                         "https://532003114460.dkr.ecr.ap-northeast-2.amazonaws.com",
//                         registryCredential
//                     ) {
//                         sh 'docker push 532003114460.dkr.ecr.ap-northeast-2.amazonaws.com/ecr-repo:latest'
//                     }
//                 }
//             }
//         }
//         stage('Deploy to Kubernetes') {
//             steps {
//                 sh 'curl -LO https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl'
//                 sh 'chmod u+x ./kubectl'
//                 sh 'aws eks update-kubeconfig --name skills-cluster --region ap-northeast-2'
//                 sh './kubectl apply -f jenkins_deployment.yml'
//             }
//         }



