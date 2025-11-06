# QuizBuilder Kubernetes Deployment

This repository contains all the necessary files and instructions to deploy the QuizBuilder full-stack application on Kubernetes using Ansible automation.

## Project Structure

```
QuizBuilder/
├── backend/                 # Spring Boot backend application
├── frontend/                # React frontend application
├── k8s/                     # Kubernetes manifests
├── ansible/                 # Ansible playbooks
├── DEPLOYMENT_GUIDE.md      # Comprehensive deployment guide
├── deploy.sh                # Linux/Mac deployment script
├── deploy.bat               # Windows deployment script
└── README_DEPLOYMENT.md     # This file
```

## Deployment Options

### Option 1: Using Ansible (Recommended)

1. Ensure you have Ansible installed:
   ```bash
   pip install ansible
   ansible-galaxy collection install kubernetes.core
   ```

2. Run the Ansible playbook:
   ```bash
   cd ansible
   ansible-playbook playbook.yaml
   ```

### Option 2: Using Shell Script (Linux/Mac)

```bash
chmod +x deploy.sh
./deploy.sh
```

### Option 3: Using Batch Script (Windows)

```cmd
deploy.bat
```

## Architecture

The deployment consists of three main components:

1. **MySQL Database**: Persistent storage for quiz data
2. **Backend Service**: Spring Boot application exposing REST APIs
3. **Frontend Service**: React application serving the user interface

Each component runs in its own pod and is accessible through Kubernetes services.

## Accessing the Application

After deployment, the application will be available at:
- **Frontend**: http://localhost:30082/
- **Backend API**: http://localhost:30083/api/

## Customization

You can customize the deployment by modifying:
- Database credentials in `k8s/fullstackdeployment.yaml`
- Port numbers in the services
- Resource limits for each deployment
- Number of replicas for each service

## Troubleshooting

Refer to the [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed troubleshooting steps.