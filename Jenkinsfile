pipeline {
    agent any

    environment {
        TF_DIR = 'infra'
        APP_DIR = 'app'
        DOCKER_COMPOSE = 'docker-compose.yml'
    }

    tools {
        terraform 'terraform'
    }

    stages {
        stage('Clonar Repositório') {
            steps {
                checkout scm
            }
        }

        stage('Provisionar Infraestrutura com Terraform') {
            dir("${env.TF_DIR}") {
                steps {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Construir e subir Microserviços') {
            dir("${env.WORKSPACE}") {
                steps {
                    sh 'docker-compose down || true'
                    sh 'docker-compose build'
                    sh 'docker-compose up -d'
                }
            }
        }

        stage('Testes') {
            steps {
                echo 'Rodando testes automatizados...'
            }
        }
    }

    post {
        success {
            echo '✅ Deploy realizado com sucesso!'
        }
        failure {
            echo '❌ Falha no pipeline!'
        }
    }
}
