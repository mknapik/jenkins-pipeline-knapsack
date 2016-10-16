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
                sh 'bundle install --frozen --deployment'
                sh 'bundle exec rake knapsack:rspec'
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
