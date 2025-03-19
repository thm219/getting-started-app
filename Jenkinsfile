pipeline {
    agent any
    
    environment {
        install = "docker exec node sh -c 'npm install --save-dev jest'"
        test = "docker exec node sh -c 'npm test'"
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