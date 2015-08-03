FROM node:0.12

# Install MongoDB
ENV MONGO_VERSION 3.0.4
RUN curl -SL "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz" | tar -xz -C /usr/local --strip-components=1

# Setup DB data volume
VOLUME /data/db

# Install global npm dependencies
RUN npm install -g grunt-cli bower

# Create a new user
RUN useradd -ms /bin/bash dev

# Set the working dir
WORKDIR /home/dev/src

# Start MongoDB and a terminal session on startup
ENV MONGOD_START "mongod --fork --logpath /var/log/mongodb.log --logappend --smallfiles"
ENTRYPOINT ["/bin/sh", "-c", "$MONGOD_START && su dev && /bin/bash"]
