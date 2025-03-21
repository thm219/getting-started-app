pipeline {
    agent any
    
    environment {
        install = "docker exec node npm install --save-dev jest"
        test = "docker exec node npm test"
        docker_image = "thm007/getting-node-js"
        container_name = "node"
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
                  docker build -t ${docker_image} .
                  docker run -d --name ${container_name} ${docker_image}
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

        stage('Push to Docker Hub') {
            steps {
                // Use withCredentials to access Docker Hub credentials
                withCredentials([usernamePassword(credentialsId: 'dockerHub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                    // Log in to Docker Hub
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker build -t ${docker_image}:v1'
                    // Push the image
                    sh 'docker push ${docker_image}:v1'
                    }
                }
            }
        }
    }
    
    post {
        always {
            sh '''
            docker stop ${container_name}
            docker rm ${container_name}
            '''
        }
    }
}