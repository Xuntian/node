#!/bin/bash

set -xe
PWD=$(pwd)
ENV_DOCKERFILE_PATH=$PWD/env.dockerfile
if [[ ! -e $ENV_DOCKERFILE_PATH ]]; then 
    echo "env.dockerfile文件不存在"
    exit 1
fi 
docker build -t xuntian/node:10.1-npm-5.6-yarn-1.6 -f env.dockerfile ./

docker run --rm -v {project_path}:/code xuntian/node:10.1-npm-5.6-yarn-1.6 npm install

BUILD_DOCKERFILE_PATH=$PWD/build.dockerfile
if [[ ! -e $BUILD_DOCKERFILE_PATH ]]; then 
    echo "build.dockerfile文件不存在"
    exit 1
fi 
docker build -t xuntian/node_project:v1 -f build.dockerfile ./

docker run -dti --name node_project -p 80 xuntian/node_project:v1