pipeline {
    agent any
    
    environment {
        install = "docker exec node npm install --save-dev jest"
        test = "docker exec node npm test"
    }

    stages {
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

         stage('webhook-tigger-test') {
            steps {
                echo "Successfully webhook-tigger-testing ..."
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