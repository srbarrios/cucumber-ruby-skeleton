require 'rake'
require 'rubygems'
require 'yaml'
require 'cucumber/rake/task'
require 'rake/task'
require 'parallel'

junit_results = '-f junit -o results'
results_dir = 'results'

namespace :sequential do
  Dir.glob(File.join(Dir.pwd, 'run_sets', '*.yml')).each do |entry|
    Cucumber::Rake::Task.new(File.basename(entry, '.yml').to_sym) do |t|
      filename = File.basename(entry, '.yml').to_sym
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      sh "mkdir -p #{results_dir}", verbose: false
      json_results = "-f json -o #{results_dir}/output_#{timestamp}-#{filename}.json"
      html_results = "-f html -o #{results_dir}/output_#{timestamp}-#{filename}.html"
      cucumber_opts = %W[#{html_results} #{json_results} #{junit_results} -f rerun --out failed.txt -f pretty -r features]
      features = YAML.safe_load(File.read(entry))
      t.cucumber_opts = cucumber_opts + features unless features.nil?
    end
  end
end

namespace :parallel do
  Dir.glob(File.join(Dir.pwd, 'run_sets', '*.yml')).each do |entry|
    run_set = File.basename(entry, '.yml').to_sym
    desc "Run Cucumber #{run_set} features in parallel"
    task "#{run_set}" do
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      features = YAML.safe_load(File.read(File.join(Dir.pwd, 'run_sets', "#{run_set}.yml"))).join(' ')
      sh "mkdir -p #{results_dir}", verbose: false
      cucumber_opts = "-f html -o #{results_dir}/output_#{timestamp}-#{run_set}-$TEST_ENV_NUMBER.html -f json -o #{results_dir}/output_#{timestamp}-#{run_set}-$TEST_ENV_NUMBER.json #{junit_results} -f rerun --out failed.txt -f pretty -r features "
      sh "bundle exec parallel_cucumber -n 5 -o '#{cucumber_opts}' #{features}"
    end
  end
end

namespace :utils do
  desc 'Generate test report'
  task :generate_test_report do
    sh 'rm -rf ./cucumber_report && mkdir cucumber_report', verbose: false
    sh "cd #{results_dir}; timeout 180 bash -c -- 'while find output*.json -type f -size 0 | grep json; do sleep 10;done' ; cd .. ", verbose: false
    sh 'node index.js &> cucumber_reporter.log', verbose: false
  end
end
