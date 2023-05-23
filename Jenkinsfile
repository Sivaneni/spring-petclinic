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

    stage('scan image') {
      steps {
        neuvector nameOfVulnerabilityToExemptFour: '',
        nameOfVulnerabilityToExemptOne: '', nameOfVulnerabilityToExemptThree: '', 
        nameOfVulnerabilityToExemptTwo: '', nameOfVulnerabilityToFailFour: '', nameOfVulnerabilityToFailOne: '', 
        nameOfVulnerabilityToFailThree: '', nameOfVulnerabilityToFailTwo: '', numberOfHighSeverityToFail: '', 
        numberOfMediumSeverityToFail: '', registrySelection: 'Local', repository: 'harbor.10-35-151-40.nip.io/test/petclinic', 
        scanLayers: true, scanTimeout: 10, tag: '${BUILD_NUMBER}'
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
          sh '''kubectl create deployment --image=harbor.10-35-151-40.nip.io/test/petclinic:${BUILD_NUMBER} petclinic  --dry-run=client -o yaml |kubectl apply -f -

kubectl expose deploy petclinic --port=8080 --external-ip=10.35.151.198 --dry-run=client -o yaml |kubectl apply -f -'''
        }

      }
    }

  }
}
