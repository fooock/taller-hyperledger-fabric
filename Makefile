HF_VERSION := 1.4.0

crypto-lonja:
	rm -Rf ./blockchain/lonja/crypto-config
	cryptogen generate --config=./blockchain/lonja/crypto-config.yaml --output=./blockchain/lonja/crypto-config

channel-lonja:
	rm -rf ./blockchain/lonja/channel-artifacts && mkdir -p ./blockchain/lonja/channel-artifacts
	
	# Generamos el bloque genesis de administrador para el orderer
	FABRIC_CFG_PATH=./blockchain/lonja configtxgen -profile Lonja1OrdererGenesis \
	-channelID lonja-sys-channel \
	-outputBlock ./blockchain/lonja/channel-artifacts/genesis.block

	# Generamos el bloque genesis de los canales en los que participará la lonja
	FABRIC_CFG_PATH=./blockchain/lonja configtxgen -profile Lonja1PescadoresChannel \
	-outputCreateChannelTx ./blockchain/lonja/channel-artifacts/pescadoreschannel.tx \
	-channelID pescadoresch

	FABRIC_CFG_PATH=./blockchain/lonja configtxgen -profile Lonja1CompradoresChannel \
	-outputCreateChannelTx ./blockchain/lonja/channel-artifacts/compradoreschannel.tx \
	-channelID compradoresch

start-lonja:
	LONJA1_CA_PRIVATE_KEY=$(shell find ./blockchain/lonja/crypto-config/peerOrganizations/lonja1.com/ca/*_sk -printf "%f") \
	IMAGE_TAG=$(HF_VERSION) \
	docker-compose -f ./blockchain/lonja/ca.yaml -f ./blockchain/lonja/cli.yaml -f ./blockchain/lonja/couch.yaml up -d

stop-lonja:
	LONJA1_CA_PRIVATE_KEY=$(shell find ./blockchain/lonja/crypto-config/peerOrganizations/lonja1.com/ca/*_sk -printf "%f") \
	IMAGE_TAG=$(HF_VERSION) \
	docker-compose -f ./blockchain/lonja/ca.yaml -f ./blockchain/lonja/cli.yaml -f ./blockchain/lonja/couch.yaml down --volumes --remove-orphans

logs-lonja:
	LONJA1_CA_PRIVATE_KEY=$(shell find ./blockchain/lonja/crypto-config/peerOrganizations/lonja1.com/ca/*_sk -printf "%f") \
	IMAGE_TAG=$(HF_VERSION) \
	docker-compose -f ./blockchain/lonja/ca.yaml -f ./blockchain/lonja/cli.yaml -f ./blockchain/lonja/couch.yaml logs -f

