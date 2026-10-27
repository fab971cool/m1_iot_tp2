#!/bin/bash
set -e
umask 077
cd "$(dirname "$0")"

# AC racine auto-signée : bien marquer qu'elle PEUT signer (contrainte critique)
openssl req -x509 -new -nodes -newkey rsa:2048 -keyout ca.key -out ca.crt \
-days 825 -subj "/CN=AC-IoT" -addext "basicConstraints=critical,CA:TRUE"


# Cert SERVEUR : CSR + signature par l'AC, avec un SAN (sans SAN, TLS refuse l'hôte)
# extensions à ajouter : subjectAltName = DNS:broker, DNS:localhost, IP:127.0.0.1
# extendedKeyUsage = serverAuth
openssl req -new -nodes -newkey rsa:2048 -keyout server.key -out server.csr -subj "/CN=broker"
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
-out server.crt -days 825 -extfile server.ext # SAN + EKU dans server.ext


# Cert CLIENT (un par objet) : CN = identité de l'objet, extendedKeyUsage = clientAuth
openssl req -new -nodes -newkey rsa:2048 -keyout capteur-bureau-101.key \
-out capteur-bureau-101.csr -subj "/CN=capteur-bureau-101"
openssl x509 -req -in capteur-bureau-101.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
-out capteur-bureau-101.crt -days 825 -extfile client.ext


# Cert CLIENT (un par objet) : CN = identité de l'objet, extendedKeyUsage = clientAuth
openssl req -new -nodes -newkey rsa:2048 -keyout capteur-bureau-201.key \
-out capteur-bureau-201.csr -subj "/CN=capteur-bureau-201"
openssl x509 -req -in capteur-bureau-201.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
-out capteur-bureau-201.crt -days 825 -extfile client.ext


# Cert CLIENT (un par objet) : CN = identité de l'objet, extendedKeyUsage = clientAuth
openssl req -new -nodes -newkey rsa:2048 -keyout capteur-bureau-301.key \
-out capteur-bureau-301.csr -subj "/CN=capteur-bureau-301"
openssl x509 -req -in capteur-bureau-301.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
-out capteur-bureau-301.crt -days 825 -extfile client.ext

# Cert CLIENT superviseur : CN = identité de l'objet, extendedKeyUsage = clientAuth
openssl req -new -nodes -newkey rsa:2048 -keyout superviseur.key \
-out superviseur.csr -subj "/CN=superviseur"
openssl x509 -req -in superviseur.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
-out superviseur.crt -days 825 -extfile client.ext


# Cert CLIENT intrus : CN = identité de l'objet, extendedKeyUsage = clientAuth
openssl req -new -nodes -newkey rsa:2048 -keyout intrus.key \
-out intrus.csr -subj "/CN=intrus"
openssl x509 -req -in intrus.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
-out intrus.crt -days 825 -extfile client.ext