# Configuration
echo $#
echo "Usage"
if [ $# -eq 0 ]
then
    echo "Usage"
    exit 1
fi

PLATO_WAR=/C/Users/scai/Dropbox/Plato/PlatoWebApp/target/PlatoWebApp.war

RESOURCES_ROOT_DIR=/C/Users/scai/Dropbox/javaWS/handwriting/src/main/resources

PRODUCTION_FILE=${RESOURCES_ROOT_DIR}/config/productions.txt
TERMINALS_JSON_FILE=${RESOURCES_ROOT_DIR}/config/terminals.json
TOKEN_ENGINE_SER_FILE_WHR0=/C/Users/scai/Dropbox/Plato/engines/token_engine.sdv.sz0_whr0_ns1.ser
TOKEN_ENGINE_SER_FILE_WHR1=/C/Users/scai/Dropbox/Plato/engines/token_engine.sdv.sz0_whr1_ns1.ser
STROKE_CURATOR_CONFIG_JSON_FILE=${RESOURCES_ROOT_DIR}/config/stroke_curator_config.json
PLAO_SECRETS_PROPERTIES_FILE=/C/Users/scai/Dropbox/Plato/secure/plato-secrets-dev.properties
PLATO_AWS_PROPERTIES_FILE=/C/Users/scai/Dropbox/Plato/secure/plato-aws.properties

PLATO_SERVER_DIR=/C/plato-server

cp -v ${PRODUCTION_FILE}       ${PLATO_SERVER_DIR}/token-set-parser/
cp -v ${TERMINALS_JSON_FILE}    ${PLATO_SERVER_DIR}/token-set-parser/
cp -v ${TOKEN_ENGINE_SER_FILE_WHR0} ${PLATO_SERVER_DIR}/token-engine/
cp -v ${TOKEN_ENGINE_SER_FILE_WHR1} ${PLATO_SERVER_DIR}/token-engine/
cp -v ${STROKE_CURATOR_CONFIG_JSON_FILE} ${PLATO_SERVER_DIR}/stroke-curator/
cp -v ${PLAO_SECRETS_PROPERTIES_FILE} ${PLATO_SERVER_DIR}/
cp -v ${PLATO_AWS_PROPERTIES_FILE} ${PLATO_SERVER_DIR}/
