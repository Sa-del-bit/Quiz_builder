#!/bin/bash

echo "Checking QuizBuilder Prerequisites..."
echo "====================================="

# Check Docker
if command -v docker &> /dev/null
then
    echo "✅ Docker: Installed"
    docker_version=$(docker --version)
    echo "   Version: $docker_version"
else
    echo "❌ Docker: Not found"
    echo "   Please install Docker: https://docs.docker.com/get-docker/"
fi

echo ""

# Check Docker Compose
if command -v docker-compose &> /dev/null
then
    echo "✅ Docker Compose: Installed"
    docker_compose_version=$(docker-compose --version)
    echo "   Version: $docker_compose_version"
else
    echo "❌ Docker Compose: Not found"
    echo "   Please install Docker Compose: https://docs.docker.com/compose/install/"
fi

echo ""

# Check kubectl
if command -v kubectl &> /dev/null
then
    echo "✅ kubectl: Installed"
    kubectl_version=$(kubectl version --client --short)
    echo "   Version: $kubectl_version"
else
    echo "❌ kubectl: Not found"
    echo "   Please install kubectl: https://kubernetes.io/docs/tasks/tools/"
fi

echo ""

# Check Minikube
if command -v minikube &> /dev/null
then
    echo "✅ Minikube: Installed"
    minikube_version=$(minikube version)
    echo "   Version: $minikube_version"
else
    echo "❌ Minikube: Not found"
    echo "   Please install Minikube: https://minikube.sigs.k8s.io/docs/start/"
fi

echo ""

# Check Ansible
if command -v ansible &> /dev/null
then
    echo "✅ Ansible: Installed"
    ansible_version=$(ansible --version | head -n 1)
    echo "   Version: $ansible_version"
else
    echo "❌ Ansible: Not found"
    echo "   Please install Ansible: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html"
fi

echo ""
echo "====================================="

# Summary
missing_tools=0

if ! command -v docker &> /dev/null; then
    missing_tools=$((missing_tools + 1))
fi

if ! command -v docker-compose &> /dev/null; then
    missing_tools=$((missing_tools + 1))
fi

if ! command -v kubectl &> /dev/null; then
    missing_tools=$((missing_tools + 1))
fi

if ! command -v minikube &> /dev/null; then
    missing_tools=$((missing_tools + 1))
fi

if ! command -v ansible &> /dev/null; then
    missing_tools=$((missing_tools + 1))
fi

if [ $missing_tools -eq 0 ]; then
    echo "🎉 All prerequisites are installed! You're ready to deploy QuizBuilder."
else
    echo "⚠️  $missing_tools tool(s) missing. Please install the missing tools before deploying."
fi