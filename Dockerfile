 
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
COPY --from=builder /app/build /usr/share/nginx/html
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
