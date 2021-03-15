# = Class: typo3
#
# This is the main typo3 class
#
# == Author
# Tommy Muehle
#
class typo3 (
  String $download_url = 'get.typo3.org',
){

  if $::operatingsystem =~ /^(Debian|Ubuntu)$/ and versioncmp($::operatingsystemrelease, '12') < 0 {
    $packages = [ 'curl', 'git-core' ]
  } else {
    $packages = [ 'curl', 'git' ]
  }

  typo3::safe_package { $packages: ensure => 'installed' }

}
