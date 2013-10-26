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

github "boxen",      "3.0.2"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "autoconf",   "1.0.0"
github "dnsmasq",    "1.0.0"
github "gcc",        "2.0.1"
github "git",        "1.2.5"
github "homebrew",   "1.4.1"
github "hub",        "1.0.3"
github "inifile",    "1.0.0", :repo => "puppetlabs/puppetlabs-inifile"
# github "nginx",      "1.4.2"
github "nodejs",     "3.2.9"
github "openssl",    "1.0.0"
github "repository", "2.2.0"
github "ruby",       "6.3.4"
github "stdlib",     "4.1.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",       "1.0.0"
github "xquartz",    "1.1.0"

# Optional/custom modules. There are tons available at https://github.com/boxen.
github "adium",           "1.1.1"
github "alfred",          "1.1.6"
github "appcleaner",      "1.0.0"
github "caffeine",        "1.0.0"
github "cloudapp",        "1.0.0"
github "chrome",          "1.1.1"
github "daisy_disk",      "1.0.0"
github "dropbox",         "1.1.1"
github "fluid",           "1.0.0"
github "flux",            "0.0.1"
github "flowdock",        "1.0.0"
github "graphviz",        "1.0.0"
github "handbrake",       "1.0.0"
github "heroku",          "2.0.0"
github "hipchat",         "1.0.8"
github "istatmenus4",     "1.0.0"
github "iterm2",          "1.0.3"
github "java",            "1.1.2"
# github "macvim",        "1.0.0"
github "mplayerx",        "1.0.1"
github "pcre",            "1.0.0" # Needed for graphviz
github "pkgconfig",       "1.0.0" # Lots of modules depend on this
github "python",          "1.2.1"
github "repository",      "2.2.0"
github "rdio",            "1.0.0"
github "skype",           "1.0.0"
github "sparrow",         "1.0.0"
github "sublime_text_2",  "1.1.2"
github "swig",            "1.0.0" # Needed for graphviz
github "textual",         "3.2.1"
github "vagrant",         "2.0.12"
github "virtualbox",      "1.0.5"
github "viscosity",       "1.0.0"
github "vlc",             "1.0.4"
github "xscope",          "1.0.0"
