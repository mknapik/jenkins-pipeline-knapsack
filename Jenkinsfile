stage 'Checkout'

node {
    withCleanup {
        checkout(scm)
        stash 'source'
    }
}

stage 'Tests'

parallel(
    knapsack(2) { ci_node_index, ci_node_total ->
        node('docker') {
            withCleanup {
                unstash 'source'
                docker.image('ruby:2.3').inside("-e CI_NODE_INDEX=${ci_node_index} -e CI_NODE_TOTAL=${ci_node_total}") {
                    sh 'bundle install --frozen'
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
            cl(index, ci_node_total)
        }
    }

    return nodes;
}

def withCleanup(Closure cl) {
    deleteDir()
    try {
        cl()
    } finally {
        deleteDir()
    }
}
