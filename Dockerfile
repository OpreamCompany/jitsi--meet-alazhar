 
# Use Node to build the app
FROM node:18 AS builder
WORKDIR /app

# Copy files and install
COPY . .
RUN npm install

# Build for production (no dev server or file watching)
RUN make
COPY index.html /app/build/
# Debugging: List the contents of /app/build
RUN ls -la /app/build

# # Use nginx to serve the built app
FROM nginx:alpine

# Delete default Nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy files from the builder stage to /usr/share/nginx/html
COPY --from=builder /app/css /usr/share/nginx/html/css
COPY --from=builder /app/images /usr/share/nginx/html/images
COPY --from=builder /app/libs /usr/share/nginx/html/libs
COPY --from=builder /app/static /usr/share/nginx/html/static
COPY --from=builder /app/config.js /usr/share/nginx/html/
COPY --from=builder /app/interface_config.js /usr/share/nginx/html/
#COPY --from=builder /app/utils.js /usr/share/nginx/html/
#COPY --from=builder /app/do_external_connect.js /usr/share/nginx/html/
COPY --from=builder /app/manifest.json /usr/share/nginx/html/
COPY --from=builder /app/pwa-worker.js /usr/share/nginx/html/
COPY --from=builder /app/head.html /usr/share/nginx/html/
COPY --from=builder /app/fonts.html /usr/share/nginx/html/
COPY --from=builder /app/title.html /usr/share/nginx/html/
COPY --from=builder /app/plugin.head.html /usr/share/nginx/html/
COPY --from=builder /app/body.html /usr/share/nginx/html/
COPY --from=builder /app/index.html /usr/share/nginx/html/

COPY --from=builder /app/build /usr/share/nginx/html

#RUN echo 'ssi on;' >> /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"] 

















# # Use official Node.js image with Alpine for smaller size                                                                
# FROM node:18-alpine AS builder                                                                                           
                                                                                                                         
# # Set working directory
# WORKDIR /app

# # Install system dependencies for native modules
# RUN apk add --no-cache \
#     python3 \
#     make \
#     g++ \
#     git \
#     bash

# # Copy package files first to leverage Docker cache
# COPY package.json package-lock.json .npmrc ./

# # Install dependencies
# RUN npm ci --legacy-peer-deps

# # Copy all files
# COPY . .

# # Build the application
# RUN echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf && \
#     sysctl -p
# RUN make dev

# # Create production image
# FROM node:18-alpine

# # Install system dependencies for runtime
# RUN apk add --no-cache \
#     bash \
#     curl

# # Set working directory
# WORKDIR /app

# # Copy built application from builder stage
# COPY --from=builder /app /app

# # Expose ports (Jitsi typically uses 80/443, 10000/udp for media)
# EXPOSE 80 443 10000/udp

# # Health check
# HEALTHCHECK --interval=30s --timeout=30s --start-period=10s \
#     CMD curl -f http://localhost:80 || exit 1

# # Start the application
# CMD ["make", "dev"] 
