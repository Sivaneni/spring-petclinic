pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh '''
                export JAVA_HOME=/opt/java/openjdk
                export PATH=$JAVA_HOME/bin:$PATH
                echo "JAVA_HOME is set to $JAVA_HOME"
                java -version
                ./mvnw clean package
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-scanner') {
                    sh '''
                    export JAVA_HOME=/opt/java/openjdk
                    export PATH=$JAVA_HOME/bin:$PATH
                    echo "JAVA_HOME is set to $JAVA_HOME"
                    java -version
                    ./mvnw verify sonar:sonar -Dsonar.projectKey=PetClinic -Dsonar.projectName="PetClinic"
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t sahera1987143/petclinic:${BUILD_NUMBER} .'
            }
        }

        stage('Scan Image') {
            steps {
                sh 'trivy image --scanners vuln sahera1987143/petclinic:${BUILD_NUMBER}'
            }
        }

        stage('Docker Push') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub', url: '') {
                    sh 'docker push sahera1987143/petclinic:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s1', namespace: '', serverUrl: '']]) {
