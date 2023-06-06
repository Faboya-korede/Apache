pipeline {
  agent {
    docker {
      image 'terraform:latest'
    }
  }

  stages {
    stage('Install Ansible') {
      steps {
        sh 'apt-get update && apt-get install -y ansible'
      }
    }

    stage('Terraform') {
      steps {
        script {
          // Run Terraform commands
          sh 'terraform init'
          sh 'terraform plan -out=tfplan'
          sh 'terraform apply -auto-approve tfplan'
        }
      }
    }
  }

  post {
    always {
      // Clean up resources
      script {
        sh 'terraform destroy -auto-approve'
      }
    }
  }
}



