FROM centos:centos6
#MAINTAINER Ushio Shugo <ushio.s@gmail.com>

# using epel
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm 

# install supervisor
RUN yum install -y wget
RUN wget https://bootstrap.pypa.io/ez_setup.py -O - | python
RUN easy_install supervisor



# install packages
RUN yum -y --enablerepo=remi install mysql-server mysql
ADD ./root/packages.sh /packages.sh
RUN chmod 755 /packages.sh
RUN /packages.sh
RUN rm -f /packages.sh

# middleware settings
ADD ./root/etc/supervisord.conf /etc/supervisord.conf

# MySQL
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Remove pre-installed database
#RUN rm -rf /var/lib/mysql/*
ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf
ADD mysql_startup.sh /mysql_startup.sh

RUN chmod 755 /*.sh

# Exposed ENV
#ENV MYSQL_PASS **Random**

EXPOSE 80 3306

CMD ["/usr/bin/supervisord", "-n"]
