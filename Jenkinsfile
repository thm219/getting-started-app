pipeline {
    agent any
    
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
                  docker exec -it node sh -c "npm install --save-dev jest"
                  docker exec node sh -c "npm test"
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