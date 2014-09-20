apollo-nginx
============

It is nginx server that list for announcements on the cluster and
reconfigures itself adding and removing instances according.

Dockerfile
----------

Docker nginx server generic image source. This is based on `ubuntu:12.04` image.


Environment
-----------

Set the environment you are working on.

```
APOLLO_ENVIRONMENT=local
```

Image
-----

Build this repository:

```
docker build -t apollo/nginx:$APOLLO_ENVIRONMENT .
```

Container
---------

This image uses environment variables to control the api server configuration.

Environment variable:

 * `COREOS_IP`: IP of etcd to connect and list for changes.

You pass with -e docker option.

The commands here should be executed inside a cluster node.

Shell access:

```
docker run --rm -p 80:80 -i \
-e COREOS_IP=<IP-ADDRESS> \
-t apollo/nginx:development /bin/bash
```

The command above will start a container give you a shell. Don't
forget to start the service running the `startup &` script.

Manual start:

```
docker run --name nginx -p 80:80 \
-e COREOS_IP=<IP-ADDRESS> \
-d apollo/nginx:development
```

The command above will start a container and return its ID.

Pushing images
--------------

Push a image manually:

```
IMAGE =<IMAGE>
COREOS_IP=<IP_ADDRESS>
docker save $IMAGE | docker -H tcp://$COREOS_IP:2375 load
docker -H tcp://$COREOS_IP:2375 tag $IMAGE apollo/nginx:development
```

Before push an image you need start a local registry `apollo-registry/README.md`
for instruction how to start a registry.

```
TAG=$APOLLO_ENVIRONMENT
REGISTRY=$APOLLO_ENVIRONMENT.registry.apollolab.com.br:5000
docker tag apollo/nginx:$TAG $REGISTRY/apollo/nginx:$TAG
docker push $REGISTRY/apollo/nginx:$TAG
```

Start the service on the cluster:

```
cd systemd
ln -s nginx.service nginx@80.service
fleetctl start nginx@80.service
```
Info about how to configure fleet `apollo-coreos/README.md#fleet`.
