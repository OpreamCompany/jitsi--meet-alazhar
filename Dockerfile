# Base image for building the app
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy the rest of the application code
COPY . .

# Build the app
RUN npm run build
RUN ls -la
# Use nginx to serve the static files
FROM nginx:alpine

# Copy the build output from the builder stage to nginx's default serving directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 for nginx
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"] 
