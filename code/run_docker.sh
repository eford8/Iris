#! /bin/bash

set -e

image=https://github.com/eford8/Iris.git

docker build $image 

#mkdir -p data/simulated_expression data/mnist data/bladderbatch data/gse37199 data/tcga
#mkdir -p $(pwd)/../metrics
mkdir -p $(pwd)/../figures
printf "\033[0;32mHere\033[0m\n"
#chmod 777 $(pwd)/../metrics
chmod 777 $(pwd)/../figures
printf "\033[0;32mHere2\033[0m\n"
#docker run -i -t --rm \
docker run -i --rm \
  --user $(id -u):$(id -g) \
  -v $(pwd)/data:/data \
  -v $(pwd)/../metrics:/output/metrics \
  -v $(pwd)/../figures:/output/figures \
printf "\033[0;32mHere3\033[0m\n"
  $image