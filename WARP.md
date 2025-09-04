# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Hugo-based personal knowledge base static site using the Hextra theme. The site is designed to organize and display content from multiple sources including documents, work notes, and recipes through a unified web interface.

## Architecture

### Content Organization
- **Content Sources**: The site aggregates content from multiple external directories via Docker volume mounts
- **Theme**: Uses Hextra theme (github.com/imfing/hextra) for documentation-style layout
- **Content Sections**: 
  - `/docs` - Personal documents and notes
  - `/work` - Work-related documentation  
  - `/recipes` - Recipe collection
- **External Content**: Content is mounted from external paths defined in environment variables

### Key Configuration
- `hugo.yaml`: Main Hugo configuration with theme settings, menu structure, and security policies
- `docker-compose.yml`: Development environment with volume mounts for external content
- `.env`: Environment variables defining paths to external content directories

## Quick Start

### Single Command Development
```bash
# Start development environment (handles setup automatically)
./scripts/start.sh
```

This script will:
- Check and create `.env` file if needed
- Validate all environment variables and paths
- Start Docker containers with hot reloading
- Show access URLs and useful commands

### First Time Setup (Optional)
If you want to configure environment separately:
```bash
# Run setup script to configure .env file
./scripts/setup.sh

# Then start development
./scripts/start.sh
```

## Common Development Commands

### Development Server Management
```bash
# Start development server with hot reloading
./scripts/start.sh

# View logs
docker compose logs -f hugo

# Stop development server
docker compose down

# Restart containers
docker compose restart
```

### Content Management
```bash
# Create new content using archetype
hugo new content/docs/new-page.md
hugo new content/work/new-work-doc.md
hugo new content/recipes/new-recipe.md

# Build static site
hugo --minify

# Clean build artifacts
rm -rf public/ resources/ .hugo_build.lock
```

### Hugo Module Management
```bash
# Update Hextra theme
hugo mod get -u github.com/imfing/hextra
hugo mod tidy

# Initialize Hugo modules (if needed)
hugo mod init second-brain
```

## Content Structure

### Front Matter Template
All content should include:
```yaml
---
title: "Page Title"
date: 2024-01-01T00:00:00Z
draft: false
---
```

### Hextra Theme Features
- **Cards**: Use `{{< cards >}}` and `{{< card >}}` shortcodes for grid layouts
- **Navigation**: Configured in `hugo.yaml` menu section
- **Search**: Built-in search functionality enabled
- **Edit Links**: Configured to point to local file browser at `localhost:1314/files`

## Environment Configuration

### Required Environment Variables
The `.env` file must contain these variables:
```bash
BASE=/Users/yourusername/                    # Base path (usually home directory)
DOCS_PATH=path/to/your/docs/                 # Documentation content (relative to BASE)
WORK_PATH=path/to/your/work/content/         # Work content (relative to BASE)
RECIPES_PATH=path/to/your/recipes/           # Recipe content (relative to BASE)
```

### Optional Variables
```bash
DEV_URL=kb.yourdomain.local                 # Custom development URL (OrbStack)
DEV_FB_URL=fb.yourdomain.local              # File browser URL
BASE_EDIT_URL=http://localhost:1314/files   # Edit button URL
UID=1000                                     # User ID (auto-generated)
GID=1000                                     # Group ID (auto-generated)
```

### Setup Scripts
- `scripts/setup.sh`: Environment validation and `.env` creation
- `scripts/start.sh`: Single-command development startup
- Both scripts are executable and handle error cases gracefully

## Development Environment

### Docker Setup
- Uses `hugomods/hugo:exts` image with extended Hugo features
- Binds to `0.0.0.0:1313` for external access
- Auto-restarts unless stopped
- Supports OrbStack domains via labels

### External Content Integration
Content is mounted from external directories, allowing the knowledge base to display files managed elsewhere without duplication. This enables:
- Separation of content from presentation
- Multiple content sources in a single site
- Version control independence for different content types

## Site Features

### Current Functionality
- Multi-section content organization
- Dark/light theme support (system default)
- Search capability
- Edit button linking to file browser
- Mobile-responsive design

### Planned Improvements
- Content filtering and aggregation across sections
- Enhanced edit workflow integration
- Local deployment optimization
- User authentication system
