#!/bin/bash

# This script to deploy KubeArmor and karmor CLI
# Installs Locust, prometheus and grafana 

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Step 1: Install Helm if it's not already installed
if ! command_exists helm; then
    echo "Helm is not installed. Installing Helm."
    snap install helm --classic
else
    echo "Helm is already exists."
fi

# Export Kubeconfig
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Step 2: Add the KubeArmor Helmchart repository and install KubeArmor
echo " === Adding KubeArmor Helm repository ==="
helm repo add kubearmor https://kubearmor.github.io/charts

echo " === Updating Helm repositories ==="
helm repo update kubearmor

echo "=== Download KubeArmor Package ==="
wget https://github.com/KubeArmor/KubeArmor/releases/download/v1.4.1/kubearmor_1.4.1_linux-amd64.tar.gz
sleep 3 

# Unpack the tarball
echo "Unpack the downloaded KubeArmor package"
sudo tar --no-overwrite-dir -C / -xzf kubearmor_1.4.1_linux-amd64.tar.gz
# Daemon reload
sudo systemctl daemon-reload
sleep 3
sudo systemctl start kubearmor
sleep 2
echo "======== KubeArmor installed ========="

# Step 3: Install karmor CLI 
echo "=== Install karmor CLI === "
curl -sfL http://get.kubearmor.io/ | sudo sh -s -- -b /usr/local/bin
sleep 2

# Step 4: Install Nginx webserver - sample application test script
echo "=== Install Nginx ==="
kubectl run nginx-pod --image=nginx --restart=Never --port=80 -n default
# Nginx port forward
kubectl expose pod nginx-pod --type=NodePort --port=80 --name=nginx-service
sleep 2
echo "======== nginx installed ========="

# Step 5: Install Prometheus using Helm and expose its service
echo "Installing Prometheus using Helm..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus 

echo "Exposing Prometheus service..."
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext

# Step 6: Install Grafana using Helm and expose its service
echo "Installing Grafana using Helm..."
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana

echo "Exposing Grafana service..."
kubectl expose service grafana --type=NodePort --target-port=8080 --name=grafana-ext
sleep 2 
## reload daemon
sudo systemctl daemon-reload

# Step 7: Install locust
echo " === Install locust ==="
sudo apt install locust 
sleep 2
echo " ======== Installation and setup completed successfully. ======="

# Step 8:  Get the grafana password
echo "=== Get the grafana password to login to Grafana dashboard === "
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Step 9: Write locust file to generate load - Ec2 instance IP and port hardcode, make it variable an dread from
#Ec2 instance to be considered in script enhancement
echo "========= Kubearmor and all tools installed successfully =========="
sudo systemctl status kubearmor 
echo "===== Deployment done successfully ============"
#echo " === Generate load on nginx server running in Kubernetes cluster ==="
#locust -f webpage.py --headless -u 15 -r 3 --run-time 30s --host="100.27.219.175:31903"




