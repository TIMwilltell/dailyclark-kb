# Hugo Knowledge Base - Makefile Documentation

This project includes a comprehensive Makefile for managing your Hugo knowledge base. The Makefile provides simple commands for development, building, testing, and maintenance tasks.

## Quick Start

```bash
# Get help (shows all available commands)
make help

# Quick start - setup and start server
make quick-start

# Check system health
make health

# Show server status
make status
```

## Command Reference

### 🚀 Development Commands

| Command | Description |
|---------|-------------|
| `make help` | Display all available commands with descriptions |
| `make setup` | Run initial setup (creates .env if needed) |
| `make start` | Start the development server |
| `make stop` | Stop the development server |
| `make restart` | Restart the development server |
| `make status` | Show server status and access URLs |
| `make quick-start` | Setup and start in one command |

### 🏗️ Build & Deploy Commands

| Command | Description |
|---------|-------------|
| `make build` | Build the static site using Docker |
| `make build-local` | Build using local Hugo (if installed) |
| `make clean` | Clean build artifacts and caches |

### 📝 Content Management Commands

| Command | Description | Usage Example |
|---------|-------------|---------------|
| `make new-doc` | Create new document | `make new-doc PATH=docs/my-page.md` |
| `make new-work` | Create new work document | `make new-work PATH=work/project.md` |
| `make new-recipe` | Create new recipe | `make new-recipe PATH=recipes/pasta.md` |

### 🔍 Monitoring & Debugging Commands

| Command | Description |
|---------|-------------|
| `make logs` | Show live development server logs |
| `make logs-tail` | Show last 50 lines of logs |
| `make health` | Check system health and dependencies |
| `make shell` | Access Hugo container shell |

### 🔧 Maintenance Commands

| Command | Description |
|---------|-------------|
| `make update` | Update all Hugo modules and dependencies |
| `make update-theme` | Update Hextra theme specifically |
| `make install` | Install/initialize Hugo modules |
| `make lint` | Check for common configuration issues |
| `make test` | Run basic validation tests |

### 💾 Backup & Restore Commands

| Command | Description | Usage Example |
|---------|-------------|---------------|
| `make backup` | Create timestamped backup | Creates `backups/kb_backup_YYYYMMDD_HHMMSS.tar.gz` |
| `make restore` | Restore from backup | `make restore FILE=backups/kb_backup_20240101_120000.tar.gz` |

### 🛠️ Utility Commands

| Command | Description |
|---------|-------------|
| `make env` | Show environment variables from .env |
| `make info` | Show project information |
| `make reset` | Full reset: stop, clean, setup, and start |

## Common Workflows

### Daily Development
```bash
# Start your day
make start
make status

# Create new content
make new-doc PATH=docs/daily-notes.md

# Monitor logs while working
make logs-tail

# Stop when done
make stop
```

### Troubleshooting
```bash
# Check if everything is working
make health
make status

# If issues, try a full reset
make reset

# Check for common problems
make lint

# Run validation tests
make test
```

### Maintenance
```bash
# Weekly maintenance
make update
make backup
make clean

# Update theme only
make update-theme
```

### Backup Workflow
```bash
# Create backup before major changes
make backup

# Make your changes...

# If something goes wrong, restore
make restore FILE=backups/kb_backup_20240101_120000.tar.gz
```

## Environment Setup

The Makefile works with your existing setup scripts:
- If `scripts/setup.sh` exists, `make setup` will use it
- If `scripts/start.sh` exists, `make start` will use it
- Otherwise, it falls back to direct Docker commands

## Customization

You can customize the Makefile by:
1. Adding new targets for project-specific tasks
2. Modifying existing targets to match your workflow
3. Adding environment variables in the `.env` file

## Tips

1. **Use tab completion**: Most shells support tab completion for Makefile targets
2. **Chain commands**: `make clean build` runs multiple commands
3. **Check status often**: `make status` shows current server state and URLs
4. **Monitor logs**: `make logs-tail` is great for checking recent activity
5. **Regular backups**: Use `make backup` before making major changes

## Troubleshooting

### Common Issues

**Server won't start:**
```bash
make health  # Check dependencies
make clean   # Clean old artifacts
make setup   # Ensure proper setup
```

**Template errors:**
```bash
make stop
make clean
make update
make start
```

**Permission issues:**
```bash
# Check Docker permissions
docker compose ps
make shell  # Access container to debug
```

## Integration with IDEs

Many IDEs and editors support Makefile integration:
- **VS Code**: Install "Makefile Tools" extension
- **IntelliJ/PyCharm**: Built-in Makefile support
- **Vim/Neovim**: Use `:make` command
- **Terminal**: Direct `make` commands work everywhere

This Makefile turns your Hugo knowledge base into a well-managed development environment with simple, memorable commands.
