#!/bin/bash
# make temporary copy of source code
cp -r ./socioboard-api ./docker/socioboard/
cp -r ./socioboard-web-php ./docker/socioboard/
cd docker

# set mongodb init details
cp ./init-mongo-template.js ./init-mongo.js
export $(grep -v '^#' .env | xargs)
# mongo_user=$(cat .env | grep 'MONGO_USER')
# IFS='=' read -a user_arr <<< $mongo_user
# mongo_user=$(echo ${user_arr[1]} | tr -d '"')
# mongo_pass=$(cat .env | grep 'MONGO_PASS')
# IFS='=' read -a pass_arr <<< $mongo_pass
# mongo_pass=$(echo ${pass_arr[1]} | tr -d '"')
# mongo_db=$(cat .env | grep 'MONGO_DB_NAME')
# IFS='=' read -a db_arr <<< $mongo_db
# mongo_db=$(echo ${db_arr[1]} | tr -d '"')
ex +%s/USER_REF/$MONGO_USER/g -scwq init-mongo.js
ex +%s/PASS_REF/$MONGO_PASS/g -scwq init-mongo.js
ex +%s/DB_REF/$MONGO_DB_NAME/g -scwq init-mongo.js
# sed -i -- "s/USER_REF/$MONGO_USER/g" init-mongo.js
# sed -i -- "s/PASS_REF/$MONGO_PASS/g" init-mongo.js
# sed -i -- "s/DB_REF/$MONGO_DB_NAME/g" init-mongo.js

# pull cached image
#docker pull localhost:5051/socioboard/socioboard:latest

# build without caching
docker build -t socioboard/socioboard ./socioboard

# build with caching
#docker build --cache-from localhost:5051/socioboard/socioboard:latest -t socioboard/socioboard ./socioboard
#docker rmi localhost:5051/socioboard/socioboard
#docker tag socioboard/socioboard:latest localhost:5051/socioboard/socioboard:latest
#docker push localhost:5051/socioboard/socioboard:latest

# create docker network
docker network create --subnet=172.16.32.0/16 --gateway=172.16.32.1 scb-net

# remove temporary copy of source code
rm -rf ./socioboard/socioboard-api ./socioboard/socioboard-web-php