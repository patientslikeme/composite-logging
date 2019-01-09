require "bundler/gem_tasks"
require "rake/testtask"
require "gemfury/tasks"

# override rubygems' normal release task to use Gemfury
Rake::Task['release'].clear
task :release, [:remote] => ['build', 'release:guard_clean', 'release:source_control_push'] do
  Rake::Task['fury:release'].invoke(nil, 'patientslikeme')
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
  t.warning = false
end

task default: :test
