require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default => :test

task :work do
  require_relative 'env'
  QC::Database.new.load_functions
  QC::Worker.new.start
end
