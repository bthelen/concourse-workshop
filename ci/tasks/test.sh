#!/bin/bash

set -xe

cd git-assets
mvn -version
mvn help:active-profiles
mvn test
