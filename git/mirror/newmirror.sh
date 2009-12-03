#!/bin/bash

if [ $# -ne 1 ]
then
  script=$(basename $0)
  echo "This script will setup a Git mirror of an existing repository."
  echo "Usage: ${script} <git_url>"
  exit 1
fi

git clone --mirror $1
