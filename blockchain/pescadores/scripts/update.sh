ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/lonja1.com/orderers/orderer.lonja1.com/msp/tlscacerts/tlsca.lonja1.com-cert.pem
PEER0_PESCADORES1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pescador1.com/peers/peer0.pescador1.com/tls/ca.crt
PEER1_PESCADORES1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pescador1.com/peers/peer1.pescador1.com/tls/ca.crt

CORE_PEER_LOCALMSPID="Pescador1Msp"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PESCADORES1_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pescador1.com/users/Admin@pescador1.com/msp
CORE_PEER_ADDRESS=peer0.pescador1.com:9051

# Vamos a actualizar la configuracion del canal percadoresch
echo "==== Preparado para obtener la configuracion del canal pescadoresch... ===="
peer channel fetch config pescadores_block.pb \
-o orderer.lonja1.com:7050 \
-c pescadoresch \
--tls true \
--cafile $ORDERER_CA
echo "==== ¿Finaliza con exito? $?"

echo "==== Decodificar configuracion de bloque a formato JSON ===="
configtxlator proto_decode \
--input pescadores_block.pb \
--type common.Block | jq .data.data[0].payload.data.config > pescadores_config.json
echo "==== ¿Se ha escrito la configuracion en pescadores_config.json? $? ===="

echo "==== Preparado para modificar la configuracion para añadir la nueva configuracion ===="
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Pescador1Msp":.[1]}}}}}' \
pescadores_config.json ./blockchain/pescadores/channel-artifacts/pescador1.json > pescadores_config_mod.json

configtxlator proto_encode --input pescadores_config.json --type common.Config >original_config.pb
configtxlator proto_encode --input pescadores_config_mod.json --type common.Config >modified_config.pb
configtxlator compute_update --channel_id pescadoresch --original original_config.pb --updated modified_config.pb >config_update.pb
configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate >config_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"pescadoresch", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json
configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope >pescadores_update_env.pb
echo "==== ¿Se ha creado la configuracion con la nueva organizacion? $? ===="

echo "==== Firmar configuracion con peer ===="
peer channel signconfigtx -f pescadores_update_env.pb
echo "==== ¿Firmado finalizado con exito? $?"

echo "==== Actualizar canal ===="
peer channel update \
-f pescadores_update_env.pb \
-c pescadoresch \
-o orderer.lonja1.com:7050 \
--tls true \
--cafile ${ORDERER_CA}
echo "==== ¿Canal actualizado? $?"
