FROM node:0.12

# Install MongoDB
ENV MONGO_VERSION 2.6.10
RUN curl -SL "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz" | tar -xz -C /usr/local --strip-components=1

# Setup DB data volume
VOLUME /data/db

# Install global npm dependencies
RUN npm install -g grunt-cli bower

# Set the working dir
WORKDIR /src

# Create a new user
RUN adduser dev

# Start MongoDB and a terminal session on startup
ENV MONGOD_START "mongod --fork --logpath /var/log/mongodb.log --logappend --smallfiles"
ENTRYPOINT ["/bin/sh", "-c", "$MONGOD_START && su dev && /bin/bash"]
