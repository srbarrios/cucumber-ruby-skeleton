class RemoteNode
  attr_accessor :hostname, :user, :password

  def initialize(hostname, user = 'root', password = nil)
    @hostname = hostname
    @user = user
    @password = password
    puts "Remote Node initialized (#{@hostname}, #{@user}, #{@password})."
  end

  def ssh(command)
    ssh_command(command, host: @hostname, user: @user, password: @password)
  end

  def scp(local_path, remote_path)
    scp_command(local_path, remote_path, host: @hostname, user: @user, password: @password, )
  end
end
