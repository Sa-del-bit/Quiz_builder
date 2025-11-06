@echo off
REM QuizBuilder Deployment Script for Windows

echo _quizBuilder Deployment Script_
echo ==============================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker is not installed. Please install Docker and try again.
    exit /b 1
)

REM Check if kubectl is installed
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo kubectl is not installed. Please install kubectl and try again.
    exit /b 1
)

REM Check if minikube is installed
minikube version >nul 2>&1
if %errorlevel% neq 0 (
    echo Minikube is not installed. Please install Minikube and try again.
    exit /b 1
)

echo All prerequisites are installed.

REM Start Minikube if not running
echo Checking Minikube status...
minikube status | findstr "Running" >nul
if %errorlevel% neq 0 (
    echo Starting Minikube...
    minikube start --driver=docker --memory=2000 --cpus=2
) else (
    echo Minikube is already running.
)

REM Build backend Docker image
echo Building backend Docker image...
cd backend
docker build -t quiz-backend:latest .
cd ..

REM Build frontend Docker image
echo Building frontend Docker image...
cd frontend
docker build -t quiz-frontend:latest .
cd ..

REM Load images into Minikube
echo Loading images into Minikube...
minikube image load quiz-backend:latest
minikube image load quiz-frontend:latest

REM Apply Kubernetes manifests
echo Applying Kubernetes manifests...
kubectl apply -f k8s/fullstackdeployment.yaml

echo Deployment process initiated!
echo Please wait for pods to be ready and then access the application at:
echo Frontend: http://localhost:30082/
echo Backend: http://localhost:30083/api/