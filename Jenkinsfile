pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh './mvnw spring-boot:build-image'
      }
    }

  }
}