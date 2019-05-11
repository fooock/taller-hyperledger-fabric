echo "Install jq"
apt-get update && apt-get install jq

ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/lonja1.com/orderers/orderer.lonja1.com/msp/tlscacerts/tlsca.lonja1.com-cert.pem
PEER0_PESCADORES1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pescador1.com/peers/peer0.pescador1.com/tls/ca.crt
PEER1_PESCADORES1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pescador1.com/peers/peer1.pescador1.com/tls/ca.crt

CORE_PEER_LOCALMSPID="Pescador1Msp"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PESCADORES1_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/pescador1.com/users/Admin@pescador1.com/msp
CORE_PEER_ADDRESS=peer0.pescador1.com:9051
