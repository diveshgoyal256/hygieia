#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
echo "creating $PROP_FILE for jenkins collector"
cat > $PROP_FILE <<EOF
#Database Name - default is test
dbname=dashboarddb

#Database HostName - default is localhost
dbhost=mongodb4collectors.nbsdev.co.uk

#Database Port - default is 27017
dbport=27017

server.contextPath=/api
server.port=8080

#API encryption key. Optional. See https://hygieia.github.io/Hygieia/setup.html#encryption-for-private-repos
#Randomly generated key	
key=DfvBg+AOGol5fOofjMdPYtpYGQ1rH4km

#Authentication Settings
# JWT expiration time in milliseconds
# Secret Key used to validate the JWT tokens
auth.authenticationProviders=STANDARD
auth.expirationTime=25000000

# Jenkins Properties #

jenkins.cron=${JENKINS_CRON:-}

jenkins.folderDepth:20
 #Jenkins server (required) - Can provide multiple
jenkins.servers[0]=http://dvsadevopsw01:8090/cloudbees-core-cm/
jenkins.servers[1]=${JENKINS_SERVER_1:-}
jenkins.servers[2]=${JENKINS_SERVER_2:-}
jenkins.servers[3]=${JENKINS_SERVER_3:-}
jenkins.servers[4]=${JENKINS_SERVER_4:-}
jenkins.servers[5]=${JENKINS_SERVER_5:-}
jenkins.usernames[0]=snadash01
jenkins.apiKeys[0]=11965d3189cda910d8c3dcb031cef74c45
jenkins.saveLog=false
jenkins.niceNames[0]=SnA
jenkins.niceNames[1]=openBanking
jenkins.niceNames[2]=infraSIT
jenkins.niceNames[3]=rio
jenkins.niceNames[4]=switcher
jenkins.niceNames[5]=ops
jenkins.environments[0]=dev
jenkins.environments[1]=dev
jenkins.environments[2]=sit
jenkins.environments[3]=devft1
# The page size
jenkins.pageSize=1000
jenkins.connectTimeout=500000
jenkins.readTimeout=5000000

jenkins.searchFields[0]= options.jobName
jenkins.searchFields[1]= niceName 

EOF

/usr/bin/java -Djavax.net.ssl.trustStore=/usr/lib/jvm/java-openjdk/jre/lib/security/cacerts -Dlogging.config=file:/hygieia/collectors/logback_jenkins.xml -jar /hygieia/collectors/jenkins-build-collector.jar --spring.config.name=jenkins --spring.config.location=/hygieia/application.properties
#/usr/bin/java -Dlogging.config=file:/hygieia/collectors/logback_jenkins.xml -jar /hygieia/collectors/jenkins-build-collector.jar --spring.config.name=jenkins --spring.config.location=/hygieia/application.properties
exec "$@"
