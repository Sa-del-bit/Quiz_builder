# Use Node.js 18 as the base image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Install serve to serve the static files
RUN npm install -g serve

# Expose port 3000
EXPOSE 3000

# Serve the application
CMD ["serve", "-s", "dist", "-l", "3000"]