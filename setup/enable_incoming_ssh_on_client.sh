#!/bin/bash
#grab ur ip with curl ifconfig.me
# Variables
LOCAL_IP="<your_local_ip>"

# Update OpenVPN client configuration
sudo sed -i "/^route /d" /etc/openvpn/proxycannon-client.conf
echo "route $LOCAL_IP 255.255.255.255 net_gateway" | sudo tee -a /etc/openvpn/proxycannon-client.conf

# Ensure iptables is set to allow traffic from LOCAL_IP
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -s $LOCAL_IP -p tcp --dport 22 -j ACCEPT

# Save iptables rules to persist after reboot
sudo sh -c "iptables-save > /etc/iptables/rules.v4"

# Restart OpenVPN client
sudo systemctl restart openvpn@client

echo "Client configuration complete."
