stage 'Checkout'

node {
    checkout(scm)
    stash 'source'
}

stage 'Tests'

parallel(
    knapsack(2) {
        node {
            withCleanup {
                unstash 'source'
                withRvm('ruby-2.3.1') {
                    sh 'bundle install'
                    sh 'bundle exec rake knapsack:rspec'
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

// Helper functions

def withCleanup(Closure cl) {
    deleteDir()
    try {
        cl()
    } finally {
        deleteDir()
    }
}

def withRvm(version, cl) {
    withRvm(version, "executor-${env.EXECUTOR_NUMBER}") {
        cl()
    }
}

def withRvm(version, gemset, cl) {
    RVM_HOME='$HOME/.rvm'
    paths = [
        "$RVM_HOME/gems/$version@$gemset/bin",
        "$RVM_HOME/gems/$version@global/bin",
        "$RVM_HOME/rubies/$version/bin",
        "$RVM_HOME/bin",
        "${env.PATH}"
    ]
    def path = paths.join(':')
    withEnv(["PATH=${env.PATH}:$RVM_HOME", "RVM_HOME=$RVM_HOME"]) {
        sh "set +x; source $RVM_HOME/scripts/rvm; rvm use --create --install --binary $version@$gemset"
    }
    withEnv([
        "PATH=$path",
        "GEM_HOME=$RVM_HOME/gems/$version@$gemset",
        "GEM_PATH=$RVM_HOME/gems/$version@$gemset:$RVM_HOME/gems/$version@global",
        "MY_RUBY_HOME=$RVM_HOME/rubies/$version",
        "IRBRC=$RVM_HOME/rubies/$version/.irbrc",
        "RUBY_VERSION=$version"
        ]) {
            sh 'gem install bundler'
            cl()
        }
    }
