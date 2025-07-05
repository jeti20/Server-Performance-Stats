#!/bin/bash

echo "========== Server Performance Stats =========="

# OS version
echo -e "\n--- OS Version ---"
cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2

# Uptime and Load Average
echo -e "\n--- Uptime & Load Average ---"
uptime

# Logged-in Users
echo -e "\n--- Logged-in Users ---"
who

# CPU Usage
echo -e "\n--- CPU Usage ---"
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d"." -f1)
CPU_USAGE=$((100 - CPU_IDLE))
echo "Total CPU Usage: $CPU_USAGE%"

# Memory Usage
echo -e "\n--- Memory Usage ---"
free -m | awk 'NR==2{printf "Used: %s MB / Total: %s MB (%.2f%%)\n", $3, $2, $3*100/$2}'

# Disk Usage
echo -e "\n--- Disk Usage (/ partition) ---"
df -h / | awk 'NR==2{printf "Used: %s / Total: %s (%s Used)\n", $3, $2, $5}'

# Top 5 processes by CPU usage
echo -e "\n--- Top 5 Processes by CPU Usage ---"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Top 5 processes by Memory usage
echo -e "\n--- Top 5 Processes by Memory Usage ---"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# Failed login attempts (last 24h)
echo -e "\n--- Failed Login Attempts (last 24h) ---"
journalctl _COMM=sshd --since "1 day ago" | grep "Failed password" | wc -l

echo -e "\n=============================================="
