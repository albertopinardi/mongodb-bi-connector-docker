# This ARG is used to select the version of debian but it cannot be used to select the right version of the BI connector package.
ARG CODENAME=buster
# note: rsyslog & curl (openssl,etc) needed as dependencies too
FROM debian:${CODENAME}
RUN apt-get update
RUN apt-get install -y rsyslog curl

# Download BI Connector to /mongosqld
WORKDIR /tmp
# This ARG provides a easy override for the connector version.
ARG VERSION=v2.14.4
# This ARG is used to select the bucket where the BI connector package is stored.
ARG BI_CONNECTOR_URL=https://info-mongodb-com.s3.amazonaws.com/mongodb-bi/v2/
# This ARG is used to select the version of the BI connector package.
ARG BI_CONNECTOR_URI="mongodb-bi-linux-x86_64-debian10-${VERSION}.tgz"
RUN curl "${BI_CONNECTOR_URL}${BI_CONNECTOR_URI}"  -s -o bi-connector.tgz 
RUN tar -xvzf bi-connector.tgz && rm bi-connector.tgz && \
    mv /tmp/${BI_CONNECTOR_URI%.tgz}/bin/* /usr/local/bin/. && \
    rm -rf /tmp/${BI_CONNECTOR_URI%.tgz}

# Setup default environment variables
ENV MONGODB_URI="mongodb://mongodb:27017/?connect=direct"

COPY entrypoint.sh /entrypoint.sh

# note: we need to use sh -c "command" to make rsyslog running as deamon too
RUN service rsyslog restart && chmod 744 /entrypoint.sh && mkdir -p /var/log/mongosqld
CMD [ "/entrypoint.sh" ]