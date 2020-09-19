#!/usr/bin/env bash

# https://blog.elreydetoda.site/cool-shell-tricks/#bashscriptingmodifiedscripthardening
set -${-//[sc]/}eu${DEBUG+xv}o pipefail

function setup_env(){
  export PACKER_LOG=1
  export PACKER_LOG_PATH=/opt/packer/kali/packer_build.log
  # export PACKER_LOG_PATH=./packer_build.log
}

function packer_build(){
  provider="${1}"

  case "${provider}" in
    virtualbox-iso)
        packer_build_cmd+=('-only=virtualbox-iso') 
      ;;
    vmware-iso)
        packer_build_cmd+=('-only=vmware-iso') 
      ;;
  esac

}

main(){
  providers_to_build="${1}"
  packer_build_cmd=(
    'packer' 'build'
    '-var-file' 'variables.json'
  )
  mapfile -t provider_array < <( tr '|' '\n' <<< "${providers_to_build}" )


  setup_env

  for provider in "${provider_array[@]}" ; do
    packer_build "${provider}"
  done

  # adding the template for the build command
  packer_build_cmd+=( 'kali-template.json' )

  "${packer_build_cmd[@]}"
}

if [[ "${0}" = "${BASH_SOURCE[0]}" ]] ; then
  main "${@}"
fi
