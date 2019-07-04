namespace :unicorn do

  desc "Start unicorn"
  task(:start) {
    sh "unicorn -c #{config_file} -E #{environment} -D"
  }

  desc "Stop unicorn"
  task(:stop) {
    kill :QUIT
  }

  desc "Restart unicorn with USR2"
  task(:restart) {
    kill :USR2
  }

  desc "Increment number of worker processes"
  task(:increment) {
    kill :TTIN
  }

  desc "Decrement number of worker processes"
  task(:decrement) {
    kill :TTOU
  }

  desc "Unicorn pstree (depends on pstree command)"
  task(:pstree) do
    sh "pstree '#{pid}'"
  end

  def environment
    Rails.env
  end

  def config_file
    Rails.root.join('config', 'unicorn.rb')
  end

  def pid_file
    Rails.root.join('tmp', "unicorn.pid")
  end

  def kill signal
    Process.kill signal, pid
  end

  def pid
    begin
      File.read(pid_file).to_i
    rescue Errno::ENOENT
      raise "Unicorn does not seem to be running"
    end
  end

end
