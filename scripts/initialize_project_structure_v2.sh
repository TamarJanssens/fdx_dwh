#!/bin/bash

# Function to create directory and empty file
create_dir_and_file() {
    mkdir -p "$1"
    touch "$1/$2"
}

# Ask for project name
read -p "Enter the project name: " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
    echo "No project name provided. Exiting."
    exit 1
fi

# Ask for the Python version to use
read -p "Enter the Python version to use (e.g., 3.11.7): " PYTHON_VERSION

# Check if the desired Python version is installed with pyenv
if pyenv versions | grep -q "$PYTHON_VERSION"; then
    echo "Python $PYTHON_VERSION is installed."
else
    echo "Installing Python $PYTHON_VERSION with pyenv..."
    pyenv install "$PYTHON_VERSION"
fi

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Set the local Python version with pyenv
pyenv local "$PYTHON_VERSION"

# Create a virtual environment using the pyenv Python version
python -m venv venv
echo "Virtual environment created with Python $PYTHON_VERSION"

# Activate the virtual environment and upgrade pip
source venv/bin/activate
pip install --upgrade pip

# Basic structure
mkdir -p .github/workflows airflow dbt docs notebooks src tests terraform .vscode scripts config

# copy the current script into the scripts dir
# This assumes the script is run from the project's parent directory
cp "../${BASH_SOURCE[0]}" "scripts/"

# Cloud platforms selection
echo "Select a cloud platform for deployment:"
echo "1) AWS"
echo "2) Google Cloud Platform (GCP)"
echo "3) Azure"
echo "4) None"
read -p "Enter your choice (1-4): " CLOUD_CHOICE
case $CLOUD_CHOICE in
    1) create_dir_and_file "config" "aws_config.cfg";;
    2) create_dir_and_file "config" "gcp_config.cfg";;
    3) create_dir_and_file "config" "azure_config.cfg";;
    4) ;;
    *) echo "Invalid choice"; exit 1;;
esac

# Check for big data technology
read -p "Include Big Data technology configuration? (y/n): " BIG_DATA
if [[ "$BIG_DATA" == [yY] ]]; then
    create_dir_and_file "config/big_data" "hadoop_config.cfg"
fi

# Check for Machine Learning Operations (MLOps)
read -p "Include MLOps tools like MLflow? (y/n): " MLOPS
if [[ "$MLOPS" == [yY] ]]; then
    create_dir_and_file "config" "mlflow_config.cfg"
fi

# Check for Advanced Data Processing and ETL Tools
read -p "Include Advanced Data Processing and ETL Tools like Apache Spark? (y/n): " ETL
if [[ "$ETL" == [yY] ]]; then
    create_dir_and_file "config" "spark_config.cfg"
fi
# Create main files
touch Dockerfile docker-compose.yml environment.yml requirements.txt README.md

# Create GitHub Action workflow
echo "name: CI/CD Pipeline
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: '$PYTHON_VERSION'
    - name: Install dependencies
      run: pip install -r requirements.txt
    - name: Run tests
      run: pytest tests/
" > .github/workflows/main.yml


# Create a simple README file
echo "# My Project
This is my data science/engineering project using Docker, GitHub Actions, and Terraform.

Give the script executable permissions: 
chmod +x create_project_structure.sh.
Run the script: 
./create_project_structure.sh.
" > README.md

# Create gitignore and dockerignore files
echo ".env
__pycache__/
*.pyc
.DS_Store
" > .gitignore

echo "*/__pycache__
*/.env
*.pyc
.DS_Store
" > .dockerignore

# Docker Compose content
DOCKER_COMPOSE_CONTENT="version: '3'
services:
  jupyter:
    image: jupyter/scipy-notebook
    ports:
      - '8888:8888'
    volumes:
      - .:/home/jovyan/work
  postgres:
    image: postgres:latest
    environment:
      POSTGRES_PASSWORD: example
    ports:
      - '5432:5432'
"

# Requirements.txt content for a basic data science project
REQUIREMENTS_CONTENT="numpy
pandas
scikit-learn
matplotlib
seaborn
jupyter
sqlalchemy
psycopg2
"

# Write content to docker-compose.yml
echo "$DOCKER_COMPOSE_CONTENT" > "docker-compose.yml"

# Write content to requirements.txt
echo "$REQUIREMENTS_CONTENT" > "requirements.txt"

echo "Docker Compose and requirements files updated successfully."

# Print completion message
echo "Project structure created successfully."
