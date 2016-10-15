stage 'Checkout'

node {
    withCleanup {
        checkout(scm)
        stash 'source'
    }
}

stage 'Tests'

parallel(
    knapsack(2) {
        node('docker') {
            withCleanup {
                unstash 'source'

                withMysql { mysqlLink, dbHostName ->
                    withRuby('2.3', "-e CI_NODE_INDEX=${env.CI_NODE_INDEX} -e CI_NODE_TOTAL=${env.CI_NODE_TOTAL} --link=${mysqlLink}") {
                        withEnv(["MYSQL_HOST=$dbHostName"]) {
                            sh "bundle install --quiet --frozen"
                            sh 'bundle exec rake knapsack:rspec'
                        }
                    }
                }
            }
        }
    }
)

def knapsack(ci_node_total, cl) {
    def nodes = [:]

    for(int i = 0; i < ci_node_total; i++) {
        def index = i;
        nodes["ci_node_${i}"] = {
            withEnv(["CI_NODE_INDEX=$index", "CI_NODE_TOTAL=$ci_node_total"]) {
                cl()
            }
        }
    }

    return nodes;
}

def withRuby(String rubyVersion, String opts = '', Closure cl) {
    docker.image('ruby:2.3').inside("-u root ${opts}") {
        cl()
    }
}

def withMysql(cl) {
    docker.image('mysql:5.6').withRun("-e MYSQL_ALLOW_EMPTY_PASSWORD=1") { mysqlContainer ->
        cl("${mysqlContainer.id}:db_host", "db_host")
    }
}

def withCleanup(Closure cl) {
    deleteDir()
    try {
        cl()
    } finally {
        deleteDir()
    }
}
