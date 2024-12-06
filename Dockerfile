# Base image
FROM node:16

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY app/package*.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY app/ .

# Expose application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
