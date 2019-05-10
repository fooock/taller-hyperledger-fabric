
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/lonja1.com/orderers/orderer.lonja1.com/msp/tlscacerts/tlsca.lonja1.com-cert.pem
PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/lonja1.com/peers/peer0.lonja1.com/tls/ca.crt
PEER1_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/lonja1.com/peers/peer1.lonja1.com/tls/ca.crt

CORE_PEER_LOCALMSPID="Lonja1Msp"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/lonja1.com/users/Admin@lonja1.com/msp
CORE_PEER_ADDRESS=peer0.lonja1.com:7051

# Creamos el canal de los pescadores
echo "==== Creando canal para pescadores ===="
peer channel create -o orderer.lonja1.com:7050 \
-c pescadoresch \
-f ./../channel-artifacts/pescadoreschannel.tx \
--tls true \
--cafile $ORDERER_CA
echo "==== ¿Canal de pescadores creado? '$?' ===="

# Creamos el canal de los pescadores
echo "==== Creando canal para compradores ===="
peer channel create -o orderer.lonja1.com:7050 \
-c compradoresch \
-f ./../channel-artifacts/compradoreschannel.tx \
--tls true \
--cafile $ORDERER_CA
echo "==== ¿Canal de compradores creado? '$?' ===="

# Hacemos el join de los peers en los 2 canales, 
# primero del peer 0 y despues del peer 1
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
CORE_PEER_ADDRESS=peer0.lonja1.com:7051
echo "==== Preparado para hacer join ($CORE_PEER_ADDRESS) ===="
peer channel join -b pescadoresch.block && peer channel join -b compradoresch.block
echo "==== ¿$CORE_PEER_ADDRESS unido al canal de pescadores/compradores? $? ===="

CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
CORE_PEER_ADDRESS=peer1.lonja1.com:8051
echo "==== Preparado para hacer join ($CORE_PEER_ADDRESS) ===="
peer channel join -b pescadoresch.block && peer channel join -b compradoresch.block
echo "==== ¿$CORE_PEER_ADDRESS unido al canal de compradores/pescadores? $? ===="
