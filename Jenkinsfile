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
          withEnv (["AWS_ACCESS_KEY_ID=${{secrets.AWS_ACCESS_KEY_ID}}", "AWS_SECRET_ACCESS_KEY=${{secrets.AWS_SECRET_ACCESS_KEY}}", "AWS_DEFAULT_REGION=${{secrets.AWS_DEFAULT_REGION}}", "AWS_ACCOUNT"=${{secrets.AWS_ACCOUNT}}"]) {
            sh 'aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
}
