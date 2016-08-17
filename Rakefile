LINT_IGNORES = []

desc "Validate manifests, templates, and ruby files"
task :validate do
  require 'rubygems'
  require 'puppetlabs_spec_helper/rake_tasks'
  require 'puppet-lint/tasks/puppet-lint'
  PuppetLint.configuration.send('disable_80chars')
  PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['examples/**/*.pp'].each do |example|
    sh "puppet parser validate --noop #{example}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

#namespace :lint do
  desc "Checking puppet module code style."
  task :lint do
    begin
      require 'puppet-lint'
    rescue LoadError
      fail 'Cannot load puppet-lint.'
    end

    success = true

    linter = PuppetLint.new
    linter.configuration.log_format = '%{path}:%{linenumber}:%{check}:%{KIND}:%{message}'

    lintrc = ".puppet-lintrc"
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

    abort "Checking puppet module code style FAILED" if success.is_a?(FalseClass)
  end
#end
