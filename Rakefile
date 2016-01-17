# encoding: utf-8
require 'bundler/setup'
require 'sequel'
require 'rubocop/rake_task'

$: << File.expand_path("../lib", __FILE__)
$: << File.expand_path("../config", __FILE__)

task :database do
  require "database"
end

desc 'Manages database'
namespace :db do
  desc 'Migrate database'
  task :migrate => :database do
    require "sequel/extensions/migration"
    Sequel::IntegerMigrator.new(DB, File.expand_path("../config/migrations", __FILE__)).run
  end

  task :migrate_down => :database do
    require "sequel/extensions/migration"
    Sequel::IntegerMigrator.new(DB, File.expand_path("../config/migrations", __FILE__), :target => 0).run
  end
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/*.rb', 'lib/helpers/*.rb']
  task.fail_on_error = false
end
