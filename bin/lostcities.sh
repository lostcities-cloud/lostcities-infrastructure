#!/usr/bin/env bash

WORKSPACE_ROOT=~/Workspace
INFRASTRUCTURE_ROOT=${WORKSPACE_ROOT}/lostcities-infrastructure

INFRASTRUCTURE_REPO="git@github.com:lostcities-cloud/lostcities-infrastructure.git"
COMMON_REPO="git@github.com:lostcities-cloud/lostcities-common.git"
ACCOUNTS_REPO="git@github.com:lostcities-cloud/lostcities-accounts.git"
MATCHES_REPO="git@github.com:lostcities-cloud/lostcities-matches.git"
FRONTEND_REPO="git@github.com:lostcities-cloud/lostcities-frontend.git"
EXPERIENCE_REPO="git@github.com:lostcities-cloud/lostcities-web-experience.git"
ENV="dev"

workspaceRootError="Unable to find WORKSPACE_ROOT"

function help() {
   echo "lostcities - Help"
   echo
   echo "Syntax: lostcities [-e :env|-h] commands"
   echo "options:"
   echo "e     Set the environment. Default=$ENV."
   echo "h     Print this Help."
   echo " "
   echo "commands:"
   echo " "
   echo "up "
   echo "down "
   echo "clean "
   exit
}

function up() {
  sudo docker-compose --env-file "environments/.env.${ENV}" up
}

function down() {
  sudo docker-compose --env-file environments/.env.${ENV} down
}

function build() {
  sudo docker-compose --env-file environments/.env.${ENV} build
}

function clean() {
  sudo docker system prune -a
}

function logs() {
  sudo docker-compose --env-file environments/.env.${ENV} logs
}

function cloneRepos() {
  cd ${WORKSPACE_ROOT} || echo "${workspaceRootError}" && exit

  if [[ ! -d "./lostcities-infrastructure" ]]; then
      git clone $INFRASTRUCTURE_REPO
  fi

  if [[ ! -d "./lostcities-accounts" ]]; then
    git clone $ACCOUNTS_REPO
  fi

  if [[ ! -d "./lostcities-matches" ]]; then
    git clone $MATCHES_REPO
  fi

  if [[ ! -d "./lostcities-frontend" ]]; then
      git clone $FRONTEND_REPO
  fi

  if [[ ! -d "./lostcities-common" ]]; then
    git clone $COMMON_REPO
  fi
}

while getopts e:h o; do
  case $o in
    (e) ENV=$OPTARG;;
    (h) help;;
    (*)
  esac
done

cd ${INFRASTRUCTURE_ROOT} || exit

for var in "$@"; do

    case "$var" in
      (up) up;;
      (down) down;;
      (build) build;;
      (clean) clean;;
      (cloneRepos) cloneRepos;;
    esac
done
