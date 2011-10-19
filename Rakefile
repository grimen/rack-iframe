require 'bundler/gem_tasks'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << ['lib', 'spec']
  t.pattern = "spec/*_spec.rb"
end
