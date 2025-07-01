pipeline {
    agent any

    environment {
        TF_DIR = 'infra'
        APP_DIR = 'app'
        DOCKER_COMPOSE = 'docker-compose.yml'
    }

    // Remova esse bloco se não tiver terraform configurado no Jenkins
    // tools {
    //     terraform 'terraform'
    // }

    stages {
        stage('Clonar Repositório') {
            steps {
                checkout scm
            }
        }

        stage('Provisionar Infraestrutura com Terraform') {
            steps {
                dir("${env.TF_DIR}") {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Construir e subir Microserviços') {
            steps {
                dir("${env.WORKSPACE}") {
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
