# Passbolt Helm Chart for Kubernets

* Prerequsites
* Generate GPG key
* Install MySQL database manually (optional)
* Install Passbolt (optionally with MySQL database)

# Prerequisites

Standard SSL certificate for website.

*Optionally* existing GPG key pair to use with Passbolt deployment.

# Generate GPG key

Before install Passbolt it is required to have public/private GPG key pair

**Linux**

Folder gpg-server-key

* Copy *gpg-server-key.conf.samepl* -> *gpg-server-key.conf*
* Edit *gpg-server-key.conf* and fill in values
    * *Name-Email* - email address (admin/tech support person)
    * *Name-Real* - full name (admin/tech support person)
    * *Name-Comment* (optional) - some comment
    * *Passphrase* - passphrase to protect private key
* Run *1.generate-key.sh* - it will generate new RSA4096 key pair and put into local GPG key store (see command output)
* Run *2.list-keys.sh* - see all keys list in your local GPG store, find your new generated key by email/name. Find line starting with [ sec ], find string similar to rsa4096/XXXXXXXXXX, take XXXXXXXXXX value - copy to clipboard
* Run *3.export-key.sh XXXXXXXXXX* - this will export newly generated key into 2 files: *serverkey.asc* & *serverkey_private.asc*

**Windows**

Download GPG for windows from https://gnupg.org/download/
1. Look "GnuPG binary releases" section. 
1. Choose "Simple installer for the current GnuPG"
1. Download and install 
1. Goto Windows settings and update PATH system variable with GPG path, default is - "C:\Program Files (x86)\gnupg\bin"

Goto folder *gpg-server-key/windows*

* Copy *gpg-server-key.conf.samepl* -> *gpg-server-key.conf*
* Edit *gpg-server-key.conf* and fill in values
    * *Name-Email* - email address (admin/tech support person)
    * *Name-Real* - full name (admin/tech support person)
    * *Name-Comment* (optional) - some comment
    * *Passphrase* - passphrase to protect private key
* Run *1.generate-key.bat* - it will generate new RSA4096 key pair and put into local GPG key store (see command output)
* Run *2.list-keys.bat* - see all keys list in your local GPG store, find your new generated key by email/name. Find line starting with [ sec ], find string similar to rsa4096/XXXXXXXXXX, take XXXXXXXXXX value - copy to clipboard
* Run *3.export-key.bat XXXXXXXXXX* - this will export newly generated key into 2 files: *serverkey.asc* & *serverkey_private.asc*

# Install MySQL database manually

This section only applicable if you by some good reason:
* Use existing MySQL database server and 200% sure it is very safe and secure to use with Passbolt 
* Like to setup manually secure MySQL server environment

It can be used stable Helm Chart for MariaDB - https://github.com/helm/charts/tree/master/stable/mariadb

# Install Passbolt

**Configurable parameters**

