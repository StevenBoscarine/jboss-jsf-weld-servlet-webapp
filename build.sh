#!/bin/sh

ARCHETYPE_BUILD_DIR=target/generated-sources/archetype
ARCHETYPE_DIR=target/archetype
ARCHETYPE_RESOURCES_DIR=$ARCHETYPE_DIR/src/main/resources/archetype-resources

echo Generating archetype from project into $ARCHETYPE_BUILD_DIR...
rm -Rf $ARCHETYPE_DIR/target
#svn rm --force $ARCHETYPE_DIR/*
rm -Rf target/generated-*
mvn archetype:create-from-project -Darchetype.properties=archetype.properties
echo Relocating generated archetype project to $ARCHETYPE_DIR...
rsync -az --exclude `basename $0` --exclude archetype-pom.xml $ARCHETYPE_BUILD_DIR/src $ARCHETYPE_DIR/
#svn revert -R $ARCHETYPE_DIR
cp -f archetype-pom.xml $ARCHETYPE_DIR/pom.xml
mvn -f $ARCHETYPE_DIR/pom.xml clean
echo Patching generated archetype...
# could also use col -b
sed -i 's;;;' $ARCHETYPE_RESOURCES_DIR/pom.xml
sed -i 's;;;' $ARCHETYPE_RESOURCES_DIR/readme.txt
sed -i 's;<name>jboss-jsf-weld-servlet-webapp-src</name>;<name>${name}</name>;' $ARCHETYPE_RESOURCES_DIR/pom.xml
if [ ! -z $1 ] && [ "$1" = "install" ]; then
   echo Installing archetype...
   shift
   mvn -f $ARCHETYPE_DIR/pom.xml install
fi

if [ ! -z $1 ] && [ "$1" = "generate" ]; then
   echo Generating project from archetype...
   cd target
   mvn archetype:generate -B -DarchetypeCatalog=local \
      -DarchetypeArtifactId=jboss-jsf-weld-webapp -DarchetypeGroupId=org.jboss.weld.archetypes -DarchetypeVersion=1.0.1-SNAPSHOT \
      -DartifactId=generated-project -DgroupId=com.acme -Dversion=1.0.0-SNAPSHOT -Dname="JSF and CDI Webapp"
fi

#cd target/archetype
#mvn release:prepare --batch-mode -Drelease -DdevelopmentVersion=1.0.1-SNAPSHOT -DreleaseVersion=1.0.1.Beta1 -Dtag=basic-javaee6-webapp-1.0.1.Beta1 -DdryRun=true
#mvn release:prepare --batch-mode -Drelease -DdevelopmentVersion=1.0.1-SNAPSHOT -DreleaseVersion=1.0.1.Beta1 -Dtag=basic-javaee6-webapp-1.0.1.Beta1 -Dresume=false
#mvn release:perform nexus:staging-close -Drelease
