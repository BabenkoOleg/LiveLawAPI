require 'mina/rails'
require 'mina/git'
require 'mina/puma'
require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
  # domain       - The hostname to SSH to.
  # deploy_to    - Path to deploy into.
  # repository   - Git repo to clone from. (needed by mina/git)
  # branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'livelaw'
set :domain, '5.101.78.188'
set :deploy_to, '/home/oleg/livelaw'
set :repository, 'git@github.com:BabenkoOleg/LiveLawAPI.git'
set :branch, 'master'

# Optional settings:
set :user, 'oleg'                # Username in the server to SSH to.
set :forward_agent, true         # SSH forward_agent.

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# set :shared_dirs, fetch(:shared_dirs, []).push('somedir')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml', 'config/application.yml', 'config/puma.rb')

task :environment do
  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use', 'ruby-2.4.1'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.3.0}
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end

      invoke :'puma:restart'
    end
  end
end