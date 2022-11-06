# use alphine as one of the most mininal size version of linux, use alias for multi-stage build
FROM node:18-alpine as build
# separate app from system root
WORKDIR /app
# only package configs were copied to keep npm install cached if ts files changed
COPY package*.json ./
# run create new layer but in cache if package configs weren't changed
RUN npm install
# copy project files for build
COPY * ./
# run build with non-optimized node_modules as actually it doesn't work with minified version due to dev dependencies 
# then optimize node_modules and clean cache
RUN npm run build && npm ci --only=production && npm cache clean --force

# create new stage to copy optized files which only required for project to be run
FROM node:18-alpine
COPY --from=build ./node_modules ./node_modules
COPY --from=build ./dist ./dist
USER node
EXPOSE 4000
CMD [ "node", "dist/main.js" ]




## Second approach to move required dependencies as nest, rimraf... from devDeps to deps
## minimized to 420mb or less
# FROM node:18.8.0-alpine
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci --only=production && npm cache clean --force
# COPY * ./
# RUN npm run build
# USER node
# EXPOSE 4000
# CMD ["node", "dist/main.js"]