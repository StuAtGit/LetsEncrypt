#!/bin/bash

./letsencrypt-auto certonly --standalone --email stu26code@gmail.com -d www.shareplaylearn.com -d shareplaylearn.com -d www.drunkscifi.com -d drunkscifi.com -d www.shareplaylearn.net -d shareplaylearn.net
echo "Done with lets encrypt, verify it created your cert.pem and privkey.pem in /etc/letsencrypt/live - it may have failed silently"