| Parameter | Description | Requried | Default |
|-|-|-|:-:|
| **Passbolt deployment parameters** 
| *Passbolt common settings*
| `passbolt.config.serverName` | FQDN for passbolt deployment (will be use in Ingress) | * | `null` |
| `passbolt.config.salt` | 64 chars long unique string of printable chars | * | `null` |
| `passbolt.config.gpgFingerprint` | fingerprint of GPG key | * | `null` |
| *Passbolt database connection settings* - only required when existing database used
| `passbolt.dbHost` | MySQL database server IP or FQDN | | `null` |
| `passbolt.dbPort` | MySQL database port | | `3306` |
| `passbolt.dbDatabase` | MySQL database name | | `null` |
| `passbolt.dbUsername` | MySQL database username | | `null` |
| `passbolt.dbPassword` | MySQL database password | | `null` |
| *Passbolt email settings*
| `passbolt.config.email.from` | From address to emails sent by passbolt | * | `null` |
| `passbolt.config.email.name` | Fullname for From address | | `"Passbolt"` |
| `passbolt.config.email.replyTo` | ReplyTo address for email | * | `null` |
| `passbolt.config.email.smtp.enabled` | On/Off SMTP settings | | `true` |
| `passbolt.config.email.smtp.address` | SMTP server IP or FQDN | * | `smtp.domain.com` |
| `passbolt.config.email.smtp.port` | TCP port for SMTP server | | `587` |
| `passbolt.config.email.smtp.domain` | Domain name for SMTP | * | `domain.com` |
| `passbolt.config.email.smtp.username` | Username for SMTP server | * | `username` |
| `passbolt.config.email.smtp.password` | Password for SMTP server | * | `not-a-password` |
| `passbolt.config.email.smtp.tls` | On/Off SSL/TLS connection for SMTP | | `true` |
| `passbolt.tls.enable` | On/Off SSL for Passbolt, when `true` - there must be *certificate.crt* & *certificate.key* under *certs* directory | | `true` |
| `passbolt.ingress.enable` | On/Off Ingress for Passbolt | | `true` |
| `passbolt.ingress.tlsSecretName` | Name of k8s secret with *tls.crt* & *tls.key* files inside - valid SSL certificate for web site | | `null` |
| `passbolt.ingress.letsEncrypt.enabled` | On/Off use Let's Encrypt auto generated SSL certificate for Ingress, enabling this options suppose your Kubernets has configured Ingress with Let's Ecrypt support | | `true` |
| *Passbolt resources*
| `passbolt.resources.requests.memory` | Min memory for pod | | `256Mi` |
| `passbolt.resources.requests.cpu` | Min CPU for pod | `300m` |
| `passbolt.resources.limits.memory` | Max memory for pod | | `512Mi` |
| `passbolt.resources.limits.cpu` | Max CPU for pod | | `500m` |
| **Database deployment parameters**
| *Database settings* - allow setup own MySQL deployment dedicated for this passbolt installation
| `database.enabled` | On/Off MySQL deployment | | `true` |
| `database.image.repository` | Docker image url for MySQL database | | `bitnami/mariadb` |
| `database.persistence.enabled` | On/Off persistent storage for DB | | `true` |
| `database.persistence.size` | PV size | | `1Gi` |
| `database.persistence.accessMode` | K8s access mode for PV | | `ReadWriteOnce` |
| `database.persistence.storageClass` | Storage class for auto provisioned PVC, supposed your k8s setup auto storage provisioning | | `null` |
| `database.persistence.existingClaim` | PVC name | | `null` |
| *Database auth settings* - by default random user, password and root password will be used, see mariadb-secret.yaml. It is possible to specify exact values by reason
| `database.user` | Username for MySQL deployment | | `null` |
| `database.password` | Passowrd for MySQL deployment | | `null` |
| `database.rootPassword` | root' user password for MySQL deployment | | `null` |
| *Passbolt resources*
| `database.resources.requests.memory` | Min memory for pod | | `256Mi` |
| `database.resources.requests.cpu` | Min CPU for pod | `100m` |
| `database.resources.limits.memory` | Max memory for pod | | `512Mi` |
| `database.resources.limits.cpu` | Max CPU for pod | | `500m` |


**Installation**

Copy SSL certificate key and crt files into *certs* directory *certificate.key* & *certificate.crt* names

Copy GPG public and private key into *gpg* directory with *serverkey.asc* & *serverkey_private.asc* names

**Using repo package**

Add helm repo
```
helm repo add passbolt https://actonica.github.io/passbolt.k8s
helm repo update
```

Edit values.yaml and set required values or use command line parameters, e.g. `--set passbolt.config.serverName=passbolt.domain.com` to install chart

```
helm install passbolt.k8s/passbolt --name=my-passbolt-release --set passbolt.config.serverName=passbolt.domain.com
```

**Using source codes**

```
git clone https://github.com/actonica/passbolt.k8s
helm install ./passbolt.k8s --name=my-passbolt-release --set passbolt.config.serverName=passbolt.domain.com
```