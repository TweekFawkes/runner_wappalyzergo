#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

echo "START: Building wappalyzergo on Ubuntu 22.04 LTS"

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y ca-certificates build-essential git wget

# Check if Go is already installed
if ! command -v go &> /dev/null; then
    echo "Installing Go 1.22.6..."
    wget https://go.dev/dl/go1.22.6.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.22.6.linux-amd64.tar.gz
    rm go1.22.6.linux-amd64.tar.gz
    echo "Go installed successfully"
else
    echo "Go is already installed: $(go version)"
fi

# Set up Go environment
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export GO111MODULE=on
export CGO_ENABLED=1

# Create necessary directories
mkdir -p $GOPATH/src
mkdir -p $GOPATH/bin

# Install wappalyzergo
echo "Installing wappalyzergo..."
go install -v github.com/projectdiscovery/wappalyzergo/cmd/update-fingerprints@latest

if [ $? -eq 0 ]; then
    echo "wappalyzergo installed successfully at $GOPATH/bin"
    echo "Add the following to your ~/.bashrc or ~/.profile to make Go available permanently:"
    echo "export GOROOT=/usr/local/go"
    echo "export GOPATH=\$HOME/go"
    echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH"
else
    echo "Failed to install wappalyzergo"
    exit 1
fi

echo "END: Building wappalyzergo"