pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh './mvnw package'
      }
    }

    stage('docker build') {
      steps {
        sh 'docker build -t harbor.10-35-151-40.nip.io/test/petclinic:latest .'
      }
    }

    stage('docker push') {
      steps {
        sh '''docker login --username admin --password Harbor12345 harbor.10-35-151-40.nip.io

docker push harbor.10-35-151-40.nip.io/test/petclinic:latest'''
      }
    }

    stage('deploy') {
      steps {
        withKubeCredentials() {
          sh 'kubectl create deployment --image=harbor.10-35-151-40.nip.io/test/petclinic:latest petclinic '
        }

      }
    }

  }
}