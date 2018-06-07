#!/usr/bin/env bash

set -ux

# Sample custom configuration script - add your own commands here
# to add some additional commands for your environment
#
# For example:
# yum install -y curl wget git tmux firefox xvfb
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
sudo yum install -y google-cloud-sdk

sudo yum install -y epel-release
sudo yum install -y jq
sudo yum install -y git
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce 
yum install -y java-1.8.0-openjdk-devel.x86_64
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl
yum install -y bc
yum install -y --nogpgcheck https://yum.puppetlabs.com/puppet/puppet-release-el-7.noarch.rpm
yum install -y --nogpgcheck puppet
/opt/puppetlabs/puppet/bin/gem install r10k --no-rdoc --no-ri
/opt/puppetlabs/puppet/bin/gem install generate-puppetfile
sed -i '/secure_path/ s/$/:\/opt\/puppetlabs\/puppet\/bin/' /etc/sudoers
echo 'Defaults env_keep += "SSH_AUTH_SOCK"' >> /etc/sudoers.d/ssh-auth-sock
chmod 0440 /etc/sudoers.d/ssh-auth-sock
cat <<! >> /etc/profile.d/puppet-agent.sh

# Add /opt/puppetlabs/puppet/bin to the path for sh compatible users

if ! echo \$PATH | grep -q /opt/puppetlabs/puppet/bin ; then
  export PATH=\$PATH:/opt/puppetlabs/puppet/bin
fi
!
cat <<! > /etc/profile.d/java.sh
export JAVA_HOME=/etc/alternatives/java_sdk
!
