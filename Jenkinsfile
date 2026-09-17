@Library('xmos_jenkins_shared_library@v0.54.0') _

getApproval()

pipeline {
    agent {
        label 'linux&&64'
    }
    options {
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timestamps()
        buildDiscarder(xmosDiscardBuildSettings())
    }
    parameters {
        string(
            name: 'TOOLS_VERSION',
            defaultValue: '15.3.1',
            description: 'The XTC tools version'
        )
    }
    stages {
        stage('Checkout') {
            steps {
                println "Stage running on ${env.NODE_NAME}"
                script {
                    def (server, user, repo) = extractFromScmUrl()
                    env.REPO_NAME = repo
                }
                dir(REPO_NAME){
                    checkoutScmShallow()
                }
            }
        }  // stage('Checkout')

        stage('Library checks') {
            steps {
                warnError("Repo checks failed")
                {
                    runRepoChecks("${WORKSPACE}/${REPO_NAME}")
                }
            }
        } // stage('Library checks')

        stage('Tests') {
            steps {
                dir("${REPO_NAME}/test") {
                    createVenv(reqFile: 'requirements.txt')
                    withVenv {
                        withTools(params.TOOLS_VERSION) {
                            runPytest()
                        }
                    }
                }
            }
        } // stage('Tests')
    }

    post {
        cleanup {
            xcoreCleanSandbox()
        }
    }
}
