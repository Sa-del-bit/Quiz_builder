# QuizBuilder Kubernetes Deployment

This repository contains all the necessary files and instructions to deploy the QuizBuilder full-stack application on Kubernetes using Ansible automation.

## Project Structure

```
QuizBuilder/
├── backend/                    # Spring Boot backend application
├── frontend/                   # React frontend application
├── k8s/                        # Kubernetes manifests
├── ansible/                    # Ansible playbooks
├── DEPLOYMENT_GUIDE.md         # Comprehensive deployment guide
├── README.md                   # Main project README
├── README_DEPLOYMENT.md        # This file
├── docker-compose.yml          # Docker Compose for local development
├── deploy.sh                   # Linux/Mac Kubernetes deployment script
├── deploy.bat                  # Windows Kubernetes deployment script
├── check-prerequisites.sh      # Linux/Mac prerequisites checker
└── check-prerequisites.bat     # Windows prerequisites checker
```

## Deployment Options

### Option 1: Using Docker Compose (Easiest for Local Development)

```bash
docker-compose up --build
```

Access the application:
- Frontend: http://localhost:3000
- Backend API: http://localhost:9096

### Option 2: Using Ansible (Recommended for Kubernetes)

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

### Option 3: Using Shell Script (Linux/Mac)

```bash
chmod +x deploy.sh
./deploy.sh
```

### Option 4: Using Batch Script (Windows)

```cmd
deploy.bat
```

## Prerequisites Check

You can verify if all prerequisites are installed:

### Linux/Mac:
```bash
chmod +x check-prerequisites.sh
./check-prerequisites.sh
```

### Windows:
```cmd
check-prerequisites.bat
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