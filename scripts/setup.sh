#!/bin/bash

# Knowledge Base Setup Script
# This script ensures proper environment setup for local development

set -e  # Exit on any error

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_DIR/.env"
ENV_EXAMPLE="$PROJECT_DIR/.env.example"

echo "🚀 Knowledge Base Setup"
echo "======================="

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "⚠️  No .env file found. Creating from template..."

    if [ -f "$ENV_EXAMPLE" ]; then
        cp "$ENV_EXAMPLE" "$ENV_FILE"
        echo "✅ Created .env file from .env.example"
        echo ""
        echo "🔧 Please edit .env file with your actual paths:"
        echo "   - Set BASE to your home directory (usually /Users/yourusername/)"
        echo "   - Set content paths (DOCS_PATH, WORK_PATH, RECIPES_PATH)"
        echo "   - Optionally set development URLs for OrbStack"
        echo ""
        echo "After editing .env, run this script again to validate paths."
        exit 1
    else
        echo "❌ .env.example not found. Cannot create .env file."
        exit 1
    fi
fi

echo "✅ Found .env file"

# Source the .env file
source "$ENV_FILE"

# Validate required variables
echo "🔍 Validating environment variables..."

REQUIRED_VARS=("BASE" "DOCS_PATH" "WORK_PATH" "RECIPES_PATH")
MISSING_VARS=()

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        MISSING_VARS+=("$var")
    fi
done

if [ ${#MISSING_VARS[@]} -ne 0 ]; then
    echo "❌ Missing required environment variables:"
    for var in "${MISSING_VARS[@]}"; do
        echo "   - $var"
    done
    echo ""
    echo "Please edit .env file and set these variables."
    exit 1
fi

# Validate paths exist
echo "📁 Validating content paths..."

PATHS_TO_CHECK=(
    "$BASE$DOCS_PATH:Documentation content"
    "$BASE$WORK_PATH:Work content"
    "$BASE$RECIPES_PATH:Recipes content"
)

MISSING_PATHS=()

for path_info in "${PATHS_TO_CHECK[@]}"; do
    path="${path_info%:*}"
    description="${path_info#*:}"

    if [ ! -d "$path" ]; then
        MISSING_PATHS+=("$path ($description)")
        echo "⚠️  Missing: $path ($description)"
    else
        echo "✅ Found: $path ($description)"
    fi
done

if [ ${#MISSING_PATHS[@]} -ne 0 ]; then
    echo ""
    echo "⚠️  Some content directories are missing:"
    for path in "${MISSING_PATHS[@]}"; do
        echo "   - $path"
    done
    echo ""
    echo "The site will still work, but these sections will be empty."
    echo "Create the missing directories or update your .env file with correct paths."
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""
echo "✅ Environment setup complete!"
echo ""
echo "📋 Configuration summary:"
echo "   Base path: $BASE"
echo "   Docs: $DOCS_PATH"
echo "   Work: $WORK_PATH"
echo "   Recipes: $RECIPES_PATH"

if [ -n "$DEV_URL" ]; then
    echo "   Dev URL: $DEV_URL"
fi

echo ""
echo "🎉 Ready to start development!"
echo "   Run: ./scripts/start.sh"
