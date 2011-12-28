require 'bundler/capistrano'

set :user, 'sfistak'
set :domain, 'miaplacidus.dreamhost.com'
set :project, 'bango'

set :application, "bango.fatbuu.com"

set :applicationdir, "/home/#{user}/Sites/#{project}"

ssh_options[:forward_agent] = true
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :repository,  "git@github.com:gs/bango.git"
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :deploy_via, :remote_cache
set :deploy_to,  "#{applicationdir}"
set :copy_exclude, [".git"]
set :rails_env, "production"
#need to send this to have access to bundle
set :default_environment, { 'PATH' => "'/home/sfistak/.rvm/gems/ruby-1.9.2-p290/bin:/home/sfistak/.rvm/gems/ruby-1.9.2-p290@global/bin//bundle:/home/sfistak/.rvm/bin:/home/sfistak/.gems/bin:/usr/lib/ruby/gems/1.8/bin/:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games'" }

role :web, domain
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :db do
  task :symlink, :except => { :no_release => true } do
      run "ln -nfs #{applicationdir}/shared/config/database.yml #{release_path}/config/database.yml"
      run "ln -nfs #{applicationdir}/shared/config.ru #{release_path}/config.ru"
  end
end

# after "deploy:update_code", :bundle_install
# desc "install the necessary prereqisites"
# task :bundle_install, :roles => :app do
#   run "cd #{applicationdir}/current && bundle install"
# end

set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false

after "deploy:finalize_update", "db:symlink"