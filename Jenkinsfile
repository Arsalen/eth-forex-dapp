pipeline {

    agent any

    parameters {

        name: "START", choices: ["NO", "YES"], description: "To start or not to start"
    }

    stages {

        stage("SETUP") {

            when {
                expression {
                    !fileExists(".env") && !fileExists("config/app.config.json") && !fileExists("config/key.store.json")
                }

                steps {

                    withCredentials([
                        file(credentialsId: ".env", variable: "environment"),
                        file(credentialsId: "config", variable: "configuration"),
                        file(credentialsId: "key", variable: "keystore"),
                    ]) {

                        sh "cp \$environment .env"
                        sh "cp \$configuration config/app.config.json"
                        sh "cp \$keystore config/key.store.json"
                    }
                }
            }
        }

        stage("COMPILE") {

            sh "truffle compile"            
        }

        stage("MIGRATE") {

            when {
                expression {
                    params.START == "YES"
                }
            }

            sh "truffle migrate"
        }
    }
}