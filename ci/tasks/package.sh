#!/bin/bash

set -xe

cd git-assets/
mvn -version
mvn help:active-profiles
mvn package
cp target/concourse-demo-*.jar ../app-output/concourse-demo.jar
