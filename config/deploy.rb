# Bundler stuff
require "bundler/capistrano"
require 'capistrano_colors'
require 'new_relic/recipes'

set :application, "fnordystats"
set :fqdn, ENV['FQDN']||"#{application}.example.com"
set :primary_server, '10.4.45.72'
role :web, "10.4.45.72"                          # Your HTTP server, Apache/etc
role :app, "10.4.45.72"                          # This may be the same as your `Web` server
role :db,  "10.4.45.72", :primary => true # This is where Rails migrations will run
role :db,  "10.4.45.72"


# App config
set :repository, "git@github.com:att-innovate/#{application}.git"
set :scm, 'git'
set :user, 'deploy'
set :branch, 'master'
set :deploy_via, :remote_cache
set :deploy_to, File.join('/var/www/apps/', application)
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:auth_methods] = ["publickey"]
ssh_options[:verbose] = :error
ssh_options[:keys] = [  File.join(ENV["HOME"], ".ssh", "identity"), 
                        File.join(ENV["HOME"], ".ssh", "id_rsa"), 
                        File.join(File.dirname(__FILE__), "#{application}.rsa")]

set :use_sudo, false
set :bundle_flags, ""
set :bundle_without, [:test]

after "deploy:update", "newrelic:notice_deployment"


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end


# Foreman
namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :app do
    run "cd #{release_path} && sudo bundle exec foreman export upstart /etc/init -a #{application} -u #{user} -l #{current_path}/log"
  end
  
  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{application}"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    sudo "stop #{application}"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "sudo start #{application} || sudo restart #{application}"
  end
end
after "deploy:update", "foreman:export"
after "deploy:update", "foreman:restart"


# =============================================================================
# = Tasks for interacting with the remote servers                             =
# =============================================================================
desc "tail log files"
task :tail  do
  run "tail -n 1000 -f #{shared_path}/log/*.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

desc "tail error log file"
task :tail_error_log do
  run "tail -n 1000 -f #{shared_path}/log/error.log" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end


desc "Remote console"
task :console, :roles => :app do
  env = stage rescue "production"
  server = find_servers(:roles => [:app]).first
  run_with_tty server, %W('bundle exec irb -r ./app.rb')
end

def run_with_tty(server, cmd)
  # looks like total pizdets
  command = []
  command += %W( ssh -t #{gateway} -l #{self[:gateway_user] || self[:user]} ) if     self[:gateway]
  command += %W( ssh -t )
  command += %W( -p #{server.port}) if server.port
  command += %W( -l #{user} #{server.host} )
  command += %W( cd #{current_path} )
  # have to escape this once if running via double ssh
  command += [self[:gateway] ? '\&\&' : '&&']
  command += Array(cmd)
  system *command
end
