require 'capistrano/bundler'
require 'capistrano/rvm'

set :rvm_ruby_version, '2.0.0-p451'
set :rvm_type, :user

lock '3.1.0'

set :application, 'proteopathogen2'
set :repo_url, 'git@github.com:vitalv/proteopathogen_on_rails.git'

set :scm, :git
set :branch, "master"


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
       execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

   task :link_db_yml do
    on roles(:app) do
      execute  "ln -sf #{shared_path}/database.yml #{release_path}/config/database.yml"
    end
   end
  
  before "deploy:assets:precompile", "deploy:link_db_yml"
  
end

 desc "Check that we can access everything"
    task :check_write_permissions do
      on roles(:all) do |host|
        if test("[ -w #{fetch(:deploy_to)} ]")
          info "#{fetch(:deploy_to)} is writable on #{host}"
        else
          error "#{fetch(:deploy_to)} is not writable on #{host}"
        end
      end
    end
    


