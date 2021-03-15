# = Class: typo3::install::source::files
#
# == Parameters
#
# Standard class parameters
#
# [*version*]
#   TYPO3 version for project.
#   Example: '6.1.3'
#
# [*site_path*]
#   Path to project root.
#   Example: '/var/www/my-project'
#
# [*src_path*]
#   Path to TYPO3 sources.
#   Example: '/var/www'
#
# [*use_symlink*]
#   Set a symlink to TYPO3 source. Set to false to copy sources.
#   Default: true
#
# == Author
# Felix Nagel
#
define typo3::install::source::files (

  $version,
  $src_path,
  $site_path,
  $use_symlink = true

) {

  include typo3::params

  $source = "${src_path}/typo3_src-${version}"
  $target = "${site_path}/typo3_src"

  if str2bool($use_symlink) {

    file { $target:
      ensure  => link,
      target  => $source,
      force   => true,
      replace => true
    }

    exec { "${site_path}: ln -s typo3_src/index.php index.php":
      command => 'ln -s typo3_src/index.php index.php',
      cwd     => $site_path,
      require => File[$target],
      path    => $facts['path'],
      unless  => 'test -L index.php',
    }

    exec { "${site_path}: ln -s typo3_src/typo3 typo3":
      command => 'ln -s typo3_src/typo3 typo3',
      cwd     => $site_path,
      require => File[$target],
      path    => $facts['path'],
      unless  => 'test -d typo3',
    }

    if versioncmp($version, '6.1.99') <= 0 {
      exec { "${site_path}: ln -s typo3_src/t3lib t3lib":
        command => 'ln -s typo3_src/t3lib t3lib',
        cwd     => $site_path,
        require => File[$target],
        path    => $facts['path'],
        unless  => 'test -d t3lib',
      }
    }

  } else {

    file { "${site_path}/index.php":
      ensure => 'present',
      source => "${source}/index.php"
    }

    file { "${site_path}/typo3":
      ensure  => 'present',
      source  => "${source}/typo3",
      recurse => true
    }

    if versioncmp($version, '6.2') == 0 {
      file { "${site_path}/t3lib":
        ensure  => 'present',
        source  => "${source}/t3lib",
        recurse => true
      }
    }
  }
}
