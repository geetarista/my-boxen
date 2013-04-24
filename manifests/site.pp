require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $luser,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::luser}"
  ]
}

File {
  group => 'staff',
  owner => $luser
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => Class['git']
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  # include hub
  include nginx
  include ruby

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::global
  nodejs::module { ['coffee-script', 'mocha']:
    node_version => 'v0.10'
  }

  # default ruby versions
  include ruby::1_8_7
  include ruby::1_9_3
  include ruby::2_0_0
  class { 'ruby::global':
    version => '1.9.3'
  }

  # common, useful packages
  package {
    [
      'ack',
      'ctags',
      'findutils',
      'gnu-tar',
      'mercurial',
      'the_silver_searcher',
      'wget',
    ]:
  }

  include adium
  include alfred
  include appcleaner
  include caffeine
  include chrome::dev
  include daisy_disk::1
  include dropbox
  include fluid
  include flux
  include flowdock
  package { 'go':
    ensure          => installed,
    install_options => '--cross-compile-all',
  }
  include graphviz
  include handbrake
  class { 'hexcolorpicker':
    user => $luser,
  }
  include istatmenus4
  include java
  include macvim
  include minecraft
  include mplayerx
  include propane
  include python
  include rdio
  include skype
  include sparrow
  include sublime_text_2
  include vagrant
  # vagrant::plugin { 'vagrant-vmware-fusion':
  #   license => 'puppet:///modules/fusion.lic',
  # }
  include virtualbox
  include viscosity
  include vlc
  include xscope::2

  $system_rake = '/Library/Ruby/Gems/1.8/gems/rake-10.0.3/bin/rake'
  $user_home = "/Users/${luser}"
  $user_src = "${user_home}/src"

  file { '/usr/local':
    ensure => directory,
  }

  file { '/usr/local/bin':
    ensure => directory,
  }

  # file { $user_src:
  #   ensure => directory,
  # }

  ### SSH ###
  $ssh_dir = "${user_home}/.ssh"
  $known_hosts_dir = "${ssh_dir}/known_hosts"

  file { $ssh_dir:
    ensure => directory,
  }

  exec { "touch ${known_hosts_dir}":
    creates => $known_hosts_dir
  }

  ### Workspace ###

  $workspace_dir = "${user_home}/workspace"
  $dotfiles_dir = "${workspace_dir}/dotfiles"
  $vimfiles_dir = "${workspace_dir}/vimfiles"

  file { $workspace_dir:
    ensure => directory,
  }

  repository { 'dotfiles':
    source   => 'geetarista/dotfiles',
    path     => $dotfiles_dir,
    provider => 'git',
    require  => File[$workspace_dir],
  }

  exec { 'install dotfiles':
    creates => "${user_home}/.aliases",
    cwd     => $dotfiles_dir,
    command => './install',
  }

  repository { 'vimfiles':
    source   => 'geetarista/vimfiles',
    path     => $vimfiles_dir,
    provider => 'git',
    require  => File[$workspace_dir],
  }

  exec { 'install vimfiles':
    creates => "${user_home}/.vim",
    cwd     => $vimfiles_dir,
    command => './install',
  }

  ### dotjs ###
  $dotjs_dir = "${workspace_dir}/dotjs"

  repository { 'dotjs':
    source   => 'defunkt/dotjs',
    path     => $dotjs_dir,
    provider => 'git',
    require  => Package['Chrome'],
  }

  exec { 'install dotjs':
    cwd     => $dotjs_dir,
    command => "echo 'y' | ${system_rake} install",
    creates => "${user_home}/Library/LaunchAgents/com.github.dotjs.plist",
    require => Repository['dotjs'],
  }

  ### User defaults ###

  Defaults {
    user => $luser
  }

  ## General ##

  defaults { 'Disable "Are you sure?" prompt for applications':
    domain => 'com.apple.LaunchServices',
    key    => 'LSQuarantine',
    value  => false,
  }

  ## Keyboard ##

  defaults { 'Tab through all form controls':
    domain => 'NSGlobalDomain',
    key    => 'AppleKeyboardUIMode',
    value  => 3,
  }

  ## Screenshots ##

  defaults { 'Store screenshots in ~/Downloads':
    domain => 'com.apple.screencapture',
    key    => 'location',
    value  => "${user_home}/Downloads",
  }

  ## Battery ##

  # defaults { 'Restrict menu bar':
  #   domain => 'com.apple.systemuiserver',
  #   key    => 'menuExtras',
  #   value  => [
  #     '/Library/Application Support/iStat Menus 4/extras/iStatMenusCombined.menu',
  #     '/Library/Application Support/iStat Menus 4/extras/MenuCracker.menu',
  #     '/System/Library/CoreServices/Menu Extras/AirPort.menu',
  #     '/System/Library/CoreServices/Menu Extras/Volume.menu',
  #     '/System/Library/CoreServices/Menu Extras/Clock.menu',
  #   ],
  # }

  ### Meslo ###

  # https://github.com/Lokaltog/powerline-fonts/tree/master/Meslo
  # unzip Meslo\ LG\ DZ\ v1.0.zip
  # cd Meslo\ LG\ DZ\ v1.0
  # for file in *.ttf; do
  #   mv $file $HOME/Library/Fonts/$file;
  # done
  # cd ..

  ### MacVim icons ###

  ### ~/Library ###

  exec { 'show ~/Library':
    command => "chflags nohidden ${user_home}/Library",
    unless  => 'stat ~/Library/ | grep "4096 0 0"',
  }

  ### Quicklook Plugins ###

  # https://github.com/whomwah/qlstephen/archive/1.3.tar.gz
  # qlmanage -r
  # defaults write com.apple.finder QLEnableTextSelection -bool true; killall Finder
  # https://github.com/toland/qlmarkdown/

  ### Boxen SRC_DIR ###

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
