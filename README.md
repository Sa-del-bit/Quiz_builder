# QuizBuilder - Full Stack Application

QuizBuilder is a full-stack web application that allows users to create, manage, and take quizzes. The application consists of a React frontend, Spring Boot backend, and MySQL database.

## Table of Contents
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Deployment Options](#deployment-options)
  - [Docker Deployment](#docker-deployment)
  - [Kubernetes Deployment with Ansible](#kubernetes-deployment-with-ansible)
- [Development Setup](#development-setup)
- [API Documentation](#api-documentation)
- [Troubleshooting](#troubleshooting)

## Architecture

The application follows a microservices architecture with the following components:

1. **Frontend**: React application that provides the user interface
2. **Backend**: Spring Boot REST API that handles business logic
3. **Database**: MySQL database for persistent storage

## Prerequisites

Before you begin, ensure you have the following installed:
- Docker
- Docker Compose (for Docker deployment)
- Kubernetes cluster (Minikube, EKS, GKE, etc.)
- Ansible (for Kubernetes deployment)
- kubectl
- Node.js (for development)
- Java 11+ (for development)
- Maven (for development)

## Project Structure

```
QuizBuilder/
├── backend/                 # Spring Boot backend application
│   ├── src/                 # Source code
│   ├── pom.xml              # Maven configuration
│   └── Dockerfile           # Docker configuration
├── frontend/                # React frontend application
│   ├── src/                 # Source code
│   ├── package.json         # Node.js dependencies
│   └── Dockerfile           # Docker configuration
├── k8s/                     # Kubernetes manifests
│   └── fullstackdeployment.yaml
├── ansible/                 # Ansible playbooks
│   ├── playbook.yaml
│   └── inventory
├── DEPLOYMENT_GUIDE.md      # Detailed deployment guide
├── deploy.sh                # Linux/Mac deployment script
├── deploy.bat               # Windows deployment script
└── README_DEPLOYMENT.md     # Deployment README
```

## Deployment Options

### Docker Deployment

1. Build and run the application using Docker Compose:
   ```bash
   docker-compose up --build
   ```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:9096

### Kubernetes Deployment with Ansible

1. Ensure you have the prerequisites installed:
   ```bash
   # Install Ansible
   pip install ansible
   
   # Install Kubernetes collection for Ansible
   ansible-galaxy collection install kubernetes.core
   ```

2. Run the Ansible playbook:
   ```bash
   cd ansible
   ansible-playbook playbook.yaml
   ```

3. Access the application:
   - Frontend: http://localhost:30082
   - Backend API: http://localhost:30083/api

## Development Setup

### Backend (Spring Boot)

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies and run:
   ```bash
   ./mvnw spring-boot:run
   ```
   
   Or on Windows:
   ```bash
   mvnw.cmd spring-boot:run
   ```

3. The backend will start on port 9096.

### Frontend (React)

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

4. The frontend will start on port 5173.

## API Documentation

The backend exposes the following REST endpoints:

### User Management
- `POST /api/users/signup` - Create a new user
- `POST /api/users/login` - Authenticate a user
- `GET /api/users/all` - Get all users

### Quiz Management
- `POST /api/quizzes` - Create a new quiz
- `GET /api/quizzes` - Get all quizzes
- `GET /api/quizzes/myquizzes/{username}` - Get quizzes created by a user
- `DELETE /api/quizzes/{id}` - Delete a quiz
- `GET /api/quizzes/{id}` - Get a specific quiz
- `GET /api/quizzes/domain/{domain}` - Get quizzes by domain
- `POST /api/quizzes/{id}/submit` - Submit quiz answers
- `GET /api/quizzes/results/user/{username}` - Get quiz results for a user

## Troubleshooting

### Common Issues

1. **Docker build fails**: Ensure Docker is running and you have internet connectivity to pull base images.

2. **Port conflicts**: If ports are already in use, modify the port mappings in Docker Compose file or Kubernetes manifests.

3. **Database connection issues**: Verify database credentials in application.properties and ensure the database service is running.

4. **Ansible playbook fails**: Ensure all prerequisites are installed and Kubernetes context is properly configured.

### Getting Help

If you encounter any issues, please check:
1. The console output for error messages
2. Application logs in the respective service containers
3. The [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed deployment instructions

For additional support, please open an issue on the repository.