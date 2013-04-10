# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

def github(name, version, options = nil)
  options ||= {}
  options[:repo] ||= "boxen/puppet-#{name}"
  mod name, version, :github_tarball => options[:repo]
end

# Core modules for a basic development environment. You can replace
# some/most of those if you want, but it's not recommended.

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "1.3.0"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq",  "1.0.0"
github "gcc",      "1.0.0"
github "git",      "1.0.0"
github "homebrew", "1.1.2"
github "hub",      "1.0.0"
github "inifile",  "0.9.0", :repo => "cprice-puppet/puppetlabs-inifile"
github "nginx",    "1.1.0"
github "nodejs",   "2.1.0"
github "ruby",     "3.3.1"
github "stdlib",   "3.0.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",     "1.0.0"

# Optional/custom modules. There are tons available at https://github.com/boxen.
github "adium",          "1.0.1"
github "alfred",         "1.0.0"
github "appcleaner",     "1.0.0"
github "caffeine",       "1.0.0"
github "chrome",         "1.0.0"
github "daisy_disk",     "1.0.0"
github "dropbox",        "1.1.0"
github "fluid",          "1.0.0"
github "flux",           "0.0.1"
github "flowdock",       "1.0.0"
github "graphviz",       "1.0.0"
github "istatmenus4",    "1.0.1", :repo => "archfear/puppet-istatmenus4"
github "macvim",         "1.0.0"
github "mplayerx",       "1.0.0"
github "pcre",           "1.0.0" # Needed for graphviz
github "pkgconfig",      "1.0.0" # Needed for somthing--dunno
github "propane",        "1.0.0"
github "python",         "1.1.0"
github "repository",     "1.0.0"
github "rdio",           "1.0.0"
github "skype",          "1.0.0"
github "sparrow",        "1.0.0"
github "sublime_text_2", "1.1.0"
github "swig",           "1.0.0" # Needed for somthing--dunno
github "vagrant",        "2.0.3"
github "virtualbox",     "1.0.1"
github "viscosity",      "1.0.0"
github "vlc",            "1.0.0"
github "xquartz",        "1.0.0"
github "xscope",         "1.0.0"
