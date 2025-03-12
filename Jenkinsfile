pipeline {
  agent any

  stages {  
    
    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv(credentialsId:'sonarqube',installationName:'sonarqube')  {
          sh "./mvnw clean verify sonar:sonar -Dsonar.projectKey=PetClinic -Dsonar.projectName='PetClinic'"
        }
      }
    }
    
    stage('build') {
      steps {
        sh './mvnw package'
      }
    }

    stage('docker build') {
      steps {
        sh 'docker build -t harbor.10-35-151-40.nip.io/test/petclinic:${BUILD_NUMBER} .'
      }
    }

    stage('scan image') {
      steps {
        sh 'trivy image harbor.10-35-151-40.nip.io/test/petclinic:${BUILD_NUMBER}'
      }
    }
    stage('docker push') {
      steps {
        withDockerRegistry(credentialsId: 'admin-Harbor', url: 'https://harbor.10-35-151-40.nip.io/') {
        sh 'docker push harbor.10-35-151-40.nip.io/test/petclinic:${BUILD_NUMBER}'
        }
      }
    }

    stage('deploy') {
      steps {
        withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: '', contextName: '', credentialsId: 'prdrke2-k8s', namespace: '', serverUrl: '']]) {
          sh '''kubectl create deployment -n pet --image=harbor.10-35-151-40.nip.io/test/petclinic:${BUILD_NUMBER} petclinic  --dry-run=client -o yaml |kubectl apply -f -
          kubectl expose deploy petclinic -n pet --port=8080 --external-ip=10.35.151.198 --dry-run=client -o yaml |kubectl apply -f -'''
        }

      }
    }

  }
}
