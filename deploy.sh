#!/bin/bash

# QuizBuilder Deployment Script

echo "_quizBuilder Deployment Script_"
echo "=============================="

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Please install Docker and try again."
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null
then
    echo "kubectl is not installed. Please install kubectl and try again."
    exit 1
fi

# Check if minikube is installed
if ! command -v minikube &> /dev/null
then
    echo "Minikube is not installed. Please install Minikube and try again."
    exit 1
fi

echo "All prerequisites are installed."

# Start Minikube if not running
echo "Checking Minikube status..."
if ! minikube status | grep -q "Running"; then
    echo "Starting Minikube..."
    minikube start --driver=docker --memory=2000 --cpus=2
else
    echo "Minikube is already running."
fi

# Build backend Docker image
echo "Building backend Docker image..."
cd backend
docker build -t quiz-backend:latest .
cd ..

# Build frontend Docker image
echo "Building frontend Docker image..."
cd frontend
docker build -t quiz-frontend:latest .
cd ..

# Load images into Minikube
echo "Loading images into Minikube..."
minikube image load quiz-backend:latest
minikube image load quiz-frontend:latest

# Apply Kubernetes manifests
echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/fullstackdeployment.yaml

# Wait for pods to be ready
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod --all --timeout=300s

# Display services
echo "Services deployed:"
kubectl get svc

echo "Deployment completed!"
echo "Access the application at:"
echo "Frontend: http://localhost:30082/"
echo "Backend: http://localhost:30083/api/"