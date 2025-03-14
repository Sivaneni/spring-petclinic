pipeline {
    agent any
    environment {
        JAVA_HOME = '/opt/java/openjdk' // Verify this path is correct for your Java installation
        PATH = "${JAVA_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Build') {
            steps {
                sh './mvnw clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-scanner') {
                    sh './mvnw verify sonar:sonar -Dsonar.projectKey=PetClinic -Dsonar.projectName="PetClinic"'
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
                    sh '''
                    kubectl create deployment --image=sahera1987143/petclinic:${BUILD_NUMBER} petclinic --dry-run=client -o yaml | kubectl apply -f -
                    kubectl expose deploy petclinic --port=8080 --type=NodePort --dry-run=client -o yaml | kubectl apply -f
