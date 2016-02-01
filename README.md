## Creating a java keystore for tomcat using letsencrypt

### Run letsencrypt

Something like this:
./letsencrypt-auto certonly --standalone --email stu26code@gmail.com -d www.shareplaylearn.com -d shareplaylearn.com -d www.drunkscifi.com -d drunkscifi.com -d www.shareplaylearn.net -d shareplaylearn.net

### Stop, and reconsider nginx

So, you want to run tomcat with ssl do you? How about running tomcat in the clear, and fronting it with nginx, which doesn't require you to deal with the java keystore. You don't want to do that? You sure? The java keystore is an abomination, you know that? You like tomcat? OK. Keep in mind, though, that you and I are both wrong, and we should really move off running ssl in our tomcat. I already have nginx fronting it anyways....


### Create a java keystore
It should be understood that the java keytool program used create keystores is a complete piece of junk. It will give you errors like "NullPointerException, invalid input" if you don't give it a pkcs12 archive with a password.
Furthermore, it doesn't understand the PEM format that any sane program dealing with certificates would. In short, take 10 deep breathes before using it, and don't give up - it's probably the keytool doing something very, very, very stupid.

 - take your nice pem files from letsencrypt, and create a ugly, pkcs12 formatted file with your private and public entries:
     ```
      $>sudo openssl pkcs12 -export -in cert.pem -inkey privkey.pem -out [pkcs_filename].p12 -name [name]
     ```
   Keep in mind that you'll be asked to add a password to this temp file. This main seem stupid because you have the private key sitting in plaintext in the privkey.pem file right next to your output.
   However, remember - keytool is also stupid, and will NPE if you use an empty password.

 - take your pkcs12 file, and create a java keystore from it:
    ```
      $> sudo keytool -importkeystore -destkeystore [jks_filename].jks -srckeystore [pkcs_filename].p12 -srcstoretype PKCS12 -alias [name]
    ```
   It will then ask for your export password - this is what it will encrypt the jks with. Make this a good one!
   Then it will ask for the password used in the pkcs12 file above. Yes, keytool is stupid and asks for the import password after the export one, and fails instantly, right at the end, if something goes wrong here.

 - [optional, but likely] Hopefully, the only reason you got stuck doing this is your running some webapp in tomcat. Now configure your tomcat like so:
    
      ```
        <!-- sendfile disables compression, so we turn it off (trade cpu for bandwith) -->
        <Connector
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           port="443" maxThreads="200"
           compressableMimeType="text/html,text/xml,text/plain,text/javascript,text/css,text/js,text/json,application/javascript"
           compression="on"
           compressionMinSize="1024"
           useSendfile="false"
           scheme="https" secure="true" SSLEnabled="true"
           keystoreFile="/etc/[jks_filename].jks"
           keyAlias="[name]"
           keystorePass="[jks password]"
           keyPass="[jks password|pkcs password]"
           clientAuth="false"
           sslProtocol="TLS"
           sslEnabledProtocols="TLSv1.2"
        />
      ```
