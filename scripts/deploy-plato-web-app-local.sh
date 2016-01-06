#!/bin/bash

# Configuration
if [ $# -ne 2 ]
then
    echo "Usage <RESOURCE_ROOT> <PLATO_ASSET_ROOT>"
    echo "      E.g., ./deploy-plato-web-app-local.sh /home/shanqing/plato/math-handwriting-lib/src/main/resources /opt/plato-server"
    exit 1
fi

RESOURCES_ROOT=$1
echo RESOURCES_ROOT = "${RESOURCES_ROOT}"
PLATO_ASSET_ROOT=$2
echo PLATO_ASSEST_ROOT = "${PLATO_ASSET_ROOT}"
echo

PRODUCTION_FILE=${RESOURCES_ROOT}/config/productions.txt
TERMINALS_JSON_FILE=${RESOURCES_ROOT}/config/terminals.json
#TOKEN_ENGINE_SER_FILE_WHR0=token_engine.sdv.sz0_whr0_ns1.ser
TOKEN_ENGINE_SER_FILE_WHR1=${RESOURCES_ROOT}/token_engine/token_engine.sdv.sz0_whr1_ns1.ser
STROKE_CURATOR_CONFIG_JSON_FILE=${RESOURCES_ROOT}/config/stroke_curator_config.json

mkdir -p ${PLATO_ASSET_ROOT}/token-set-parser &&
mkdir -p ${PLATO_ASSET_ROOT}/token-engine &&
mkdir -p ${PLATO_ASSET_ROOT}/stroke-curator &&

cp -v ${PRODUCTION_FILE} ${PLATO_ASSET_ROOT}/token-set-parser/ &&
cp -v ${TERMINALS_JSON_FILE} ${PLATO_ASSET_ROOT}/token-set-parser/ &&
#cp -v ${TOKEN_ENGINE_SER_FILE_WHR0} ${PLATO_ASSET_ROOT}/token-engine/ &&
cp -v ${TOKEN_ENGINE_SER_FILE_WHR1} ${PLATO_ASSET_ROOT}/token-engine/ &&
cp -v ${STROKE_CURATOR_CONFIG_JSON_FILE} ${PLATO_ASSET_ROOT}/stroke-curator/ &&
#cp -v ${PLAO_SECRETS_PROPERTIES_FILE} ${PLATO_ASSET_ROOT}/ &&
#cp -v ${PLATO_AWS_PROPERTIES_FILE} ${PLATO_ASSET_ROOT}/ &&

echo
echo "DONE"
echo "** IMPORTANT **: Do not forget to copy plato-secrets-dev.properties and plato-aws.properties to ${PLATO_ASSET_ROOT}"
