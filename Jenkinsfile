pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    AWS_DEFAULT_REGION = "us-east-1"
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
    
    stage('Run Ansible') {
      steps {
        sh 'ansible-playbook -i inventory playbook.yml'
      }
    }
    
    stage('Destroy Infrastructure') {
      steps {
        input message: 'Click "Destroy" to proceed', parameters: [
          [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Destroy infrastructure?', name: 'CONFIRM_DESTROY']
        ]
        script {
          if (params.CONFIRM_DESTROY) {
            sh 'terraform destroy -auto-approve'
          } else {
            echo 'Infrastructure destruction skipped.'
          }
        }
      }
    }
  }
}

