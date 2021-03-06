#!/bin/bash

# Create Liberty Demo
echo "Download Liberty Demo"
cd ~/INSTALL/APPS
git clone https://github.com/niklaushirt/demoliberty.git
cd ~/INSTALL/APPS/demoliberty
docker build -t demoliberty:1.0.0 docker_100
docker build -t demoliberty:1.1.0 docker_110
docker build -t demoliberty:1.2.0 docker_120
docker build -t demoliberty:1.3.0 docker_130

docker login mycluster.icp:8500 -u admin -p admin
docker tag demoliberty:1.3.0 mycluster.icp:8500/default/demoliberty:1.3.0
docker tag demoliberty:1.2.0 mycluster.icp:8500/default/demoliberty:1.2.0
docker tag demoliberty:1.1.0 mycluster.icp:8500/default/demoliberty:1.1.0
docker tag demoliberty:1.0.0 mycluster.icp:8500/default/demoliberty:1.0.0
docker push mycluster.icp:8500/default/demoliberty:1.3.0
docker push mycluster.icp:8500/default/demoliberty:1.2.0
docker push mycluster.icp:8500/default/demoliberty:1.1.0
docker push mycluster.icp:8500/default/demoliberty:1.0.0

echo "SET WORKER PLACEMENT labels"
for ((i=0; i < $NUM_WORKERS; i++)); do
  kubectl label nodes ${WORKER_IPS[i]} placement=local
done
