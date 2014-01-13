desc 'Run tests'
task :default => [:test]

desc 'Archive all the things'
task :dist do
  sh 'git archive --format=tar --prefix=inspections HEAD^{tree} >inspections.tar'
  sh 'gzip -f -9 inspections.tar'
end

desc 'Run tests'
task :test do
  sh 'ruby test/test.rb'
end
