# Yii2 Application Deployment with Docker Swarm, NGINX, CI/CD using GitHub Actions and Monitoring using Node Exporter & Prometheus.

## Overview

This project automates the deployment of a sample PHP **Yii2** application using **Docker Swarm** and **NGINX** as a reverse proxy on an **AWS EC2 instance**. It includes **CI/CD with GitHub Actions** and **monitoring via Prometheus and Node Exporter** for infrastructure health insights.

---

## 🛠 This project covers two key workflows:

1. **Infrastructure Provisioning**: Using **Ansible** to configure servers and deploy the app.
2. **CI/CD Pipeline**: Automatically deploys updates via **GitHub Actions** on code push.

> ⚠️ Some paths and values are hardcoded for ease of use in testing and demo scenarios.

---

## 🔧 Key Components

### 1. **Ansible for Infrastructure Setup**
Used to provision:
- Docker
- NGINX
- Docker Swarm initialization
- Prometheus and Node Exporter for monitoring

### 2. **Sample Yii2 Application**
Sample app from [official Yii2 repository](https://github.com/yiisoft/yii2-app-basic), containerized using a custom Dockerfile.

### 3. **Docker Swarm**
Enables clustering and scaling of the application.

### 4. **NGINX Reverse Proxy**
Serves incoming traffic to the running Yii2 app in containers.

### 5. **CI/CD via GitHub Actions**
- On push to `main`, builds and deploys updated containers to EC2 via SSH and Docker Swarm.

### 6. **Prometheus Monitoring**
Collects system and Docker metrics from the EC2 host and exposes prometheus on port 9090.

---

## 🚀 Setup and Deployment

### ✅ Prerequisites

- **AWS EC2 Instance** with public IP and SSH access
- Local environment variables:
  
```bash
export DOCKER_USERNAME="your_dockerhub_username"
export DOCKER_PASSWORD="your_dockerhub_token"
```

- GitHub secrets:

| Secret Name     | Description                                     |
|-----------------|-------------------------------------------------|
| `EC2_HOST`      | Public IP of EC2                         |
| `EC2_USERNAME`  | SSH username (e.g., ubuntu/ec2-user)           |
| `EC2_SSH_KEY`   | Private SSH key                                 |
| `DOCKER_USERNAME` | Docker Hub username                          |
| `DOCKER_PASSWORD` | Docker Hub access token                      |

---

## 📁 Project Structure

```plaintext
.
├── .github/
│   └── workflows/
│       └── deploy.yml              # GitHub Actions CI/CD pipeline
├── ansible/
│   ├── main_ansible_file.yaml     # Main orchestration playbook
│   ├── hosts.ini                  # Inventory of EC2 servers
│   ├── ssh-key.pem                # SSH key template (replace with your key)
│   └── dependencies/
│       ├── install_docker.yaml           # Install Docker
│       ├── install_nginx_php.yaml        # Install NGINX + PHP
│       ├── configure_nginx.yml           # Configure NGINX reverse proxy
│       ├── init_swarm.yaml               # Initialize Docker Swarm
│       ├── deploy-docker-swarm.yaml      # Deploy Yii2 as Swarm service
│       ├── install_prometheus.yml        # Install Prometheus on the server
│       └── install_node_exporter.yml     # Deploys Node Exporter for metrics scraping
├── config/                       # Yii2 configuration
├── docker-compose.yml            # For local dev
├── Dockerfile                    # Dockerfile to containerize Yii2
├── requirements.php              # Yii2 PHP requirements
├── yii                           # Yii2 CLI entry
└── README.md                     # This README
```

---

## 📝 Usage Guide

### Step 1: Clone Repository

```bash
git clone https://github.com/erjunaidwani/sample-app.git
cd sample-app/ansible
```
### Run chmod 400 ssh-key.pem

### Step 2: First-Time Setup Using Ansible

```bash
ansible-playbook main_ansible_file.yaml -i hosts.ini --private-key ssh-key.pem
```

This will:

- Install Docker and Docker Swarm
- Install and configure NGINX
- Deploy the Yii2 app as a Docker service
- Set up Prometheus and Node Exporter

### Step 3: Access Application

After deployment, visit:

```
http://<your-ec2-public-ip>
```
> ⚠️ Please note that we need to open IP addrees and not any DNS as of now, as we have set IP in nginx.
---

## 🔁 CI/CD via GitHub Actions

The GitHub Actions workflow is triggered on every push to `main`. It:

1. Checks out the code
2. Builds Docker image
3. Pushes image to Docker Hub
4. SSH into EC2 and updates the Docker Swarm service

---

## 📊 Monitoring Setup

Basic infrastructure monitoring is included using:

### 📦 Node Exporter

- Runs in a Docker container
- Exposes system-level metrics at `:9100`
- Automatically scraped by Prometheus

---

### 🖥 Prometheus

- Installed on the EC2 instance
- Collects system metrics and application stats
- Runs as a systemd service

Access Prometheus dashboard:

```
http://<EC2_PUBLIC_IP>:9090
```
> ⚠️ Please note that we need to open IP addrees and not any DNS as of now, as we have set IP in nginx.

> Prometheus config is stored in `/etc/prometheus/prometheus.yml`


## ✅ Testing & Logs

- Docker Logs:
  ```bash
  docker service logs <service_name>
  ```
- NGINX Logs:
  ```bash
  /var/log/nginx/access.log
  /var/log/nginx/error.log
  ```
- Prometheus Status:
  ```bash
  systemctl status prometheus
  ```

---

## 💡 Assumptions

- Ports 22, 80, 9090 are allowed in EC2 security group
- App is available over HTTP (HTTPS not configured yet)
- Valid SSH access is configured

---
## 📩 Contact
For issues or help, open an issue or reach me via email:  
📧 **erjuanidwani@gmail.com**
---
