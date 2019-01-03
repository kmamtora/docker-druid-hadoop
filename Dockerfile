FROM ubuntu:17.10

COPY config/ /tmp/

ENV HADOOP_HOME /opt/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=/apache-druid-0.13.0-incubating/bin:${PATH}

RUN apt-get update
RUN apt-get install -y --reinstall build-essential
RUN apt-get install -y ssh 
RUN apt-get install -y rsync 
RUN apt-get install -y vim 
RUN apt-get install -y net-tools
RUN apt-get install -y openjdk-8-jdk 
RUN apt-get install -y python2.7-dev 
RUN apt-get install -y libxml2-dev 
RUN apt-get install -y libkrb5-dev 
RUN apt-get install -y libffi-dev 
RUN apt-get install -y libssl-dev 
RUN apt-get install -y libldap2-dev 
RUN apt-get install -y python-lxml 
RUN apt-get install -y libxslt1-dev 
RUN apt-get install -y libgmp3-dev 
RUN apt-get install -y libsasl2-dev 
RUN apt-get install -y libsqlite3-dev  
RUN apt-get install -y libmysqlclient-dev

RUN \
    if [ ! -e /usr/bin/python ]; then ln -s /usr/bin/python2.7 /usr/bin/python; fi

# If you have already downloaded the tgz, add this line OR comment it AND ...
#ADD hadoop-3.1.0.tar.gz /

# ... uncomment the 2 first lines
RUN \
#   wget http://apache.crihan.fr/dist/hadoop/common/hadoop-3.1.0/hadoop-3.1.0.tar.gz && \
    wget https://archive.apache.org/dist/hadoop/core/hadoop-2.8.3/hadoop-2.8.3.tar.gz && \
    tar -xzf hadoop-2.8.3.tar.gz && \
    mv hadoop-2.8.3 $HADOOP_HOME && \
    for user in hadoop hdfs yarn mapred hue; do \
         useradd -U -M -d /opt/hadoop/ --shell /bin/bash ${user}; \
    done && \
    for user in root hdfs yarn mapred hue; do \
         usermod -G hadoop ${user}; \
    done && \
    echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#    echo "export HDFS_DATANODE_SECURE_USER=hdfs" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc

RUN cp /tmp/*.xml $HADOOP_HOME/etc/hadoop/

####################################################################################

WORKDIR /

#RUN yum update -y
RUN apt-get install sudo tar curl perl -y

RUN curl https://www-us.apache.org/dist/incubator/druid/0.13.0-incubating/apache-druid-0.13.0-incubating-bin.tar.gz -o apache-druid-0.13.0-incubating-bin.tar.gz 

RUN curl https://archive.apache.org/dist/zookeeper/zookeeper-3.4.11/zookeeper-3.4.11.tar.gz -o zookeeper-3.4.11.tar.gz

RUN tar -xvzf apache-druid-0.13.0-incubating-bin.tar.gz && \
	rm -f apache-druid-0.13.0-incubating-bin.tar.gz

RUN tar -xvzf zookeeper-3.4.11.tar.gz && \
	rm -f zookeeper-3.4.11.tar.gz && \
	mv zookeeper-3.4.11 apache-druid-0.13.0-incubating/zk

RUN mkdir apache-druid-0.13.0-incubating/quickstart/tutorial/conf/druid/_common/hadoop-xml

RUN mv /tmp/*.xml apache-druid-0.13.0-incubating/quickstart/tutorial/conf/druid/_common/hadoop-xml/

RUN mv /tmp/common.runtime.properties apache-druid-0.13.0-incubating/quickstart/tutorial/conf/druid/_common/

EXPOSE 8081 8082 8083 2181 2888 3888 8090


####################################################################################

RUN \
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# ADD *xml $HADOOP_HOME/etc/hadoop/


RUN mv /tmp/ssh_config /root/.ssh/config

#ADD hue.ini /opt/hue/desktop/conf

RUN mv /tmp/start-all.sh /start-all.sh

EXPOSE 8088 9870 9864 19888 8042 8888

CMD bash start-all.sh
