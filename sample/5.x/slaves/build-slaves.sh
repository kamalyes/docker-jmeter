#!/bin/bash
export DOCKER_SCAN_SUGGEST=false
docker build --tag kamalyes/jmeter-base .
# docker network create --driver bridge --subnet 172.19.0.0/16 jmeter
for index in $(seq 1 6)
do
  if [ "$index" -le "1" ]
  then
    docker run -it -d --privileged=true --net=jmeter --name jmeter-master -e JMETER_JVM_ARGS="-Xmx2G -Xms1G" -p 1009${index}:1099 -p 5000${index}:50000 kamalyes/jmeter-base
    docker cp jmeter.properties jmeter-master:/opt/apache-jmeter/bin/jmeter.properties
    docker cp project jmeter-master:/jmeter
    docker cp lib jmeter-master:/opt/apache-jmeter
  else
    docker run -it -d --privileged=true --net=jmeter --name jmeter-slave${index} -e JMETER_JVM_ARGS="-Xmx2G -Xms1G" -p 1009${index}:1099 -p 5000${index}:50000 kamalyes/jmeter-base
    docker cp jmeter.properties jmeter-slave${index}:/opt/apache-jmeter/bin/jmeter.properties
    docker cp project jmeter-slave${index}:/jmeter
    docker cp lib jmeter-slave${index}:/opt/apache-jmeter
  fi
done 
# cd /jmeter/project/ && mkdir result report && ls -ll
# jmeter -n -t test-influxdbv1.jmx -l result/test-influxdbv1.jtl -e -o report/test-influxdbv1  -R 172.19.0.2:1099,172.19.0.3:1099,172.19.0.4:1099,172.19.0.5:1099
# jmeter -n -t test-influxdbv2.jmx -l result/test-influxdbv2.jtl -e -o report/test-influxdbv2  -R 172.19.0.2:1099,172.19.0.3:1099,172.19.0.4:1099,172.19.0.5:1099
# rm -rf jmeter.log report/ result/