pipeline {
    agent any
    stages {
       stage('start') {
          steps {
            echo 'jenkins构建开始...'
          }
        }
       stage('build') {
          steps {
            sh 'sh deploy.sh'
          }
        }
    }
   post {
       success {
            echo 'jenkins构建成功'
          }
       failure {
            echo 'jenkins构建失败'
          }
    }
}
