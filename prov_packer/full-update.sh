#!/usr/bin/env bash

# https://elrey.casa/bash/scripting/harden
set -${-//[s]/}eu${DEBUG+xv}o pipefail

function update_os() {

  ## updating
  export DEBIAN_FRONTEND=noninteractive
  # fix for old problem of not having the right repos
  # echo 'deb http://http.kali.org/kali kali-rolling main contrib non-free' > /etc/apt/sources.list
  # echo 'deb-src http://http.kali.org/kali kali-rolling main contrib non-free' >> /etc/apt/sources.list
  apt-get update --fix-missing | tee -a $logz
  apt-get upgrade -y -o Dpkg::Options::='--force-confnew' | tee -a $logz
  apt-get dist-upgrade -y -o Dpkg::Options::='--force-confnew' | tee -a $logz
  apt-get autoremove -y -o Dpkg::Options::='--force-confnew' | tee -a $logz

}

function main() {

  # establishing a log file variable for the upgrade
  logz='packer-upgrade.log'

  update_os

}

# https://blog.elreydetoda.site/cool-shell-tricks/#bashscriptingbashsmain
if [[ "${0}" = "${BASH_SOURCE[0]}" ]]; then
  main "${@}"
fi
