#!/bin/bash

set -xe

cd git-assets/concourse-workshop
./mvnw package
cp target/concourse-demo-*.jar ../app-output/concourse-demo.jar
