begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

begin
  require 'knapsack'
  Knapsack.load_tasks
rescue LoadError
end

task default: :spec
