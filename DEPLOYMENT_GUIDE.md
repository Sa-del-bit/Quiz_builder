# QuizBuilder Application Deployment on Kubernetes using Ansible

## Overview
This guide provides step-by-step instructions to deploy the QuizBuilder full-stack application on Kubernetes using Ansible automation.

## Prerequisites
1. Docker installed and running
2. Kubernetes cluster (Minikube, EKS, GKE, AKS, etc.)
3. Ansible installed
4. kubectl configured to interact with your Kubernetes cluster

## Project Structure
```
QuizBuilder/
├── backend/                 # Spring Boot backend
├── frontend/                # React frontend
├── k8s/                     # Kubernetes manifests
├── ansible/                 # Ansible playbooks
└── DEPLOYMENT_GUIDE.md      # This file
```

## Step 1: Containerization

### Backend Dockerfile
The backend Dockerfile is located at `backend/Dockerfile`:

```dockerfile
# Use OpenJDK 21 as the base image
FROM openjdk:21-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper and pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Copy the source code
COPY src src

# Build the application
RUN ./mvnw clean package -DskipTests

# Expose port 9096
EXPOSE 9096

# Run the application
ENTRYPOINT ["java", "-jar", "target/quiz-builder-backend-0.0.1-SNAPSHOT.jar"]
```

### Frontend Dockerfile
The frontend Dockerfile is located at `frontend/Dockerfile`:

```dockerfile
# Use Node.js 18 as the base image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Install serve to serve the static files
RUN npm install -g serve

# Expose port 3000
EXPOSE 3000

# Serve the application
CMD ["serve", "-s", "dist", "-l", "3000"]
```

## Step 2: Kubernetes Manifests

The Kubernetes deployment file is located at `k8s/fullstackdeployment.yaml`:

```yaml
# =========================
# MySQL Deployment & PVC
# =========================
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql:8.0
          env:
            - name: MYSQL_DATABASE
              value: quiz
            - name: MYSQL_ROOT_PASSWORD
              value: Charan_@2005
          ports:
            - containerPort: 3306
          volumeMounts:
            - name: mysql-data
              mountPath: /var/lib/mysql
      volumes:
        - name: mysql-data
          persistentVolumeClaim:
            claimName: mysql-pvc

---
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  type: ClusterIP
  selector:
    app: mysql
  ports:
    - port: 3306
      targetPort: 3306

# =========================
# Backend Deployment
# =========================
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      initContainers:
        - name: wait-for-mysql
          image: busybox
          command: ['sh', '-c', 'until nc -z mysql 3306; do echo waiting for mysql; sleep 2; done;']
      containers:
        - name: backend
          image: quiz-backend:latest
          ports:
            - containerPort: 9096
          env:
            - name: SPRING_DATASOURCE_URL
              value: jdbc:mysql://mysql:3306/quiz
            - name: SPRING_DATASOURCE_USERNAME
              value: root
            - name: SPRING_DATASOURCE_PASSWORD
              value: Charan_@2005
            - name: SPRING_JPA_HIBERNATE_DDL_AUTO
              value: update
            - name: SPRING_JPA_DATABASE_PLATFORM
              value: org.hibernate.dialect.MySQL8Dialect

---
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  type: NodePort
  selector:
    app: backend
  ports:
    - port: 9096
      targetPort: 9096
      nodePort: 30083

# =========================
# ConfigMap for Frontend
# =========================
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: frontend-config
data:
  REACT_APP_BACKEND_URL: "http://backend:9096"

# =========================
# Frontend Deployment
# =========================
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: quiz-frontend:latest
          ports:
            - containerPort: 3000
          env:
            - name: REACT_APP_BACKEND_URL
              valueFrom:
                configMapKeyRef:
                  name: frontend-config
                  key: REACT_APP_BACKEND_URL

---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 30082
```

## Step 3: Ansible Playbook

The Ansible playbook is located at `ansible/playbook.yaml`:

