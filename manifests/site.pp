require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

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
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
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
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

# My overrides

Git::Config::Global <| title == "core.excludesfile" |> {
  value => "~/.gitignore",
}

$user_home = "/Users/${boxen_user}"

node default {
  # core modules, needed for most things
  # include dnsmasq
  include git
  # include hub
  # include nginx
  include ruby

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::v0_10
  Nodejs::Module {
    node_version => 'v0.10',
  }
  $node_modules = [
    'coffee-script',
    'mocha',
  ]
  nodejs::module { $node_modules: }

  # default ruby versions
  include ruby::1_8_7
  include ruby::1_9_3
  include ruby::2_0_0
  class { 'ruby::global':
    version => '2.0.0'
  }

  # common, useful packages
  package {
    [
      'ack',
      'ctags',
      'findutils',
      'gnu-tar',
      'highlight',
      'mercurial',
      's3cmd',
      'the_silver_searcher',
      'tree',
      'visionmedia-watch',
      'wget',
    ]:
  }

  include adium
  include alfred
  include appcleaner
  include caffeine
  include chrome::dev
  include cloudapp
  include daisy_disk::1
  include dropbox
  include flux
  # package { 'go':
  #   ensure          => installed,
  #   install_options => '--cross-compile-all',
  # }
  include graphviz
  include handbrake
  include heroku
  include hipchat
  include istatmenus4
  include iterm2::dev
  include java
  package { 'macvim':
    ensure          => installed,
    install_options => [
      '--override-system-vim',
      '--with-lua',
      '--with-cscope',
    ];
  }
  exec { 'link-macvim':
    command => 'brew linkapps',
    unless  => '/bin/test -L /Applications/MacVim.app',
    require => Package['macvim'],
  }
  exec { 'cp-generic-icon':
    command => "cp ${user_home}/Dropbox/system/MacVim-generic.icns /Applications/MacVim.app/Contents/Resources/MacVim-generic.icns",
    require => Exec['link-macvim'],
  }
  exec { 'cp-icon':
    command => "cp ${user_home}/Dropbox/system/MacVim.icns /Applications/MacVim.app/Contents/Resources/MacVim.icns",
    require => Exec['link-macvim'],
  }
  # include minecraft
  include mplayerx
  # include propane
  include python
  include rdio
  include skype
  # include sparrow
  # include sublime_text_2
  include textual
  include vagrant
  # vagrant::plugin { 'vagrant-vmware-fusion':
  #   license => 'puppet:///modules/fusion.lic',
  # }
  include virtualbox
  include viscosity
  include vlc
  include xscope::2

  $system_rake = '/Library/Ruby/Gems/1.8/gems/rake-10.0.3/bin/rake'

  file { '/usr/local':
    ensure => directory,
  }

  file { '/usr/local/bin':
    ensure => directory,
  }

  file { "${user_home}/gocode":
    ensure => directory,
  }

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
    require => Repository['dotfiles'],
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
    require => Repository['vimfiles'],
  }

  ### dotjs ###
  # $dotjs_dir = "${workspace_dir}/dotjs"

  # repository { 'dotjs':
  #   source   => 'defunkt/dotjs',
  #   path     => $dotjs_dir,
  #   provider => 'git',
  #   require  => [
  #     File[$workspace_dir],
  #     Package['Chrome'],
  #   ]
  # }

  # exec { 'install dotjs':
  #   cwd     => $dotjs_dir,
  #   command => "echo 'y' | ${system_rake} install",
  #   creates => "${user_home}/Library/LaunchAgents/com.github.dotjs.plist",
  #   require => Repository['dotjs'],
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

  ### OS Settings ###

  ## Global ##

  # include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_remote_control_ir_receiver
  # include osx::global::disable_autocorrect

  ## Dock ##

  # include osx::dock::2d
  include osx::dock::autohide
  # include osx::dock::clear_dock
  # include osx::dock::disable
  # include osx::dock::dim_hidden_apps
  # include osx::dock::hide_indicator_lights

  class { 'osx::dock::icon_size':
    size => 70,
  }

  ## Finder ##

  # include osx::finder::show_external_hard_drives_on_desktop
  # include osx::finder::show_hard_drives_on_desktop
  # include osx::finder::show_mounted_servers_on_desktop
  # include osx::finder::show_removable_media_on_desktop
  # include osx::finder::show_all_on_desktop
  # include osx::finder::empty_trash_securely
  include osx::finder::unhide_library

  ## Keyboard ##

  class { 'osx::global::key_repeat_delay':
    delay => 15,
  }

  class { 'osx::global::key_repeat_rate':
    rate => 2,
  }

  ## Universal Access ##

  include osx::universal_access::ctrl_mod_zoom
  include osx::universal_access::enable_scrollwheel_zoom

  ## Misc ##

  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  # include osx::software_update

  ### Boxen SRC_DIR ###

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
