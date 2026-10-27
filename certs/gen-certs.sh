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
openssl req -new -nodes -newkey rsa:2048 -keyout capteur-salon-01.key \
-out capteur-salon-01.csr -subj "/CN=capteur-salon-01"

openssl x509 -req -in capteur-salon-01.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
-out capteur-salon-01.crt -days 825 -extfile client.ext