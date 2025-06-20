#!/bin/bash

echo "🚀 Starting Jenkins..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Start Jenkins
echo "📦 Starting Jenkins container..."
docker-compose up -d

# Wait for Jenkins to start
echo "⏳ Waiting for Jenkins to start..."
sleep 30

# Get admin password
echo "🔑 Getting admin password..."
ADMIN_PASSWORD=$(docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null)

if [ -n "$ADMIN_PASSWORD" ]; then
    echo "✅ Jenkins is ready!"
    echo "🌐 Access Jenkins at: http://localhost:8080"
    echo "🔑 Admin password: $ADMIN_PASSWORD"
    echo ""
    echo "📋 Next steps:"
    echo "1. Open http://localhost:8080 in your browser"
    echo "2. Enter the admin password above"
    echo "3. Install suggested plugins"
    echo "4. Create admin user"
    echo "5. Setup pipeline job"
else
    echo "⚠️  Jenkins is starting, please wait a moment and check:"
    echo "   http://localhost:8080"
    echo ""
    echo "To get admin password later, run:"
    echo "docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
fi

echo ""
echo "📊 To view logs: docker logs jenkins"
echo "🛑 To stop: docker-compose down" 