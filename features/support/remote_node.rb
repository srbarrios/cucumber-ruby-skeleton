class RemoteNode
  attr_accessor :hostname, :port, :user, :password

  def initialize(hostname, port = 22, user = 'root', password = nil)
    @hostname = hostname
    @port = port
    @user = user
    @password = password
    Kernel.puts "Remote Node initialized (#{@hostname}:#{@port}, #{@user}, #{@password})."
  end

  def ssh(command)
    ssh_command(command, host: @hostname, port: @port, user: @user, password: @password)
  end

  def scp(local_path, remote_path)
    scp_command(local_path, remote_path, host: @hostname, port: @port, user: @user, password: @password, )
  end
end
