#!/bin/bash
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf upgrade
# Add required dependencies for the jenkins package
dnf install java -y
dnf install jenkins -y
dnf install git -y
systemctl daemon-reload
systemctl enable jenkins
dnf install git
rm -rf "/var/lib/jenkins/*"
mkdir -p /var/lib/jenkins
echo "/dev/sdh /var/lib/jenkins xfs defaults,nofail 0 0" >> /etc/fstab
mount -a
sed "s/<securityGroups.*/<securityGroups>${sg}<\/securityGroups>/g" /var/lib/jenkins/config.xml | sed "s/<subnet.*/<subnets>${sub1},${sub2}<\/subnets>/g" > /var/lib/jenkins/config_new.xml
rm -rf /var/lib/jenkins/config.xml
cp /var/lib/jenkins/config_new.xml /var/lib/jenkins/config.xml
systemctl restart jenkins


