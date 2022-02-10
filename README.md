# Vay

## Telecenter DevOps Engineer - Test Task (Custom Nginx)

## About The Project

The purpose of this project is to build a container in order to perform some of actions such as receiving custom headers at the moment, showing system's entropy and etc. Create a Docker image based on Ubuntu LTS which:

● Contains nginx compiled from official github nginx repository at commit 285a495d with the
following capabilities:

○ OpenSSL

○ File AIO

○ Threads support

○ HTTP v2

○ select() API

○ without poll() API

● Runs built nginx on port 10080 (HTTP) and 10443 (HTTPS) serves default page accessible from the
docker host at http(s)://let.me.play with following requirements:

○ HTTP response header "X-Vay-Entropy" showing the system's available entropy at that
moment

○ HTTP response header "X-Vay-Load" showing the system's load average at that moment

○ the default page must be stored in the docker host

○ the default page must contain:

■ the built nginx's version and compile-time options

■ system's load average after compiling nginx

■ only the human-readable form of the SSL certificate used to serve the page over
HTTPS

■ the system's available entropy after compiling nginx

■ the corresponding Dockerfile for the docker image

■ if possible: list of connected devices to the docker host (pci, usb)

■ if possible: list of kernel modules

This test task has been executed and done successfully on the Mint 20.

## Installation

Before to start please check that docker has been installed on your system.

```bash
# Redhat based distributions
yum repolist && yum install docker-ce docker-ce-cli containerd.io git -y
```

```bash
# Ubuntu distributions
sudo apt update && apt-get install docker-ce docker-ce-cli containerd.io git -y
```

# Getting Started
At first you should clone code to your desktop.

```bash
git clone https://github.com/ali-abaszadeh/Vay.git
```

## Certificates Structure
As you see in below our certificates structure has been shown. I have used self signed method to create certificate. You don't need to create a certificate again and you won't need to run "Optional" steps. So You can use these certificates for your test and go to "How can I run the project". If you want to create other certificates don't worry. you can create them but remember to you shoud change "let.me.play" with your new domain name. The commands are as follow:

```bash
 ./certificates
 --- ca/
     --- {ENV}ROOTCA.key
     --- {ENV}ROOTCA.pem
 --- certificates
     --- {DOMAINs}.crt
```

### ROOT CA (Optional)
```bash
ENV=test
openssl genrsa -des3 -out ${ENV}ROOTCA.key 2048
openssl req -x509 -new -nodes -subj "/C=GR/CN=Vay ${ENV} Root CA/O=Vay/OU=DevOps" -key ${ENV}ROOTCA.key -sha256 -days 1825 -out ${ENV}ROOTCA.pem
openssl x509 -in ${ENV}ROOTCA.pem -inform PEM -out ${ENV}ROOTCA.crt

root-key-pass: ublBcr9LM95j0GBhAQU5vQ2IIr3OPseX
```

### Install ROOT CA (Ubuntu) (Optional)

You can install CA on the your machine if you will need. The commands are as flows:

```bash
sudo mkdir /usr/share/ca-certificates/extra
sudo cp ${ENV}/ca/${ENV}ROOTCA.crt /usr/share/ca-certificates/extra/
sudo echo "extra/${ENV}ROOTCA.crt" >> /etc/ca-certificates.conf
sudo update-ca-certificates

# In the container cases after this step you have to restart docker service

systemctl restart docker
```

### DOMAIN CERT (Optional)

```bash
DOMAIN=let.me.play
openssl genrsa -out ${DOMAIN}.key 2048
openssl req -subj "/C=GR/CN=${DOMAIN}/O=Vay/OU=DevOps" -new -key ${DOMAIN}.key -out ${DOMAIN}.csr
cat <<EOF > ${DOMAIN}.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${DOMAIN}
EOF

openssl x509 -req -in ${DOMAIN}.csr -CA ca/${ENV}ROOTCA.pem -CAkey ca/${ENV}ROOTCA.key -CAcreateserial \
-out ${DOMAIN}.crt -days 825 -sha256 -extfile ${DOMAIN}.ext
```
 
### DOMAIN Cert chain (Optional)
```bash
cat ${DOMAIN}.key ${DOMAIN}.crt ca/${ENV}ROOTCA.crt > ${DOMAIN}.pem
```
 
### Check SSL Match keys (Optional)

You can check whether a certificate matches a private key, or a CSR matches a certificate on your own computer by using the OpenSSL commands are as follow:

```bash
openssl pkey -in privateKey.key -pubout -outform pem | sha256sum
openssl x509 -in certificate.crt -pubkey -noout -outform pem | sha256sum
openssl req -in CSR.csr -pubkey -noout -outform pem | sha256sum
```
 
## How can I run the project?

```bash
git clone https://github.com/ali-abaszadeh/Vay.git
```
 
### Run pre build script
```bash
chmod +x pre-build.sh
./pre-build.sh
```

 ### Build the nginx image and run it using build.sh automatically
```bash
chmod +x build.sh
./build.sh
```
 
### Check let.me.play on your browser 
```bash
echo "$YOUR_IP let.me.play" >> /etc/hosts
curl https://let.me.play:10443
curl http://let.me.play:10080
```
 
### Check LOAD_AVERAGE and SYSTEM_ENTROPY
```bash
curl --head  https://let.me.play:10443
```
 
### Restart Nginx

You will be able restart nginx using two below commands if you need to restart the nginx container
```bash
chmod +x nginx.sh
nginx-reset.sh
```


## License


## Contact

a.abaszadeh1363@gmail.com

Project Link: [https://github.com/ali-abaszadeh/Vay.git]
