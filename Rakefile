require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "solve360"
    gem.summary = "Libary for working with the Solve360 CRM API"
    gem.email = "Stephen Bartholomew"
    gem.homepage = "http://github.com/curve21/solve360"
    gem.description = ""
    gem.authors = ["Stephen Bartholomew"]
    gem.files =  FileList["[A-Z]*", "{lib,spec}/**/*"]
    gem.add_dependency("configify", ">=0.0.1")
    gem.add_dependency("activesupport", ">=2.3.0")  
    gem.add_dependency("httparty", ">=0.4.5")
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