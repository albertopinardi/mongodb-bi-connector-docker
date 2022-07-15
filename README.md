# Mongodb BI Connector

This projects aim to provide a sensible and fairly configurable container image for your MongoDB BI Connector needs.

## Connection and Configuration

This image tackles enpoint specification (SSL or auth DB) directly whit URI connection string and Authentication with specific ENVs or externally sourced Configuration File. **Do not use both**

### Authentication

To leverage authentication directly without entering in detailed configuration with the Configuration File you can specify the MONGODB_USERNAME and MONGODB_PASSWORD Environment variables.

### Configuration

To fine configure your MongoDB BI Connector container installation you can specify a configuration file using the CONFIG_FILE_PATH to specify the full path where this file will be found or mounted.

## Some usage examples

Docker-compose file without authentication

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
```
