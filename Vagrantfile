# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANT_VERSION = "2"

dirname = File.basename(Dir.getwd)

# Checks plugin dependency
required_plugins = %w( vagrant-hostmanager vagrant-triggers )

# Installs plugin dependency
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

Vagrant.configure(VAGRANT_VERSION) do |config|
  config.vm.box = "vm/beta0.0.4"

  config.ssh.insert_key = false

  # Configure hostname
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false
  config.vm.define dirname do |node|
    node.vm.hostname = "#{dirname}.local"
    node.vm.network :private_network, ip: "192.168.13.37"
    node.hostmanager.aliases = ["#{dirname}.local", "www.#{dirname}.local"]
  end

  # Configure Network
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provider "virtualbox" do |vb|
    vb.name = dirname
  end

  # Provision
  config.vm.provision "shell",
    path: "provision.sh",
    args: "#{dirname}",
    privileged: false,
    keep_color: true

  # Triggers
  config.trigger.before :up do
    puts ""
    puts ""
    puts "\033[38;5;118m   ____   __  __     _                _       "
    puts "\033[38;5;118m  / __ \\ / _|/ _|   | |              | |      "
    puts "\033[38;5;118m | |  | | |_| |_ ___| |__   ___  _ __| |_   _ "
    puts "\033[38;5;118m | |  | |  _|  _/ __| '_ \\ / _ \\| '__| | | | |"
    puts "\033[38;5;118m | |__| | | | | \\__ \\ | | | (_) | |  | | |_| |"
    puts "\033[38;5;118m  \\____/|_| |_| |___/_| |_|\\___/|_|  |_|\\__, |"
    puts "\033[38;5;118m                                         __/ |"
    puts "\033[38;5;118m                                        |___/ "
    puts ""
    puts "  \033[38;5;220mDevelopment Environment"
    puts "  \033[38;5;220mSite: \033[38;5;118mhttps://offshorly.com/"
    puts ""
    puts ""
    puts "\033[0m"
  end

  config.trigger.after :up do
    puts ""
    puts "  \033[38;5;220mSite is now up and running."
    puts "  \033[38;5;220mNavigate to: \033[38;5;118mhttps://#{dirname}.local"
  end

end
