require 'net/ssh'
require 'net/scp'
require 'stringio'

Net::SSH::Transport::Algorithms::ALGORITHMS.values.each { |algs| algs.reject! { |a| a =~ /^ecd(sa|h)-sha2/ } }
Net::SSH::KnownHosts::SUPPORTED_TYPE.reject! { |t| t =~ /^ecd(sa|h)-sha2/ }

def ssh_command(command, host: SERVER, user: 'root', password: nil)
  out = StringIO.new
  err = StringIO.new
  if password.nil?
    # Not passing :password uses systems ssh keys to authenticate
    Net::SSH.start(host, user, verify_host_key: :never) do |ssh|
      ssh.exec!(command) do |_chan, str, data|
        out << data if str == :stdout
        err << data if str == :stderr
      end
    end
  else
    Net::SSH.start(host, user, password: password, verify_host_key: :never) do |ssh|
      ssh.exec!(command) do |_chan, str, data|
        out << data if str == :stdout
        err << data if str == :stderr
      end
    end
  end

  { stdout: out.string, stderr: err.string }
end

def scp_command(local_path, remote_path, host: SERVER, user: 'root', password: nil)
  if password.nil?
    # Not passing :password uses systems ssh keys to authenticate
    Net::SSH.start(host, user, verify_host_key: :never) do |ssh|
      ssh.scp.upload! local_path, remote_path
    end
  else
    Net::SSH.start(host, user, password: password, verify_host_key: :never) do |ssh|
      ssh.scp.upload! local_path, remote_path
    end
  end
end

def port_is_open(host, port)
  Socket.tcp(host, port, connect_timeout: 5)
end 
