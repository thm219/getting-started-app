pipeline {
    agent any
    
    environment {
        install = "docker exec node npm install --save-dev jest"
        test = "docker exec node npm test"
        image = "getting-node-js"
        docker_image = "thm007/getting-node-js"
        container_name = "node"
        version_image = "2"
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
                  docker build -t ${image} .
                  docker run -d --name ${container_name} ${image}
                '''
            }
        }

        stage('test') {
            steps {
                echo "test pipeline"
                sh '''
                  ${install}
                  ${test}
                  docker stop ${container_name}
                  docker rm ${container_name}
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
                    sh 'docker image tag ${image} ${docker_image}:{version_image}'
                    // Push the image
                    sh 'docker push ${docker_image}:{version_image}'
                    }
                }
            }
        }
    }
    
    /*post {
        always {
            sh '''
            docker stop ${container_name}
            docker rm ${container_name}
            '''
        }
    }
    */

    post {
        always {
            emailext (
                subject: "Pipeline Status: ${BUILD_NUMBER}",
                body: '''<html>
                            <body>
                                <p>Build Status: ${BUILD_STATUS}</p>
                                <p>Build Number: ${BUILD_NUMBER}</p>
                                <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
                            </body>
                        </html>''',
                to: 'thiha.min.sys@gmail.com,thm219007@gmail.com',
                from: 'thiha.min.sys@gmail.com',
                replyTo: 'thiha.min.sys@gmail.com',
                mimeType: 'text/html'
                )
            }
    }
}