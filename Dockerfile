FROM ubuntu:latest

# don't prompt for apt stuffs
ENV DEBIAN_FRONTEND noninteractive

# timezone data
ENV TZ=UTC

# Create app directory
WORKDIR /usr/src/app

# prep the environment
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_15.x | /bin/bash - && \
    apt-get install -y nodejs && \
    apt-get remove -y curl && \
    apt-get clean && \
    groupadd node && \
    useradd -g node -s /bin/bash node

# Install app dependencies
# A wildcard is used to ensure both package.json 
# AND package-lock.json are copied
COPY api/package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY api/ ./

# Expose our service port
EXPOSE 8000

# run as our non-root user
USER node

# what do?
CMD [ "node", "index.js" ]
