require "bundler/gem_tasks"
require "rake/testtask"
require "gemfury/tasks"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

# override rubygems' normal release task to use Gemfury
Rake::Task['release'].clear
task :release do
  Rake::Task['fury:release'].invoke(nil, "patientslikeme")
end
