require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "solve360"
    gemspec.summary = "Libary for working with the Solve360 CRM API"
    gemspec.email = "Stephen Bartholomew"
    gemspec.homepage = "http://github.com/curve21/solve360"
    gemspec.description = ""
    gemspec.authors = ["Stephen Bartholomew"]
    gemspec.files =  FileList["[A-Z]*", "{lib,spec}/**/*"]
    gemspec.add_dependency("configify", ">=0.0.1")
    gemspec.add_dependency("active_support", ">=2.3.0")  
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', 'spec/spec.opts']
end

begin
  require "yard"
  YARD::Rake::YardocTask.new do |t|
    t.files   = ["lib/**/*.rb"]
  end
rescue LoadError
  puts "You'll need yard to generate documentation: gem install yard"
end