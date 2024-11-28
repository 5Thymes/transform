# Start your image with a node base image
# ARG NODE_VERSION=node:16-alpine


# FROM $NODE_VERSION AS dependency-base
FROM node:16 AS dependency-base
# RUN apk add --no-cache --update nodejs=16.20.2-r0 yarn=1.22.17-r0 git=2.34.8-r0
# The /app directory should act as the main application directory
WORKDIR /app

# RUN apk add --no-cache --update yarn

# Copy the app package and package-lock.json file
COPY package*.json yarn.lock ./
# RUN npm config set -g registry https://registry.npmmirror.com

# RUN yarn install

FROM dependency-base AS production-base
# Copy local directories to the current local directory of our docker image (/app)
COPY . .

# Install node packages, install serve, build the app, and remove dependencies at the end
RUN yarn install && yarn build 
# RUN  npm prune --production

# FROM $NODE_VERSION AS production
FROM alpine:3.15 AS production


WORKDIR /app
RUN apk add --no-cache --update nodejs=16.20.2-r0 yarn=1.22.17-r0
COPY --from=production-base /app /app

# ENV HOST=0.0.0.0
EXPOSE 3000

# Start the app using serve command
# CMD [ "node", "/app/server/index.js" ]
CMD [ "yarn", "start"  ]