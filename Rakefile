# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Yogasite::Application.load_tasks

desc 'Run specs with autotest'
task :autotest do
  desc 'Run specs with autotest'
  exec 'autotest'
end

namespace :deploy do
  desc 'Deploy to dev.iliveyoga.ca'
  task :staging do
    exec "git push; cap deploy"
  end
end