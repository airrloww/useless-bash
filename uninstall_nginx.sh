#!/bin/bash


# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

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

# Check if Nginx is installed
if [[ "$package_manager" == "apt" ]]; then
    if dpkg -l | grep -q nginx; then
        echo "Nginx is installed."
        echo "Uninstalling Nginx..."
        apt remove nginx -y
        apt purge nginx-common -y
        rm -rf /usr/share/nginx /usr/share/doc/nginx /usr/lib/nginx \
            /etc/ufw/applications.d/nginx /etc/default/nginx /etc/logrotate.d/nginx \
            /etc/init.d/nginx /var/log/nginx /var/lib/nginx
        apt autoremove -y
        apt update
        echo "Nginx has been removed."
    else
        echo "Nginx is not installed."
    fi
elif [[ "$package_manager" == "dnf" ]]; then
    if rpm -q nginx; then
        echo "Nginx is installed."
        echo "Uninstalling Nginx..."
        dnf remove nginx -y
        rm -rf /usr/share/nginx /usr/share/doc/nginx /usr/lib/nginx \
            /etc/logrotate.d/nginx /var/log/nginx /var/lib/nginx
        dnf autoremove -y
        dnf update
        echo "Nginx has been removed."
    else
        echo "Nginx is not installed."
    fi
else
    echo "Unsupported package manager: $package_manager"
    exit 1
fi

