require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mongo_embeddable_document"
    gem.summary = "Declarative automatic embedded document for MongoMapper"
    gem.description = "Allows you to declaratively describe the embedded version of a Document for MongoMapper"
    gem.authors = ["Scotty Weeks"]
    gem.email = "scott.weeks@gmail.com"
    gem.add_development_dependency "shoulda"
    gem.add_development_dependency "mocha"
    gem.add_dependency "mongo_mapper"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end
