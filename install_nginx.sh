#!/bin/bash

# Determine the package manager
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
        package_manager="apt"
    elif [[ "$ID" == "almalinux" || "$ID" == "rhel" ]]; then
        package_manager="dnf"
    else
        echo "Unsupported operating system: $ID"
        exit 1
    fi
else
    echo "Unable to determine the operating system."
    exit 1
fi

# Check if the package is installed, if not, install it
if $package_manager list installed | grep -q nginx; then
    echo "nginx is already installed."
else
    echo "nginx is not installed. Installing it now..."
    sudo $package_manager update
    sudo $package_manager install nginx -y
    echo "nginx has been successfully installed."
fi
