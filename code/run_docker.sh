#! /bin/bash

set -e

currentDir="$(pwd)"
dataDir="$currentDir"/../data
image="srp33/multiple_classifier_analysis"

#image=https://github.com/eford8/Iris.git#main

docker build -t $image .

mkdir -p $currentDir/../results
chmod 777 $currentDir/../results

#docker run -d --rm \
docker run -i -t --rm \
  --user $(id -u):$(id -g) \
  -v ${dataDir}:/data \
  -v ${currentDir}/../results:/results \
  -v /tmp:/tmp \
  $image
