@Library('xmos_jenkins_shared_library@v0.54.0') _

def localRunPytest(String extra_args="") {
    catchError{
        sh "python -m pytest --junitxml=pytest_result.xml -rA -v --durations=0 -o junit_logging=all ${extra_args}"
    }
    junit "pytest_result.xml"
}

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
    environment {
        REPO = 'xmos_cmake_toolchain'
        PYTHON_VERSION = "3.10.5"
        VENV_DIRNAME = ".venv"
    }

    stages {
        stage('Checkout') {
            steps {
                println "Stage running on ${env.NODE_NAME}"
                script {
                    def (server, user, repo) = extractFromScmUrl()
                    env.REPO_NAME = repo
                    env.REPO = repo
                }
                dir(REPO_NAME){
                    checkoutScmShallow()
                }
            }
        }  // stage('Checkout')

        stage ("Create Python environment") {
            steps {
                dir("${REPO}") {
                    createVenv(reqFile: 'requirements.txt')
                }
            }
        }
        stage('Library checks') {
            steps {
                warnError("Repo checks failed")
                {
                    runRepoChecks("${WORKSPACE}/${REPO}")
                }
            }
        }

        stage('Tests') {
            steps {
                dir("${REPO}/test") {
                    withVenv {
                        withTools(params.TOOLS_VERSION) {
                            sh 'tox run'
                            runPytest()
                        }
                    }
                }
            }
        }
    }

    post {
        cleanup {
            xcoreCleanSandbox()
        }
    }
}
