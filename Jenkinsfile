pipeline {
    agent any
    
    environment {
        install = "docker exec node npm install --save-dev jest"
        test = "docker exec node npm test"
    }

    stages {

        stage('SCM') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script{
                    def scannerHome = tool name: 'sonar', type: 'hudson.plugins.sonar.SonarRunnerInstallation';
                    withSonarQubeEnv() {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        stage('build') {
            steps {
                echo "build Pipeline"
                sh '''
                  docker build -t getting-start-app .
                  docker run -d --name node getting-start-app
                '''
            }
        }

        stage('test') {
            steps {
                echo "test pipeline"
                sh '''
                  ${install}
                  ${test}
                '''
            }
        }

        stage('push image') {
            steps {
                echo "push image staging"
            }
        }
    }

    post {
        always {
            sh '''
            docker stop node
            docker rm node
            '''
        }
    }
}