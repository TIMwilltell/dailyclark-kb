# Hugo Knowledge Base Makefile
# Provides convenient commands for development, building, and management

.PHONY: help setup start stop restart build clean logs status test lint format install update backup restore

# Default target
.DEFAULT_GOAL := help

# Colors for output
RESET := \033[0m
BOLD := \033[1m
YELLOW := \033[33m
GREEN := \033[32m
BLUE := \033[34m
RED := \033[31m

##@ Development

help: ## Display this help message
	@echo "$(BOLD)Hugo Knowledge Base Management$(RESET)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make $(YELLOW)<target>$(RESET)\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  $(YELLOW)%-15s$(RESET) %s\n", $$1, $$2 } /^##@/ { printf "\n$(BOLD)%s$(RESET)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

setup: ## Run initial setup (creates .env if needed)
	@echo "$(BLUE)Setting up environment...$(RESET)"
	@if [ -f ./scripts/setup.sh ]; then \
		./scripts/setup.sh; \
	else \
		echo "$(YELLOW)Warning: setup.sh not found, creating basic .env$(RESET)"; \
		touch .env; \
	fi

start: ## Start the development server
	@echo "$(GREEN)Starting Hugo development server...$(RESET)"
	@if [ -f ./scripts/start.sh ]; then \
		./scripts/start.sh; \
	else \
		docker compose up -d; \
		echo "$(GREEN)✓ Development server started$(RESET)"; \
		$(MAKE) status; \
	fi

stop: ## Stop the development server
	@echo "$(YELLOW)Stopping development server...$(RESET)"
	@docker compose down
	@echo "$(GREEN)✓ Development server stopped$(RESET)"

restart: stop start ## Restart the development server

##@ Build & Deploy

build: ## Build the static site
	@echo "$(BLUE)Building static site...$(RESET)"
	@docker compose exec hugo hugo --minify
	@echo "$(GREEN)✓ Site built successfully$(RESET)"

build-local: ## Build using local Hugo (if installed)
	@echo "$(BLUE)Building with local Hugo...$(RESET)"
	@hugo --minify
	@echo "$(GREEN)✓ Site built locally$(RESET)"

clean: ## Clean build artifacts and caches
	@echo "$(YELLOW)Cleaning build artifacts...$(RESET)"
	@rm -rf public/ resources/ .hugo_build.lock
	@docker system prune -f --filter "label=com.docker.compose.project=dailyclark-kb" 2>/dev/null || true
	@echo "$(GREEN)✓ Cleaned build artifacts$(RESET)"

##@ Content Management

new-doc: ## Create new document (usage: make new-doc PATH=docs/new-page.md)
	@if [ -z "$(PATH)" ]; then \
		echo "$(RED)Error: PATH parameter required$(RESET)"; \
		echo "Usage: make new-doc PATH=docs/new-page.md"; \
		exit 1; \
	fi
	@docker compose exec hugo hugo new content/$(PATH)
	@echo "$(GREEN)✓ Created new document: $(PATH)$(RESET)"

new-work: ## Create new work document (usage: make new-work PATH=work/new-doc.md)
	@if [ -z "$(PATH)" ]; then \
		echo "$(RED)Error: PATH parameter required$(RESET)"; \
		echo "Usage: make new-work PATH=work/new-doc.md"; \
		exit 1; \
	fi
	@docker compose exec hugo hugo new content/$(PATH)
	@echo "$(GREEN)✓ Created new work document: $(PATH)$(RESET)"

new-recipe: ## Create new recipe (usage: make new-recipe PATH=recipes/new-recipe.md)
	@if [ -z "$(PATH)" ]; then \
		echo "$(RED)Error: PATH parameter required$(RESET)"; \
		echo "Usage: make new-recipe PATH=recipes/new-recipe.md"; \
		exit 1; \
	fi
	@docker compose exec hugo hugo new content/$(PATH)
	@echo "$(GREEN)✓ Created new recipe: $(PATH)$(RESET)"

##@ Monitoring & Debugging

logs: ## Show development server logs
	@docker compose logs -f hugo

logs-tail: ## Show last 50 lines of logs
	@docker compose logs --tail=50 hugo

status: ## Show server status and URLs
	@echo "$(BOLD)Development Server Status$(RESET)"
	@echo "================================"
	@if docker compose ps | grep -q "running"; then \
		echo "$(GREEN)✓ Server is running$(RESET)"; \
		echo ""; \
		echo "$(BOLD)Available URLs:$(RESET)"; \
		echo "  Local:     http://localhost:1313"; \
		if [ -n "$$DEV_URL" ]; then \
			echo "  Custom:    http://$$DEV_URL"; \
		fi; \
		if [ -n "$$DEV_FB_URL" ]; then \
			echo "  Files:     http://$$DEV_FB_URL"; \
		fi; \
		echo ""; \
		echo "$(BOLD)Useful Commands:$(RESET)"; \
		echo "  View logs: make logs"; \
		echo "  Restart:   make restart"; \
		echo "  Stop:      make stop"; \
	else \
		echo "$(RED)✗ Server is not running$(RESET)"; \
		echo ""; \
		echo "Start with: make start"; \
	fi

health: ## Check system health
	@echo "$(BOLD)System Health Check$(RESET)"
	@echo "======================"
	@printf "Docker: "
	@if command -v docker >/dev/null 2>&1; then \
		echo "$(GREEN)✓ Available$(RESET)"; \
	else \
		echo "$(RED)✗ Not found$(RESET)"; \
	fi
	@printf "Docker Compose: "
	@if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then \
		echo "$(GREEN)✓ Available$(RESET)"; \
	else \
		echo "$(RED)✗ Not found$(RESET)"; \
	fi
	@printf "Environment File: "
	@if [ -f .env ]; then \
		echo "$(GREEN)✓ Found$(RESET)"; \
	else \
		echo "$(YELLOW)⚠ Missing (.env)$(RESET)"; \
	fi
	@printf "Hugo Module: "
	@if [ -f go.mod ]; then \
		echo "$(GREEN)✓ Found$(RESET)"; \
	else \
		echo "$(YELLOW)⚠ Missing (go.mod)$(RESET)"; \
	fi

##@ Maintenance

update: ## Update Hugo modules and dependencies
	@echo "$(BLUE)Updating Hugo modules...$(RESET)"
	@docker compose exec hugo hugo mod get -u
	@docker compose exec hugo hugo mod tidy
	@echo "$(GREEN)✓ Modules updated$(RESET)"

update-theme: ## Update Hextra theme specifically
	@echo "$(BLUE)Updating Hextra theme...$(RESET)"
	@docker compose exec hugo hugo mod get -u github.com/imfing/hextra
	@docker compose exec hugo hugo mod tidy
	@echo "$(GREEN)✓ Theme updated$(RESET)"

install: ## Install/initialize Hugo modules
	@echo "$(BLUE)Initializing Hugo modules...$(RESET)"
	@if [ ! -f go.mod ]; then \
		docker compose exec hugo hugo mod init dailyclark-kb; \
	fi
	@docker compose exec hugo hugo mod get github.com/imfing/hextra
	@docker compose exec hugo hugo mod tidy
	@echo "$(GREEN)✓ Modules installed$(RESET)"

##@ Backup & Restore

backup: ## Create backup of content and configuration
	@echo "$(BLUE)Creating backup...$(RESET)"
	@mkdir -p backups
	@TIMESTAMP=$$(date +%Y%m%d_%H%M%S); \
	tar -czf "backups/kb_backup_$$TIMESTAMP.tar.gz" \
		--exclude='.git' \
		--exclude='node_modules' \
		--exclude='public' \
		--exclude='resources' \
		--exclude='.hugo_build.lock' \
		--exclude='backups' \
		. && \
	echo "$(GREEN)✓ Backup created: backups/kb_backup_$$TIMESTAMP.tar.gz$(RESET)"

restore: ## Restore from backup (usage: make restore FILE=backup_file.tar.gz)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)Error: FILE parameter required$(RESET)"; \
		echo "Usage: make restore FILE=backups/kb_backup_20240101_120000.tar.gz"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		echo "$(RED)Error: Backup file $(FILE) not found$(RESET)"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Restoring from backup: $(FILE)$(RESET)"
	@tar -xzf "$(FILE)"
	@echo "$(GREEN)✓ Restored from backup$(RESET)"

##@ Testing & Quality

test: ## Run basic tests and validation
	@echo "$(BLUE)Running validation tests...$(RESET)"
	@echo "Testing Docker setup..."
	@docker compose config > /dev/null && echo "$(GREEN)✓ Docker Compose configuration valid$(RESET)"
	@echo "Testing Hugo configuration..."
	@if docker compose ps | grep -q "running"; then \
		docker compose exec hugo hugo config > /dev/null && echo "$(GREEN)✓ Hugo configuration valid$(RESET)"; \
	else \
		echo "$(YELLOW)⚠ Server not running, skipping Hugo config test$(RESET)"; \
	fi
	@echo "$(GREEN)✓ Basic tests passed$(RESET)"

lint: ## Check for common issues
	@echo "$(BLUE)Checking for common issues...$(RESET)"
	@if [ ! -f .env ]; then \
		echo "$(YELLOW)⚠ No .env file found - run 'make setup'$(RESET)"; \
	fi
	@if [ ! -f go.mod ]; then \
		echo "$(YELLOW)⚠ No go.mod file found - run 'make install'$(RESET)"; \
	fi
	@if docker compose ps | grep -q "running"; then \
		echo "$(GREEN)✓ Development server is running$(RESET)"; \
	else \
		echo "$(YELLOW)⚠ Development server is not running$(RESET)"; \
	fi
	@echo "$(GREEN)✓ Lint check completed$(RESET)"

##@ Utility

env: ## Show environment variables (from .env file)
	@if [ -f .env ]; then \
		echo "$(BOLD)Environment Variables:$(RESET)"; \
		cat .env | grep -v '^#' | grep -v '^$$'; \
	else \
		echo "$(YELLOW)No .env file found$(RESET)"; \
	fi

shell: ## Access Hugo container shell
	@docker compose exec hugo sh

quick-start: setup start ## Quick start: setup + start server

reset: stop clean setup start ## Full reset: stop, clean, setup, and start

info: ## Show project information
	@echo "$(BOLD)Hugo Knowledge Base Project$(RESET)"
	@echo "==============================="
	@echo "Theme:         Hextra"
	@echo "Content Types: docs, work, recipes"
	@echo "Development:   Docker + Hugo"
	@echo ""
	@echo "$(BOLD)Key Files:$(RESET)"
	@echo "  hugo.yaml         - Main configuration"
	@echo "  docker-compose.yml - Development environment"
	@echo "  .env              - Environment variables"
	@echo "  scripts/          - Management scripts"
	@echo ""
	@echo "Run '$(YELLOW)make help$(RESET)' for available commands"
