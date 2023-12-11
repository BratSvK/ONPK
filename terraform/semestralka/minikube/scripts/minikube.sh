#!/bin/bash

K8S_VERSION="v1.23.13"

### conntrack: install
apt -y install conntrack

### kubectl: install
curl --silent -LO https://storage.googleapis.com/kubernetes-release/release/$K8S_VERSION/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

### minikube: install
curl --silent -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

### minikube: start
su - ubuntu -c "minikube start --kubernetes-version=${K8S_VERSION} --nodes=2"
su - ubuntu -c "minikube addons enable ingress"
su - ubuntu -c "minikube status"

### minikube: multinode cluster a perzistencia
su - ubuntu -c "minikube addons enable volumesnapshots"
su - ubuntu -c "minikube addons enable csi-hostpath-driver"
su - ubuntu -c "minikube addons disable storage-provisioner"
su - ubuntu -c "minikube addons disable default-storageclass"
su - ubuntu -c "kubectl patch storageclass csi-hostpath-sc -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}"
