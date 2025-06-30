Plataforma Simples de Cadastro de Usuários com CI/CD e Deploy na AWS


🔧 Descrição Geral
Crie uma aplicação de cadastro de usuários dividida em dois microserviços:

Serviço de Autenticação (auth-service)

Serviço de Usuário (user-service)

Esses microserviços serão:

Containerizados com Docker

Armazenados em repositórios separados no GitHub

Implantados na AWS (via EC2 ou ECS)

Gerenciados via Terraform (infraestrutura)

Automatizados com Jenkins (CI/CD)



📁 Estrutura de Pastas do Projeto
projeto-devops/
├── README.md
├── docker-compose.dev.yml
├── .gitignore
│
├── infra/                       # Terraform: infraestrutura na AWS
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── modules/
│   │   ├── vpc/
│   │   ├── ec2/
│   │   ├── rds/
│   │   └── ecs/ (opcional)
│
├── jenkins/
│   ├── Jenkinsfile              # Pipeline as Code
│   ├── scripts/
│   │   ├── deploy.sh            # Scripts de deploy remoto
│   │   └── build_push.sh        # Build e push Docker
│
├── services/                    # Microserviços (cada um em repositório separado ou subpasta)
│   ├── auth-service/
│   │   ├── Dockerfile
│   │   ├── app/                 # Código fonte
│   │   │   ├── main.py          # Exemplo com FastAPI
│   │   │   └── requirements.txt
│   │   └── .env
│   │
│   └── user-service/
│       ├── Dockerfile
│       ├── app/
│       │   ├── main.py
│       │   └── requirements.txt
│       └── .env
│
└── scripts/                     # Scripts auxiliares
    ├── provision_infra.sh       # Terraform init, plan, apply
    └── destroy_infra.sh





📝 Explicação dos Arquivos e Pastas
🔧 infra/ (Terraform)
main.tf: configuração principal (chama módulos, cria recursos).

variables.tf: variáveis para personalizar a infraestrutura (e.g. tipo de instância, nome da VPC).

outputs.tf: valores que o Terraform deve mostrar após apply (ex: IP da EC2, endpoint do RDS).

provider.tf: configuração do provedor AWS + autenticação.

modules/: código reutilizável para componentes (VPC, EC2, RDS, ECS...).

🛠️ jenkins/
Jenkinsfile: pipeline declarativa com estágios como build, test, dockerize, deploy.

scripts/build_push.sh: script que o Jenkins chama para buildar imagem e dar push no Docker Hub ou ECR.

scripts/deploy.sh: deploy remoto usando scp + ssh para EC2 ou aws ecs update-service.

🧩 services/
Contém os microserviços (pode ser em Node.js, Python, etc).

Cada serviço tem:

Dockerfile: define como a imagem Docker do serviço será construída.

app/: código do microserviço (ex: APIs com FastAPI, Flask, Express).

.env: variáveis de ambiente sensíveis como DB_HOST, JWT_SECRET.

🧰 scripts/
provision_infra.sh: faz terraform init, plan e apply.

destroy_infra.sh: faz terraform destroy.







🚀 Etapas a Implementar
1. Infraestrutura (infra/)
 Criar VPC com subnets públicas e privadas

 Criar instância EC2 (ou ECS) para os serviços

 Criar banco RDS PostgreSQL

 Criar SGs para comunicação entre instâncias

2. Microserviços (services/)
 Microserviço de autenticação com geração de JWT

 Microserviço de usuários com CRUD

 Dockerfile funcional para ambos

 docker-compose.dev.yml para rodar localmente

3. CI/CD com Jenkins
 Jenkinsfile com etapas:

checkout do código

build das imagens

push para Docker Hub / ECR

deploy via SSH ou ECS CLI

 Automatizar docker build e docker push