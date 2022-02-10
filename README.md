# Vay

## Telecenter DevOps Engineer - Test Task (Custom Nginx)

## About The Project

Using this python script you can automate dnsdist configuration regarding to admin values. This script can be integrated with Ansible for fasinating dns configuration. DNSDIST is a important service for security in DNS DDOS atacctions So you will be needed to be comfortable with changing your config in DDOS attactions if you are working with POWERDNS as a your DNS services.

## Installation

```bash
yum repolist && yum install python-dotenv -y
```

### Getting Started

At first you should clone code to your desktop and change variables in .env file based on your environment.

```bash
# Redhat based distributions
yum repolist && yum install git -y 

# Debian based distributions
apt update && apt install git

git clone https://github.com/ali-abaszadeh/DNSDIST-Settings.git
```

### Structure
 ./certificates
 --- ca/
     --- {ENV}ROOTCA.key
     --- {ENV}ROOTCA.pem
 --- certificates
     --- {DOMAINs}.crt

### ROOT CA
ENV=test
openssl genrsa -des3 -out ${ENV}ROOTCA.key 2048
openssl req -x509 -new -nodes -subj "/C=GR/CN=Vay ${ENV} Root CA/O=Vay/OU=DevOps" -key ${ENV}ROOTCA.key -sha256 -days 1825 -out ${ENV}ROOTCA.pem
openssl x509 -in ${ENV}ROOTCA.pem -inform PEM -out ${ENV}ROOTCA.crt

root-key-pass: ublBcr9LM95j0GBhAQU5vQ2IIr3OPseX

### Install ROOT CA (Ubuntu)
sudo mkdir /usr/share/ca-certificates/extra
sudo cp ${ENV}/ca/${ENV}ROOTCA.crt /usr/share/ca-certificates/extra/
sudo echo "extra/${ENV}ROOTCA.crt" >> /etc/ca-certificates.conf
sudo update-ca-certificates

In the container cases after this step you have to restart docker service
systemctl restart docker


### DOMAIN CERT
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

### DOMAIN Cert chain
cat ${DOMAIN}.key ${DOMAIN}.crt ca/${ENV}ROOTCA.crt > ${DOMAIN}.pem

### check SSL Match keys

You can check whether a certificate matches a private key, or a CSR matches a certificate on your own computer by using the OpenSSL commands below:

openssl pkey -in privateKey.key -pubout -outform pem | sha256sum
openssl x509 -in certificate.crt -pubkey -noout -outform pem | sha256sum
openssl req -in CSR.csr -pubkey -noout -outform pem | sha256sum

## How can I run the project?
  
git clone ali-abaszadeh

### Run pre build script

 chmod +x pre-build.sh
./pre-build.sh

### Build the nginx image and run it using build.sh automatically

chmod +x build.sh
./build.sh

### Check let.me.play on your browser 

echo "$YOUR_IP let.me.play" >> /etc/hosts
curl https://let.me.play:10443
curl http://let.me.play:10080

### Check LOAD_AVARAGE and SYSTEM_ENTROPY
curl --head  https://let.me.play:10443

### Restart Nginx

You will be able restart nginx using two below commands \
if you need to restart the nginx container

chmod +x nginx.sh
nginx-reset.sh


## Usage

This function has been developed to automate your dnsdist settings in production environents. DNSDIST is a one of the POWEDNS products which is using to handeling and managing dns requests. The dnsdist is a one of the kind of Loadbalancer for balancing DNS traffic between Cache or Recursor servers.


## License


## Contact

a.abaszadeh1363@gmail.com

Project Link: [https://github.com/ali-abaszadeh/Vay.git]
