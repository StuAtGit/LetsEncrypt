#!/bin/bash

sudo keytool --importcert -file fullchain.pem -keystore /usr/lib/jvm/default-java/jre/lib/security/cacerts -v -alias shareplaylearn_chain
