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

        stage('Push') {
            agent any
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    sh '''
                        docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}
                        docker image tag ${docker_image}:v1
                        dockr push ${docker_image}:v1
                    '''
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