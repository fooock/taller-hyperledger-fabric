# Blockchain

El primer paso para desplegar la red blockchain basada en Hyperledger Fabric será decidir quien será, en un principio,
el administrador de la red. Para este caso, el administrador de la red será la propia lonja, por lo que será la primera
organización que desplegaremos.

La lonja creará dos canales:

* Un canal dedicado al intercambio de información entre los pescadores y la propia lonja. Las transacciones
en este canal serán confidenciales, y solo los actores que pertenezcan a este canal podrán verlas. El canal
se llamará `pescadoresch`.

* Un canal dedicado al intercambio de información de compra, entr los actores lonja y compradores. La información 
de este canal será confidencial, y los pescadores no podrán ver las transacciones que se realicen aquí.

# Iniciar la organización Lonja1

Lo primero que tendremos que hacer será crear el material criptografico que usarán los miembros que pertenezcan a 
la organización. Ejecutaremos el comando:

```bash
$ make crypto-lonja
```

Cuando este comando finalice, necesitaremos crear el bloque genesis que usará el orderer para inicializar la red,
y también crearemos los canales en los que esta organización realize operaciones:

```bash
$ make channel-lonja
```

Cuando este proceso termine, podremos iniciar los contenedores docker para iniciar los componentes de la organización:


```bash
$ make start-lonja
```
> En caso de querer parar los componentes de esta organización y eliminar los volumenes asocionados, ejecuta el comando `make stop-lonja`

Ahora, finalizado la inicialización de los contenedores docker, podremos crear y unir nuestros peers a los canales `compradoresch` y `pescadoresch`.
Para ver este proceso, ver script `channel.sh`

```bash
$ docker exec -it lonja1-cli bash
$ ./channel.sh
```

