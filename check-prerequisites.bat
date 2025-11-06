@echo off
setlocal enabledelayedexpansion

echo Checking QuizBuilder Prerequisites...
echo =====================================

set missing_tools=0

REM Check Docker
docker --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Docker: Installed
    for /f "tokens=*" %%i in ('docker --version') do set docker_version=%%i
    echo    Version: %docker_version%
) else (
    echo ❌ Docker: Not found
    echo    Please install Docker: https://docs.docker.com/get-docker/
    set /a missing_tools+=1
)

echo.

REM Check kubectl
kubectl version --client >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ kubectl: Installed
    for /f "tokens=*" %%i in ('kubectl version --client --short') do set kubectl_version=%%i
    echo    Version: %kubectl_version%
) else (
    echo ❌ kubectl: Not found
    echo    Please install kubectl: https://kubernetes.io/docs/tasks/tools/
    set /a missing_tools+=1
)

echo.

REM Check Minikube
minikube version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Minikube: Installed
    for /f "tokens=*" %%i in ('minikube version') do set minikube_version=%%i
    echo    Version: %minikube_version%
) else (
    echo ❌ Minikube: Not found
    echo    Please install Minikube: https://minikube.sigs.k8s.io/docs/start/
    set /a missing_tools+=1
)

echo.

REM Check Ansible
ansible --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Ansible: Installed
    for /f "tokens=*" %%i in ('ansible --version ^| findstr /n "^" ^| findstr "^1:"') do set ansible_version=%%i
    echo    Version: %ansible_version%
) else (
    echo ❌ Ansible: Not found
    echo    Please install Ansible: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
    set /a missing_tools+=1
)

echo.
echo =====================================

if %missing_tools% equ 0 (
    echo 🎉 All prerequisites are installed! You're ready to deploy QuizBuilder.
) else (
    echo ⚠️  %missing_tools% tool(s) missing. Please install the missing tools before deploying.
)