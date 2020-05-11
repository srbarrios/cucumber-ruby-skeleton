class RemoteNode
  attr_accessor :hostname, :ssh_port, :user, :password

  def initialize(hostname, ssh_port = 22, user = 'root', password = nil)
    @hostname = hostname
    @ssh_port = ssh_port
    @user = user
    @password = password
    puts "Remote Node initialized (#{@hostname}, #{@ssh_port}, #{@user}, #{@password})."
  end

  def ssh(command)
    ssh_command(command, host: @hostname, port: @ssh_port, user: @user, password: @password)
  end

  def scp(local_path, remote_path)
    scp_command(local_path, remote_path, port: @ssh_port, host: @hostname, user: @user, password: @password, )
  end
end
