sudo su

sudo firewall-cmd --zone=public --add-port=8088/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9870/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9864/tcp --permanent
sudo firewall-cmd --zone=public --add-port=19888/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8042/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8888/tcp --permanent
sudo firewall-cmd --zone=public --add-port=9000/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8081/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8082/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8083/tcp --permanent
sudo firewall-cmd --zone=public --add-port=2181/tcp --permanent
sudo firewall-cmd --zone=public --add-port=2888/tcp --permanent
sudo firewall-cmd --zone=public --add-port=3888/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8090/tcp --permanent

sudo firewall-cmd --reload

# druid and hadoop container installation
docker build -t hadoop .
docker run --hostname=druid-hadoop-demo -p 8088:8088 -p 9870:9870 -p 9864:9864 -p 19888:19888 -p 8042:8042 -p 8888:8888 -p 9000:9000 -p 8081:8081 -p 8082:8082 -p 8083:8083 -p 2181:2181 -p 2888:2888 -p 3888:3888 -p 8090:8090 --name hadoop -d hadoop
docker exec -it hadoop bash


cd /opt/hadoop/bin

./hadoop fs -mkdir /druid

./hadoop fs -mkdir /druid/segments

./hadoop fs -mkdir /quickstart

./hadoop fs -mkdir /user

./hadoop fs -chmod 777 /druid

./hadoop fs -chmod 777 /druid/segments

./hadoop fs -chmod 777 /quickstart

./hadoop fs -chmod -R 777 /tmp

./hadoop fs -chmod -R 777 /user

./hadoop fs -put /apache-druid-0.13.0-incubating/quickstart/tutorial/wikiticker-2015-09-12-sampled.json.gz /quickstart/wikiticker-2015-09-12-sampled.json.gz


cd /apache-druid-0.13.0-incubating

bin/supervise -c quickstart/tutorial/conf/tutorial-cluster.conf

# Open new terminal
sudo su
docker exec -it hadoop bash
cd /apache-druid-0.13.0-incubating

bin/post-index-task --file quickstart/tutorial/wikipedia-index.json

bin/post-index-task --file quickstart/tutorial/wikipedia-index-hadoop.json
