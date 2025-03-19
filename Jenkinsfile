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
                  npm install --save-dev jest
                  docker exec -it node sh -c 'npm test jest'
                '''
            }
        }

    }

    post {
        always {
            docker stop node
            docker rm node
        }
    }
}