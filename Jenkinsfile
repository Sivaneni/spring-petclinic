pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh '''env
./mvnw package'''
      }
    }

    stage('docker build') {
      steps {
        sh 'docker build -t harbor.10-35-151-40.nip.io/test/petclinic:${BUILD_NUMBER} .'
      }
    }

    stage('docker push') {
      steps {
        sh '''docker login --username admin --password Harbor12345 harbor.10-35-151-40.nip.io

docker push harbor.10-35-151-40.nip.io/test/petclinic:${BUILD_NUMBER}'''
      }
    }

    stage('deploy') {
      steps {
        withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: '', contextName: '', credentialsId: 'prdrke2-k8s', namespace: '', serverUrl: '']]) {
          sh '''#kubectl create deployment --image=harbor.10-35-151-40.nip.io/test/petclinic:latest petclinic 

kubectl create deployment --image=harbor.10-35-151-40.nip.io/test/petclinic:${BUILD_NUMBER} petclinic  --dry-run -o yaml |kubectl apply -f - '''
        }

      }
    }

  }
}