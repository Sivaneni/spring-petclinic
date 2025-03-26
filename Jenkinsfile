pipeline {
  agent any

  stages {  
     stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/Sivaneni/spring-petclinic.git']]])
            }
        }
    
    stage('SonarQube Analysis') {
  steps {
    withSonarQubeEnv(credentialsId:'sonar-token',installationName:'sonar-scanner')  {
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
        sh 'docker build -t sprasanna1992/petclinic:${BUILD_NUMBER} .'
      }
    }

    stage('scan image') {
      steps {
        sh 'trivy image --ignore-unfixed sprasanna1992/petclinic:32'
      }
    }
    stage('docker push') {
      steps {
        withDockerRegistry(credentialsId: 'dockerhub', url: '') {
        sh 'docker push sprasanna1992/petclinic:${BUILD_NUMBER}'
        }
      }
    }

    // stage('deploy') {
    //   steps {
    //    withCredentials([file(credentialsId: 'k8s-config', variable: 'KUBECONFIG')]) {
    //       sh '''kubectl create deployment --image=sprasanna1992/petclinic:${BUILD_NUMBER} petclinic  --dry-run=client -o yaml |kubectl apply -f -
    //       kubectl expose deploy petclinic --port=8080 --type=NodePort --dry-run=client -o yaml |kubectl apply -f -'''
    //     }

    //   }
    // }
    stage('deploy') {
      steps {
       withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://192.168.0.106:6443') {
           
          sh '''kubectl create deployment --image=sprasanna1992/petclinic:${BUILD_NUMBER} petclinic  --dry-run=client -o yaml |kubectl apply -f -
          kubectl expose deploy petclinic --port=8080 --type=NodePort --dry-run=client -o yaml |kubectl apply -f -'''
        }

      }
    }

  }
}
