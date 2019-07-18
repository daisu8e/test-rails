# config valid for current version and patch releases of Capistrano
lock "3.11.0"

set :application, "dashboard-api"
set :repo_url, "git@github.com:daisu8e/dashboard-api.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, "~/dashboard-api"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true
set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", ".bundle", "vendor/bundle"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure


set :default_env, { path: "$HOME/.anyenv/envs/rbenv/shims:$PATH" }

set :rbenv_roles, :all
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_custom_path, "~/.anyenv/envs/rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :bundle_roles, :all
set :bundle_servers, -> { release_roles(fetch(:bundle_roles)) }
set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_path, -> { shared_path.join("vendor/bundle") }
set :bundle_binstubs, -> { shared_path.join('vendor/bin') }
set :bundle_without, %w{development test}.join(' ')
set :bundle_flags, '--deployment --quiet'
set :bundle_jobs, 4
set :bundle_env_variables, {}
set :bundle_clean_options, ""
set :bundle_check_before_install, true

set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_config_path, -> { current_path.join("config/unicorn.rb") }

after "deploy:publishing", "deploy:restart"
namespace :deploy do
  task :restart do
    invoke "unicorn:restart"
  end
end
