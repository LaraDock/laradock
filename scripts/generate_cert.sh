#!/bin/sh

cd "${BASH_SOURCE%/*}" || exit
cat > openssl.cnf <<-EOF
  [req]
  distinguished_name = req_distinguished_name
  x509_extensions = v3_req
  prompt = no
  [req_distinguished_name]
  C = DE
  ST = BE
  O = Kiron Open Higher Education
  CN = $1.app
  [v3_req]
  keyUsage = keyEncipherment, dataEncipherment
  extendedKeyUsage = serverAuth
  subjectAltName = @alt_names
  [alt_names]
  DNS.1 = *.$1.app
  DNS.2 = $1.app
EOF

openssl req \
  -new \
  -newkey rsa:4096 \
  -sha1 \
  -days 3650 \
  -nodes \
  -x509 \
  -keyout ../nginx/certs/$1.key \
  -out ../nginx/certs/$1.crt \
  -config openssl.cnf

rm openssl.cnf
