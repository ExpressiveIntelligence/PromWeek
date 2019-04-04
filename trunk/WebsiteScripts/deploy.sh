#!/bin/bash
#
# Promweek deployment script
#
# Set environment variables PROM_USER and PROM_PASS
# to your WebDAV account and run this script
#
# It will first upload the scripts and tests to
# the /staging/ directory, run the tests and only
# if there are no errors deploy it to the production
# path /
#

# Configuration
FILES="*.php *.html tests/* tests/fixtures/* facebook/* crossdomain.xml"
DEPLOYMENT_URL=https://promweek.soe.ucsc.edu:90/htdocs
STAGING_URL=$DEPLOYMENT_URL/staging
TEST_URL=http://promweek.soe.ucsc.edu/staging/vpu/index.php
TEST_DATA="store_statistics=1\
&create_snapshots=1\
&snapshot_directory=/www/promweek.soe.ucsc.edu/htdocs/staging/vpu/history/\
&sandbox_errors=0\
&sandbox_filename=/www/promweek.soe.ucsc.edu/htdocs/staging/vpu/errors/error.tmp\
&test_files=/www/promweek.soe.ucsc.edu/htdocs/staging/tests/APITests.php|"

# Deployment code
echo -e "\033[1mPromweek backend deployment\033[0m"
echo "Starting at `date`"
echo 

# Read username and password for webdav if not set
if [ -z "$PROM_USER" ]; then
	read -p "Enter WebDAV username: " WEBDAV_USER
fi

if [ -z "$PROM_PASS" ]; then
	read -s -p "Enter WebDAV password: " WEBDAV_PASS
fi

echo -e "\n\033[1mUploading files to staging directory\033[0m"

# Upload files to staging area
for i in $FILES; do
	curl -s -f -T $i -u $PROM_USER:$PROM_PASS $STAGING_URL/$i > /dev/null
	echo -n $i ...
	
	if [ $? -ne 0 ]; then
		echo -e " \033[31mFAILED\033[0m"
		echo "Uploading $i to $STAGING_URL/$i failed"
		exit 1
	fi
	
	echo " OK"
done

# Run PHPUnit tests
echo -e "\n\033[1mRunning PHPUnit tests on server\033[0m"
  
OUTPUT=`curl -s -X POST -d "$TEST_DATA" $TEST_URL`

echo $OUTPUT | grep "title='Failed' data-percent='0'" > /dev/null

if [ $? -ne 0 ]; then
  echo -e "\033[31mSome tests failed, deployment aborted.\033[0m"
  echo "For details, check the results at $TEST_URL"
  exit 1
else
  echo "Successful."
fi

# upload files to deployment directory
echo -e "\n\033[1mDeploying files\033[0m"
for i in $FILES; do
	curl -s -f -T $i -u $PROM_USER:$PROM_PASS $DEPLOYMENT_URL/$i > /dev/null
	echo -n $i ...
	
	if [ $? -ne 0 ]; then
		echo -e " \033[31mFAILED\033[0m"
		echo "Uploading $i to $DEPLOYMENT_URL/$i failed"
		exit 1
	fi
	
	echo " OK"
done

echo -e "\n\033[1m\033[32mDeployment done at `date`\033[0m"
