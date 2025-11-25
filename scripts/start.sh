#!/bin/bash

# Knowledge Base Start Script
# Single command to start the development environment

set -e  # Exit on any error

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "🚀 Starting Knowledge Base Development Environment"
echo "================================================="

# Check if setup has been run
if [ ! -f ".env" ]; then
    echo "⚠️  Environment not configured. Running setup first..."
    ./scripts/setup.sh
fi

# Source environment variables
source ".env"

echo "🔍 Pre-flight checks..."

# Check Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

echo "✅ Docker is running"

# Check if containers are already running
if docker compose ps --services --filter="status=running" | grep -q hugo; then
    echo "⚠️  Development environment is already running!"
    echo ""
    echo "🌐 Access your site at:"
    echo "   - Local: http://localhost:1313"
    if [ -n "$DEV_URL" ]; then
        echo "   - OrbStack: http://$DEV_URL"
    fi
    echo ""
    echo "📋 Useful commands:"
    echo "   - View logs: docker compose logs -f hugo"
    echo "   - Stop: docker compose down"
    echo "   - Restart: docker compose restart"
    exit 0
fi

echo "🛠️  Building and starting containers..."

# Start the development environment
docker compose up --build -d

# Wait a moment for the container to start
sleep 3

# Check if the container started successfully
if docker compose ps --services --filter="status=running" | grep -q hugo; then
    echo ""
    echo "🎉 Knowledge Base is now running!"
    echo ""
    echo "🌐 Access your site at:"
    echo "   - Local: http://localhost:1313"
    
    if [ -n "$DEV_URL" ]; then
        echo "   - OrbStack: http://$DEV_URL"
    fi
    
    echo ""
    echo "📁 Content sources:"
    echo "   - Docs: $BASE$DOCS_PATH"
    echo "   - Work: $BASE$WORK_PATH" 
    echo "   - Recipes: $BASE$RECIPES_PATH"
    
    if [ -n "$BASE_EDIT_URL" ]; then
        echo "   - File browser: $BASE_EDIT_URL"
    fi
    
    echo ""
    echo "📋 Useful commands:"
    echo "   - View logs: docker compose logs -f hugo"
    echo "   - Stop: docker compose down"
    echo "   - Restart: docker compose restart"
    echo "   - Rebuild: docker compose up --build"
    
    # Show initial logs
    echo ""
    echo "🔍 Initial logs (press Ctrl+C to stop following):"
    echo "=================================================="
    
    # Follow logs but allow user to exit
    docker compose logs -f hugo
else
    echo "❌ Failed to start the development environment"
    echo ""
    echo "🔍 Container status:"
    docker compose ps
    echo ""
    echo "📋 Logs:"
    docker compose logs hugo
    exit 1
fi
