pipeline {
    agent any
    environment {
        dockerImage = ''
        registry = 'taurus01/cicdjenkins'
        registryCredential = 'dockerhub/taurus01'
    }
    stages {
         stage('Git Clone') {
            steps {
                    checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'Github', url: 'https://github.com/Taurusyegani/qadevops.git']]])
        }
    }

        stage('Build Image') {
            steps {
             script {
                    dockerImage = docker.build registry
            }
        }
    }
        stage('Test') {
            steps {
                echo "Testing..."
            }
       
        }
        stage('DockerHub Upload') {
            steps {
             script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
            }
        }
    }
}


     stage('Docker stop container') {
         steps {
            sh 'docker ps -f atlanticblogContainer -q | xargs --no-run-if-empty docker container stop'
            sh 'docker container ls -a -fatlanticblogContainer -q | xargs -r docker container rm'
         }
       }
    
    
    // Running Docker container
    stage('Docker Run') {
     steps{
         script {
            dockerImage.run("-p 5000:5000 --rm --name atlanticblogContainer")
         }
      }
    }
  }
}
