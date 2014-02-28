# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod name, :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen",      "3.3.8"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

# github "autoconf",   "1.0.0"
# github "dnsmasq",    "1.0.1"
# github "nginx",      "1.4.2"
github "foreman",     "1.1.0"
github "gcc",        "2.0.1"
github "git",        "1.3.7"
github "homebrew",   "1.6.0"
github "hub",        "1.3.0"
github "inifile",    "1.0.1", :repo => "puppetlabs/puppetlabs-inifile"
github "module-data", "0.0.1", :repo => "ripienaar/puppet-module-data"
github "nodejs",     "3.5.0"
github "openssl",    "1.0.0"
github "phantomjs",   "2.1.0"
github "pkgconfig",  "1.0.0"
github "repository", "2.3.0"
github "ruby",       "7.2.3"
github "stdlib",     "4.1.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",       "1.0.0"
github "xquartz",    "1.1.1"

# Optional/custom modules. There are tons available at https://github.com/boxen.

github "adium",           "1.3.0"
github "alfred",          "1.1.7"
github "appcleaner",      "1.0.0"
github "caffeine",        "1.0.0"
github "chrome",          "1.1.2"
github "cloudapp",        "1.0.0"
github "daisy_disk",      "1.0.0"
github "dropbox",         "1.2.0"
github "flowdock",        "1.0.0"
github "fluid",           "1.0.1"
github "flux",            "1.0.0"
github "graphviz",        "1.0.0"
github "handbrake",       "1.0.1"
github "heroku",          "2.1.1"
github "hipchat",         "1.0.8"
github "istatmenus4",     "1.1.0"
github "iterm2",          "1.0.7"
github "java",            "1.2.0"
github "mplayerx",        "1.0.1"
github "osx",             "2.2.2"
github "pcre",            "1.0.0" # Needed for graphviz
github "python",          "1.3.0"
github "rdio",            "1.0.0"
github "repository",      "2.3.0"
github "swig",            "1.0.0" # Needed for graphviz
github "vagrant",         "3.0.5"
github "viscosity",       "1.0.0"
github "vlc",             "1.0.5"
github "xscope",          "1.0.0"
# github "macvim",        "1.0.0"
# github "skype",           "1.0.0"
# github "sparrow",         "1.0.0"
# github "sublime_text_2",  "1.1.2"
# github "textual",         "3.2.1"
# github "virtualbox",      "1.0.5"