```yaml
---
- name: Fullstack App Deployment on Kubernetes
  hosts: localhost
  connection: local
  gather_facts: yes

  vars:
    k8s_manifest_path: "../k8s/fullstackdeployment.yaml"
    frontend_nodeport: 30082
    backend_nodeport: 30083
    backend_image: "quiz-backend:latest"
    frontend_image: "quiz-frontend:latest"

  tasks:

    - name: Gather system facts
      ansible.builtin.setup:

    - name: Ensure Docker service is running
      ansible.builtin.service:
        name: docker
        state: started
        enabled: yes

    - name: Start Minikube (if not running)
      shell: |
        if ! minikube status 2>/dev/null | grep -q "Running"; then
          echo "Starting Minikube using Docker driver..."
          minikube start --driver=docker --memory=2000 --cpus=2
        else
          echo "Minikube already running."
        fi
      args:
        executable: /bin/bash

    - name: Build backend Docker image
      shell: |
        cd ../backend && docker build -t {{ backend_image }} .
      args:
        executable: /bin/bash

    - name: Build frontend Docker image
      shell: |
        cd ../frontend && docker build -t {{ frontend_image }} .
      args:
        executable: /bin/bash

    - name: Load images into Minikube
      shell: |
        minikube image load {{ backend_image }}
        minikube image load {{ frontend_image }}
      args:
        executable: /bin/bash

    - name: Copy Kubernetes deployment file
      ansible.builtin.copy:
        src: "{{ k8s_manifest_path }}"
        dest: /tmp/fullstackdeployment.yaml
        force: yes

    - name: Apply Kubernetes manifests
      shell: kubectl apply -f /tmp/fullstackdeployment.yaml
      args:
        executable: /bin/bash

    - name: Wait for all pods to be running
      shell: |
        kubectl get pods --no-headers | grep -v Running || true
      register: pod_status
      until: pod_status.stdout == ""
      retries: 20
      delay: 10
      args:
        executable: /bin/bash

    - name: Display all services
      shell: kubectl get svc
      register: svc_output
      args:
        executable: /bin/bash

    - name: Print services table
      debug:
        msg: "{{ svc_output.stdout }}"

    # -------------------------------
    # NodePort forwarding (background)
    # Keeps services accessible even after terminal closes
    # -------------------------------
    - name: Forward backend service port 30083 -> 9096 (background)
      shell: |
        nohup kubectl port-forward svc/backend {{ backend_nodeport }}:9096 >/dev/null 2>&1 &
      args:
        executable: /bin/bash

    - name: Forward frontend service port 30082 -> 3000 (background)
      shell: |
        nohup kubectl port-forward svc/frontend {{ frontend_nodeport }}:3000 >/dev/null 2>&1 &
      args:
        executable: /bin/bash

    - name: Show access URLs
      debug:
        msg:
          - "✅ Frontend: http://localhost:{{ frontend_nodeport }}/"
          - "✅ Backend:  http://localhost:{{ backend_nodeport }}/api/"
```

## Step 4: Frontend API Configuration

Update the frontend API configuration in `frontend/src/api.js`:

```javascript
import axios from "axios";

const USER_API_URL = "/api/users";
const QUIZ_API_URL = "/api/quizzes";

// ... rest of the file remains the same
```

## Step 5: Deployment Process

1. **Install Prerequisites**:
   ```bash
   # Install Docker
   # Install Kubernetes (Minikube, kubectl)
   # Install Ansible
   pip install ansible
   ansible-galaxy collection install kubernetes.core
   ```

2. **Run the Ansible Playbook**:
   ```bash
   cd ansible
   ansible-playbook playbook.yaml
   ```

3. **Access the Application**:
   - Frontend: http://localhost:30082/
   - Backend API: http://localhost:30083/api/

## Troubleshooting

1. **If you encounter permission issues**:
   - Run the terminal as Administrator on Windows
   - Ensure Docker is running

2. **If images are not found**:
   - Make sure you're in the correct directory when running the playbook
   - Verify that the Docker images were built successfully

3. **If services are not accessible**:
   - Check that all pods are running: `kubectl get pods`
   - Verify services: `kubectl get svc`
   - Check logs: `kubectl logs <pod-name>`

## Customization

You can customize the deployment by modifying:
- Database credentials in the Kubernetes manifest
- Port numbers in the services
- Resource limits for each deployment
- Number of replicas for each service

This deployment provides a scalable and maintainable way to run the QuizBuilder application on Kubernetes with automated provisioning through Ansible.