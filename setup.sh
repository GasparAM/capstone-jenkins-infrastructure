#!/bin/bash
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf upgrade
# Add required dependencies for the jenkins package
dnf install java -y
dnf install jenkins -y
systemctl daemon-reload
systemctl enable jenkins
rm -rf "/var/lib/jenkins/*"
mkdir -p /var/lib/jenkins
echo "/dev/sdh /var/lib/jenkins xfs defaults,nofail 0 0" >> /etc/fstab
mount -a
sed "s/<securityGroups.*/<securityGroups>${sg}<\/securityGroups>/g" /var/lib/jenkins/config.xml | sed "s/<subnet.*/<subnet>${sub1},${sub2}<\/subnet>/g" > /var/lib/jenkins/confiiii.xml
systemctl restart jenkins


