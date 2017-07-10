#!/bin/bash -eux
cd $(dirname $0)
DIR=$(pwd)
cd -
mvn -v
mkdir -p ~/.m2/
echo "login=neilellis" > ~/.github
echo "password=${GITHUB_PASSWORD}" >> ~/.github

cp $DIR/settings.xml ~/.m2/settings.xml
[[ ${CIRCLE_BRANCH} != 'master' ]] || ( mvn versions:set -DnewVersion=$(cat .release) && mvn versions:resolve-ranges && mvn versions:lock-snapshots )
mvn install -e -q -Drat.skip -Dsource.skip=true -DgenerateReports=false -Dmaven.javadoc.skip=true -Dmaven.test.skip
