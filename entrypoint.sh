#!/bin/bash

if [[ -z $CONFIG_FILE_PATH && -z $MONGODB_USERNAME && -z $MONGODB_PASSWORD && -z $MONGODB_AUTHDB ]]; then
    echo "CONFIG_FILE_PATH is not set continueing with default value"
    echo "MONGODB_USERNAME or MONGODB_PASSWORD is not set either, thus continueing with default value"
    exec mongosqld --mongo-uri ${MONGODB_URI} --logPath /var/log/mongosqld/mongosqld.log
elif [[ -n $MONGODB_USERNAME || -n $MONGODB_PASSWORD || -n $MONGODB_AUTHDB ]]; then
    echo "MONGODB_USERNAME or MONGODB_PASSWORD is set continueing with authentication"
    exec mongosqld --logPath /var/log/mongosqld/mongosqld.log --auth --mongo-uri ${MONGODB_URI} --mongo-username ${MONGODB_USERNAME} --mongo-password ${MONGODB_PASSWORD} --mongo-authenticationSource ${MONGODB_AUTHDB:-admin}
elif [[ -n $CONFIG_FILE_PATH ]]; then
    echo "CONFIG_FILE_PATH is set to $CONFIG_FILE_PATH"
    echo "Launcing monogosqld using the configfile provided"
    exec mongosqld --config ${CONFIG_FILE_PATH}
fi

echo "Logs will be available at /var/log/mongosqld/mongosqld.log"

while true; do
    sleep 60
done