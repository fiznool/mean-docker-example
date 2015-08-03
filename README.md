# mean-docker-example

The source code for [this corresponding tutorial](http://fiznool.com/blog/2015/07/25/setting-up-a-docker-based-mean-development-environment/).

## Create and run docker container

_Note: you may need to run the `docker` commands below with `sudo`._

1. Build the image:

``` sh
docker build -t fiznool/mean-docker-example .
```

This builds the image and tags it as `fiznool/mean-docker-example`.

2. Create the container from the image:

``` sh
docker run -it \
  --net="host" \
  -v `pwd`:/home/dev/src \
  --name mean-docker-example \
  fiznool/mean-docker-example
```

Here is a description of this command:

- `-it` starts the container with a terminal shell, so you can interact with it.
- `--net="host"` attaches the container's networking stack to the host machine, so you can easily access the ports used by the app and DB without needing to expose or map ports.
- ``-v `pwd`:/home/dev/src`` mounts the project's filesystem to the `/home/dev/src` directory in the container, meaning changes made in the host will be reflected automatically in the container.
- `--name mean-docker-example` names the container so it can be referenced later.
- `fiznool/mean-docker-example` creates the container from our built image.

If all has worked correctly, the docker container will have loaded, the `mongo` process will have started, and you'll be dropped to a command prompt within the container. Note that it can take a little while to start up, since MongoDB is initialising its journal on this first load of the container.

3. Inside the docker container, install the app's dependencies:

``` sh
bower install && npm install
```

4. Now you can start the web server:

``` sh
grunt serve
```

You should now be able to browse to `localhost:9000` in a web browser on your host OS to access the web app.

Take a moment to marvel at what we have achieved! The code is running inside a fully-isolated Docker container, with no need to install node.js or MongoDB on your host OS, yet you can access it in a web browser. It's like the code is running on a completely separate machine.

The killer blow comes when you realise that you can load the code in an editor on your host OS - since we have mounted the project's working directory in the container, any changes to the code we make on the host OS are instantly recognised inside the container.

Even better, since the generated project comes with [LiveReload](http://livereload.com/), changes to the source will propagate through to the opened browser, which will be automatically reloaded.

## Restarting the container

You can exit the container at any time by running `exit` at the container's command prompt.

Since we named the container in the `docker run` command above, subsequent loading of the container can be achieved with a more straightforward command:

``` sh
sudo docker start -ia mean-docker-example
```

This once again drops you into the container's command prompt, but preserves any changes that have been made to the container since last boot. As a result, your database files should be persisted across container restarts.