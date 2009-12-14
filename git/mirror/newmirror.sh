#!/bin/bash

if [ $# -ne 2 ]
then
  script=$(basename $0)
  echo "This script will setup a Git mirror of an existing repository."
  echo "Usage: ${script} <mirror_folder> <git_url>"
  echo "Example: ${script} vlax7 vlax7:/var/local/git/repo.git"
  exit 1
fi

folder=$1
repo=$2

if [ -d $folder ]
then
  (cd $folder && git clone --mirror $repo)
elif [! -e $folder ]
  mkdir $folder
  (cd $folder && git clone --mirror $repo)
fi
