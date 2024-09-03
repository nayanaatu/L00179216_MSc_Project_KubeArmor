# L00179216_MSc_Project_KubeArmor
MSc DevOps dissertation repo
# KubeArmor_deploy.sh:   
To install KubeArmor and locust, Performance monitoring tools
on kubernetes cluster. Prometheus and grafana tools will be installed
Locust used to generate load on given host
# nginx_webpage_load_test.py: 
Basic locust file used by locust command line to generate load based on cli parameters
ex: locust -f /usr/lib/python3.12/nginx_webpage_load_test.py --headless -u 15 -r 3 --run-time 30s --host="http://<ngix_ip>:<port>" 
# kubeArmor_hostpolicy.yaml
sample host policy file to block sleep command to check kubeArmor behaviour
# terraform/k3s.sh 
Install single node kubernetes cluster
# terraform/vpc.tf
Create VPC based on configuration mentioned in this file
# terraform/provider.tf
service provider details like AWS-ec2
# terraform/terraform.tfvars
to create AWS ec2 instance based on configuration mentioned in this file
