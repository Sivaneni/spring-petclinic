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
        sh 'docker build -t sahera1987143/petclinic:${BUILD_NUMBER} .'
      }
    }

    stage('scan image') {
      steps {
        sh 'trivy image --scanners vuln sahera1987143/petclinic:${BUILD_NUMBER}'
      }
    }
    stage('docker push') {
      steps {
        withDockerRegistry(credentialsId: 'dockerhub', url: '') {
        sh 'docker push sahera1987143/petclinic:${BUILD_NUMBER}'
        }
      }
    }

    stage('deploy') {
      steps {
        withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s1', namespace: '', serverUrl: '']]) {
          sh '''kubectl create deployment --image=sahera1987143/petclinic:${BUILD_NUMBER} petclinic  --dry-run=client -o yaml |kubectl apply -f -
          kubectl expose deploy petclinic --port=8080 --dry-run=client -o yaml |kubectl apply -f -'''
        }

      }
    }

  }
}
