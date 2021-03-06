apollo-nginx
============

It is nginx server that list for announcements on the cluster and
reconfigures itself adding and removing instances according.

Environment
-----------

Before run see [apollo-coreos](https://github.com/wiliamsouza/apollo-coreos#environment) for instructions.

```
IMAGE="${DOCKER_REGISTRY}/apollo/nginx"
COREOS_IP=172.16.16.101
```

Image
-----

Build this repository:

```
docker build -t $DOCKER_REGISTRY/apollo/nginx:$APOLLO_TAG .
```

Pushing images
--------------

Push the image manually, this will preload the image to the cluster node:

```
docker save $IMAGE | docker -H tcp://$COREOS_IP:2375 load
```

Push the image to local registry:

```
docker push $IMAGE:$APOLLO_TAG
```

Starting service
----------------

Start the service on the cluster:

```
cd systemd
ln -s nginx.service nginx@1.service
fleetctl start nginx@1.service
```
Info about how to configure fleet `apollo-coreos/README.md#fleet`.

Container
---------

The commands here should be executed inside a cluster node.

```
eval `cat /etc/environment`
eval `cat /etc/env.d/apollo`
```

Shell access:

```
docker run --rm -p 80:80 -i \
-e COREOS_IP=${COREOS_PUBLIC_IPV4} \
-t $DOCKER_REGISTRY/apollo/nginx:$APOLLO_ENVIRONMENT /bin/bash
```

The command above will start a container give you a shell. Don't
forget to start the service running the `startup &` script.

Manual start:

```
docker run --name nginx -p 80:80 \
-e COREOS_IP=${COREOS_PUBLIC_IPV4} \
-d $DOCKER_REGISTRY/apollo/nginx:$APOLLO_ENVIRONMENT
```

The command above will start a container and return its ID.
