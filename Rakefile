require "rubygems"
require "bundler/setup"
require 'rake/testtask'
require 'rspec/core/rake_task'

namespace :gem do
  Bundler::GemHelper.install_tasks
end

namespace :test do
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/*_spec.rb"
    t.rspec_opts = "--color"
  end
end