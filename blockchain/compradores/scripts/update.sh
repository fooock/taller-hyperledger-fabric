ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/lonja1.com/orderers/orderer.lonja1.com/msp/tlscacerts/tlsca.lonja1.com-cert.pem
PEER0_COMPRADORES1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/comprador1.com/peers/peer0.comprador1.com/tls/ca.crt
PEER1_COMPRADORES1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/comprador1.com/peers/peer1.comprador1.com/tls/ca.crt

CORE_PEER_LOCALMSPID="Comprador1Msp"
CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_COMPRADORES1_CA
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/comprador1.com/users/Admin@comprador1.com/msp
CORE_PEER_ADDRESS=peer0.comprador1.com:11051
