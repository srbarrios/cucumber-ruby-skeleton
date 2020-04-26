# Cucumber-Ruby Skeleton

This is a Cucumber project skeleton, written in Ruby, using Capybara framework to interact with a website.

## Project Structure:
```
├── features : Contains .feature files organized in folders, step_definitions and support folder
│   ├── first_stage : Folder containing a set of features, it can be organized by stages in a pipeline, by scope and so on.
│   │   └── feature_a.feature
│   ├── second_stage
│   │   ├── feature_b.feature
│   │   └── feature_c.feature
│   ├── step_definitions
│   │   ├── command_steps.rb
│   │   └── navigation_steps.rb
│   ├── support
│   │   ├── constants.rb : Optional. You can organize your constants here
│   │   ├── custom_formatter.rb : Optional. It prettify your test report
│   │   ├── env.rb : Set Environment content for Cucumber and Capybara
│   │   ├── network_utils.rb
│   │   ├── pretty_formatter.rb
│   │   └── remote_node.rb : Wrap your remote nodes using that class, so you can run remote commands on them
│   └── upload_files : Contains the files to be used during the testsuite
│       └── test.json
├── Gemfile : Gem versions (remember to run bundle install as first step)
├── Gemfile.lock
├── index.js : Javascript used to generate the test report (cucumber-html-reporter)
├── Rakefile : Rake tasks to run cucumber features in parallel or sequentially
├── README.md
└── run_sets
    ├── first_stage.yml : A list of features to be parsed by a rake task that will join them in a cucumber command
    └── second_stage.yml
```

## Initial steps

### Download dependencies
```
gem install bundler
bundle install
npm install cucumber-html-reporter
```

### Run a yaml file containing cucumber test features
```
SERVER=<FQDN or IP> bundle exec rake parallel:<your_yaml_filename>
```

### Generate a test report using Cucumber Html Reporter tool
```
bundle exec rake utils:generate_test_report
```

### Live example
Check the steps in the [GitHub Action](/.github/workflows/capybara.yml).
