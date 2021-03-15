# = Class: typo3::install::source
#
# == Parameters
#
# Standard class parameters
#
# [*version*]
#   TYPO3 version for project.
#   Example: '6.1.3'
#
# [*src_path*]
#   Path to source directory.
#   Example: '/var/www/typo3'
#
# == Author
# Tommy Muehle
#
define typo3::install::source (
  $version,
  $src_path,
  $download_url = $typo3::download_url,
) {
  $source_file = "${version}.tar.gz"

  exec { "Get ${name}":
    command => "curl -Lk ${download_url}/${version} >${source_file}",
    cwd     => $src_path,
    path    => $facts['path'],
    onlyif  => "test ! -d typo3_src-${version}",
  }

  exec { "Untar ${name}":
    command => "tar -xzf ${source_file}",
    cwd     => $src_path,
    require => Exec["Get ${name}"],
    path    => $facts['path'],
    creates => "${src_path}/typo3_src-${version}",
  }

  exec { "Remove ${name}":
    command => "rm -f ${src_path}/${source_file}",
    cwd     => $src_path,
    require => Exec["Untar ${name}"],
    path    => $facts['path'],
    onlyif  => "test -f ${src_path}/${source_file}",
  }

}
