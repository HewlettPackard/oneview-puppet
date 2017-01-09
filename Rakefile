LINT_IGNORES = [].freeze

require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
# require 'puppet-lint/tasks/puppet-lint'

desc 'Validate manifests, templates, and ruby files'
task :validate do
  PuppetLint.configuration.send('disable_80chars')
  PuppetLint.configuration.ignore_paths = ['spec/**/*.pp', 'pkg/**/*.pp']

  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['examples/**/*.pp'].each do |example|
    sh "puppet parser validate --noop #{example}"
  end
  Dir['spec/**/*.rb', 'lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ %r{spec/fixtures}
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

desc 'Checking puppet module code style.'
task :lint do
  begin
    require 'puppet-lint'
  rescue LoadError
    raise 'Cannot load puppet-lint.'
  end

  success = true

  linter = PuppetLint.new
  linter.configuration.log_format = '%{path}:%{linenumber}:%{check}:%{KIND}:%{message}'

  lintrc = '.puppet-lintrc'
  if File.file?(lintrc)
    File.read(lintrc).each_line do |line|
      check = line.sub(/--no-([a-zA-Z0-9_]*)-check/, '/1').chomp
      linter.configuration.send("disable_#{check}")
    end
  end

  FileList['**/*.pp'].each do |puppet_file|
    parts = puppet_file.split('/')
    module_name = parts[1]
    next if LINT_IGNORES.include? module_name

    puts "Evaluating code style for #{puppet_file}"
    linter.file = puppet_file
    linter.run
    success = false if linter.errors?
  end

  abort 'Checking puppet module code style FAILED' if success.is_a?(FalseClass)
end

task default: :spec
spec_pattern = 'spec/**/*_spec.rb'
def_spec_options = '-f d --color'

namespace :spec do
  desc 'Run unit tests only'
  RSpec::Core::RakeTask.new(:unit) do |spec|
    spec.pattern = spec_pattern
    spec.rspec_opts = def_spec_options
    spec.rspec_opts << ' --tag unit'
  end
end

task(:spec).clear.enhance(['rubocop', 'spec:unit'])

desc 'Runs unit tests and linters for manifests, libraries and metadata'
task :test do
  Rake::Task[:rubocop].invoke
  Rake::Task[:lint].invoke
  Rake::Task[:metadata_lint].invoke
  Rake::Task[:build].invoke
  Rake::Task[:clean].invoke
  Rake::Task[:spec].invoke
end
