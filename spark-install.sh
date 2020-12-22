#!/bin/bash
wget https://archive.apache.org/dist/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz
tar -xvf spark-2.4.4-bin-hadoop2.7.tgz
sudo mv spark-2.4.4-bin-hadoop2.7 /opt/spark
cd /opt/spark
echo 'RUN rm $SPARK_HOME/jars/kubernetes-client-4.1.2.jar' >> kubernetes/dockerfiles/spark/Dockerfile
echo 'ADD https://repo1.maven.org/maven2/io/fabric8/kubernetes-client/4.5.1/kubernetes-client-4.5.1.jar $SPARK_HOME/jars' >> kubernetes/dockerfiles/spark/Dockerfile

minikube config set vm-driver hyperkit
minikube config set cpus 2
minikube config set memory 4096
minikube start
minikube dashboard &
./bin/docker-image-tool.sh -r k8s -m build
kubectl create clusterrolebinding default --clusterrole=edit --serviceaccount=default:default --namespace=default
