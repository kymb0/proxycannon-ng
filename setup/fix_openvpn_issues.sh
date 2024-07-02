#!/bin/bash
# run as root

EASYRSA_DIR="/etc/openvpn/easy-rsa"
if [ -d "$EASYRSA_DIR" ]; then
    echo "$EASYRSA_DIR exists. Removing old directory."
    rm -rf "$EASYRSA_DIR"
fi

make-cadir "$EASYRSA_DIR"
cd "$EASYRSA_DIR"

# Initialize Easy-RSA
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-dh
./easyrsa build-server-full server nopass
./easyrsa build-client-full client01 nopass
./easyrsa gen-crl

# Generate tls-auth key
openvpn --genkey --secret "$EASYRSA_DIR/pki/private/ta.key"

# Copy necessary files to /etc/openvpn
cp pki/ca.crt /etc/openvpn/easy-rsa/pki/ca.crt
cp pki/issued/server.crt /etc/openvpn/easy-rsa/pki/issued/server.crt
cp pki/private/server.key /etc/openvpn/easy-rsa/pki/private/server.key
cp pki/dh.pem /etc/openvpn/easy-rsa/pki/dh.pem
cp pki/issued/client01.crt /etc/openvpn/easy-rsa/pki/issued/client01.crt
cp pki/private/client01.key /etc/openvpn/easy-rsa/pki/private/client01.key
cp pki/private/ta.key /etc/openvpn/easy-rsa/pki/private/ta.key
chown -R root:root /etc/openvpn/easy-rsa
chmod -R 600 /etc/openvpn/easy-rsa/pki
chown root:root /etc/openvpn/easy-rsa/pki/dh.pem
chmod 600 /etc/openvpn/easy-rsa/pki/dh.pem
chown -R root:root /etc/openvpn/easy-rsa
chmod -R 700 /etc/openvpn/easy-rsa
cp /etc/openvpn/easy-rsa/pki/private/* /etc/openvpn/easy-rsa/pki/
