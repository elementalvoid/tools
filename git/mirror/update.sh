#!/bin/bash

dir=$(dirname $0)
if [ "${dir}" == "." ]
then
  dir=$(pwd)
fi

for i in $(find "${dir}" -maxdepth 1 -type d -iname '*.git')
do
  (cd $i; git fetch;)
done
