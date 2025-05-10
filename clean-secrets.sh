#!/bin/bash

# Create a clean version of the Dockerfile
cat > clean-dockerfile.txt << 'EOF'
FROM jenkins/jenkins:lts-jdk21
USER root

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && wget https://services.gradle.org/distributions/gradle-7.5.1-bin.zip -P /tmp \
    && unzip /tmp/gradle-7.5.1-bin.zip -d /opt \
    && ln -s /opt/gradle-7.5.1/bin/gradle /usr/bin/gradle

RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    curl \
    sudo && \
    curl -fsSL https://get.docker.com -o install-docker.sh && \
    sudo sh install-docker.sh && \
    sudo usermod -a -G docker jenkins

EXPOSE 8080

# Note: Credentials should be stored securely in Jenkins credentials
# and not hardcoded in Dockerfiles or other source files
EOF

# Function to replace the file content
replace_file() {
    if [ -f "$1" ]; then
        cat clean-dockerfile.txt > "$1"
        echo "Cleaned $1"
    else
        echo "File $1 not found"
    fi
}

# Replace the file in the current working tree
replace_file "cicd/ci/Dockerfile"

echo "Dockerfile cleaned"
