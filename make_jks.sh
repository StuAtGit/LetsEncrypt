#!/bin/bash

echo "Creating pkcs12 containing public and private key - you must enter an export password because keytools is a terrible program and will NPE"
sudo openssl pkcs12 -export -in cert.pem -inkey privkey.pem -out shareplaylearn.p12 -name shareplaylearn
echo "Importing pkcs12 into a java keystore"
sudo keytool -importkeystore -destkeystore shareplaylearn.jks -srckeystore shareplaylearn.p12 -srcstoretype PKCS12 -alias shareplaylearn
