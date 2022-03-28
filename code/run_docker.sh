#! /bin/bash

set -e

currentDir="$(pwd)"
dataDir="$currentDir"/../data
image="srp33/multiple_classifier_analysis"

#image=https://github.com/eford8/Iris.git#main

docker build -t $image .

mkdir -p $currentDir/../results
chmod 777 $currentDir/../results

ls ../
#docker run -i -t --rm \
docker run -d --rm \
  --user $(id -u):$(id -g) \
  -v ${dataDir}:/data \
  -v ${currentDir}/../results:/results \
  $image > /tmp/Emi.log
