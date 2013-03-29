# Class hexcolorpicker
#
class hexcolorpicker($version='1.6.1', $user=undef) {
  if $user == undef {
    fail('User is required to install hexcolorpicker')
  }

  $download_url = "http://wafflesoftware.net/hexpicker/download/HexColorPicker-${$version}.zip"
  $user_home = "/Users/${user}"
  $user_src = "${user_home}/src"
  $zip = "${user_src}/HexColorPicker-${version}.zip"

  file { "${user_home}/Library/ColorPickers":
    ensure => directory,
  }

  exec { 'download color picker':
    command => "wget ${download_url}",
    creates => $zip,
    cwd     => $user_src,
    require => Package['wget'],
  }

  exec { 'extract color picker':
    command => "unzip ${zip}",
    creates => "${user_src}/Hex Color Picker/HexColorPicker.colorPicker",
    cwd     => $user_src,
    require => Exec['download color picker'],
  }

  exec { 'move color picker':
    command => "mv ${user_src}/Hex\\ Color\\ Picker/HexColorPicker.colorPicker ${user_home}/Library/ColorPickers",
    creates => "${user_home}/Library/ColorPickers/HexColorPicker.colorPicker",
    cwd     => $user_src,
    require => Exec['extract color picker'],
  }
}
