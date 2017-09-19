# -*- mode: ruby -*-
# vi: set ft=ruby :

boxname = "dev.box"
guestip = "192.168.33.20"
# Operating System Module
module OS
  def OS.windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
      (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
      !OS.windows?
  end

  def OS.linux?
      OS.unix? and not OS.mac?
  end
end

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

Vagrant.configure("2") do |config|

  config.vm.box = "dev.box/v.0.0.2"

  # Configure hostname
  config.vm.network :private_network, ip: guestip


  config.vm.provider "virtualbox" do |vb|
    vb.name = "devbox"
    vb.memory = "1024"
    vb.cpus = 2
  end

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
    puts "Setting up Hostname. It might require your computers password."
    if OS.windows?
      exec("sudo echo " + guestip + "    dev.box >> /etc/hosts")
    elsif OS.mac?
      exec("sudo echo " + guestip + "    dev.box >> /etc/hosts")
      puts "Setup done."
    elsif OS.unix?
      exec("sudo bash -c 'echo " + guestip + "    dev.box >> /etc/hosts'")
    elsif OS.linux?
      exec("sudo bash -c 'echo " + guestip + "    dev.box >> /etc/hosts'")
    else
        puts "Vagrant launched from unknown platform."
    end
  end

end
