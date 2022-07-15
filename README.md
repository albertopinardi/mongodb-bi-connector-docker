# Mongodb BI Connector

This projects aim to provide a sensible and fairly configurable container image for your MongoDB BI Connector needs.

## Connection and Configuration

This image tackles enpoint specification (SSL or auth DB) directly whit URI connection string and Authentication with specific ENVs or externally sourced Configuration File. **Do not use both**

### Authentication

To leverage authentication directly without entering in detailed configuration with the Configuration File you can specify the MONGODB_USERNAME and MONGODB_PASSWORD Environment variables.

### Configuration

To fine configure your MongoDB BI Connector container installation you can specify a configuration file using the CONFIG_FILE_PATH to specify the full path where this file will be found or mounted.

## Some usage examples

Docker-compose file without authentication nor special configuration

```docker
version: "3"
services:
  mongodb:
    image: mongo:bionic
  
  mongodb-bi-connector:
    image: albertopinardi/mongodb-bi-connector:latest
    environment:
      MONGODB_URI: "mongodb://mongodb:27017/?connect=direct"
```

Docker-compose file with authentication

```docker
version: "3"
services:
  mongodb:
    image: mongo:bionic
  
  mongodb-bi-connector:
    image: albertomxm/mongodb-bi-connector:latest
    environment:
      MONGODB_URI: "mongodb://mongodb:27017/?connect=direct"
      MONGODB_USERNAME: testuser
      MONGODB_PASSWORD: testpassword
      MONGODB_AUTHDB: admin
```

Kubernetes with config on ConfigMap

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mongodb-bi-connector
spec:
  containers:
  - name: mongodb-bi-connector
    image: albertomxm/mongodb-bi-connector:latest
    env:
      - name: CONFIG_FILE_PATH
        value: /etc/mongosqld.conf
    ports:
      - containerPort: 3307
    volumeMounts:
      - mountPath: /etc/mongosqld.conf
        name: configuration
        subPath: mongosqld.conf
  volumes:
    - name: configuration
      configMap:
        name: mongosqld-conf
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: mongosqld-conf
data:
  mongosqld.conf: |
    systemLog:
      path: /var/log/mongosqld/mongosqld.log

    security:
      enabled: true

    mongodb:
      net:
        uri: "mongodb://mongodb:27017/?connect=direct"

    net:
      bindIp: 0.0.0.0
      port: 3307
```
