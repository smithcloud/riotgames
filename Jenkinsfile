pipeline { 
    agent any
    stage {
      stage ('Build') {
        steps {
          sh 'printenv'
        }
      }
      stage ('Publish ECR') {
        steps {
          withEnv (["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}", "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}", "AWS_ACCOUNT"=${env.AWS_ACCOUNT}"]) {
            sh 'aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
          }
        }
      }
    }
  }
}
