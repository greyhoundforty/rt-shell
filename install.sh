#!/bin/bash
set -e
export SHELLOPTS

# SoftLayer
echo ">> softlayer"
pip3 install softlayer

useradd -m -g users -G sudo -s `which zsh` ryan 

# IBM Cloud CLI
echo ">> ibmcloud"
curl -fsSL https://clis.ng.bluemix.net/install/linux > /tmp/bxinstall.sh
sh /tmp/bxinstall.sh
rm /tmp/bxinstall.sh

# IBM Cloud CLI plugins
echo ">> ibmcloud plugins"
ibmcloud_plugins=( \
  code-engine \
  cloud-databases \
  cloud-dns-services \
  cloud-functions \
  cloud-internet-services \
  cloud-object-storage \
  container-registry \
  container-service \
  vpc-infrastructure \
  schematics \
  tg \
)
for plugin in "${ibmcloud_plugins[@]}"
do
  ibmcloud plugin install $plugin -f -r "IBM Cloud"
done

# OpenShift CLI
# echo ">> openshift client tools"
# curl -LO $(get_latest "openshift/origin" openshift-origin-client-tools.*linux-64bit)
# tar zxvf openshift-origin*.tar.gz
# mv openshift-origin-*/oc /usr/local/bin/oc
# mv openshift-origin-*/kubectl /usr/local/bin/ockubectl
# rm -rf openshift-origin-*

# Kubernetes
echo ">> kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl --retry 10 --retry-delay 5 -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
mv kubectl /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl

# Kubetail
echo ">> kubetail"
curl -LO https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail
mv kubetail /usr/local/bin/kubetail
chmod +x /usr/local/bin/kubetail

# Helm
echo ">> helm"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Expose configuration to be overriden
mkdir -p /home/ryan/mnt/config

# IBM Cloud CLI configuration
if [[ -f /home/ryan/.bluemix/config.json ]]; then 
  rm /home/ryan/.bluemix/config.json
fi
touch /home/ryan/mnt/config/bx-config.json
ln -s /home/ryan/mnt/config/bx-config.json /home/ryan/.bluemix/config.json

# IBM Cloud CF configuration
rm /home/ryan/.bluemix/.cf/config.json
touch /home/ryan/mnt/config/cf-config.json
ln -s /home/ryan/mnt/config/cf-config.json /home/ryan/.bluemix/.cf/config.json

# IBM Cloud Cloud Functions configuration
touch /home/ryan/mnt/config/wsk.props
ln -s /home/ryan/mnt/config/wsk.props /home/ryan/.wskprops

rm -f /home/ryan/.bluemix/plugins/cloud-functions/config.json
mkdir /home/ryan/mnt/config/cloud-functions
touch /home/ryan/mnt/config/cloud-functions/config.json
ln -s /home/ryan/mnt/config/cloud-functions/config.json /home/ryan/.bluemix/plugins/cloud-functions/config.json

# IBM Cloud container-registry
mkdir /home/ryan/mnt/config/container-registry
ln -s /home/ryan/mnt/config/container-registry/config.json /home/ryan/.bluemix/plugins/container-registry/config.json

# IBM Cloud container-service
mkdir /home/ryan/mnt/config/container-service
ln -s /home/ryan/mnt/config/container-service/config.json /home/ryan/.bluemix/plugins/container-service/config.json
ln -s /home/ryan/mnt/config/container-service/clusters /home/ryan/.bluemix/plugins/container-service/clusters

# IBM Cloud code-engine
mkdir /home/ryan/mnt/config/code-engine
rm -f /home/ryan/.bluemix/plugins/code-engine/config.json
ln -s /home/ryan/mnt/config/code-engine/config.json /home/ryan/.bluemix/plugins/code-engine/config.json

# IBM Cloud vpc-infrastructure
rm -f /home/ryan/.bluemix/plugins/vpc-infrastructure/config.json
mkdir /home/ryan/mnt/config/vpc-infrastructure
ln -s /home/ryan/mnt/config/vpc-infrastructure/config.json /home/ryan/.bluemix/plugins/vpc-infrastructure/config.json

# SoftLayer CLI
touch /home/ryan/mnt/config/slcli.conf
ln -s /home/ryan/mnt/config/slcli.conf /home/ryan/.softlayer

# IBM Cloud SoftLayer service
mkdir /home/ryan/mnt/config/softlayer
ln -s /home/ryan/mnt/config/softlayer /home/ryan/.bluemix/plugins/softlayer

# Helm configuration
mkdir /home/ryan/mnt/config/helm
ln -s /home/ryan/mnt/config/helm /home/ryan/.helm

# Docker configuration
mkdir /home/ryan/mnt/config/docker
ln -s /home/ryan/mnt/config/docker /home/ryan/.docker

