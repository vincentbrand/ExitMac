# ==============================================================================
# macOS Laptop Cleanup Makefile
# Usage:
#   make all          - Run all cleanup tasks
#   make safari       - Clean Safari browser history & data
#   make ssh          - Remove all SSH keys
#   make chrome       - Remove all Chrome profile account data
#   make files        - Remove all files from Documents, Desktop & Downloads
#   make help         - Show this help message
# ==============================================================================

.PHONY: all safari ssh chrome files confirm help

# ------------------------------------------------------------------------------
# Default target: run everything
# ------------------------------------------------------------------------------
all: confirm safari ssh chrome files
	@echo ""
	@echo "✅  All cleanup tasks completed."

# ------------------------------------------------------------------------------
# Confirmation prompt before doing anything destructive
# ------------------------------------------------------------------------------
confirm:
	@echo "⚠️  WARNING: This will permanently delete browser history, SSH keys,"
	@echo "    Chrome profile data, and all files in Documents, Desktop & Downloads."
	@echo "    This cannot be undone."
	@printf "    Are you sure? [y/N] "; \
	read ans; \
	if [ "$$ans" != "y" ] && [ "$$ans" != "Y" ]; then \
		echo "Aborted."; \
		exit 1; \
	fi

# ------------------------------------------------------------------------------
# Safari: clear history, cache, cookies, and stored data
# ------------------------------------------------------------------------------
safari:
	@echo ""
	@echo "🧹  Cleaning Safari..."

	@# Close Safari if running
	@osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
	@sleep 1

	@# History database
	@rm -f "$(HOME)/Library/Safari/History.db" \
	        "$(HOME)/Library/Safari/History.db-shm" \
	        "$(HOME)/Library/Safari/History.db-wal"
	@echo "    ✓ Safari history removed"

	@# Cookies
	@rm -f "$(HOME)/Library/Cookies/Cookies.binarycookies"
	@echo "    ✓ Safari cookies removed"

	@# Cache
	@rm -rf "$(HOME)/Library/Caches/com.apple.Safari"
	@echo "    ✓ Safari cache removed"

	@# Downloads list
	@rm -f "$(HOME)/Library/Safari/Downloads.plist"
	@echo "    ✓ Safari downloads list removed"

	@# Top Sites & bookmarks-adjacent data
	@rm -f "$(HOME)/Library/Safari/TopSites.plist"
	@echo "    ✓ Safari Top Sites removed"

	@# Last Session
	@rm -f "$(HOME)/Library/Safari/LastSession.plist"
	@echo "    ✓ Safari last session removed"

	@# Favicon cache
	@rm -rf "$(HOME)/Library/Safari/Favicon Cache"
	@echo "    ✓ Safari favicon cache removed"

	@# Web storage (localStorage, IndexedDB, etc.)
	@rm -rf "$(HOME)/Library/Safari/LocalStorage"
	@rm -rf "$(HOME)/Library/Safari/Databases"
	@echo "    ✓ Safari web storage removed"

	@echo "    Safari cleanup complete."

# ------------------------------------------------------------------------------
# SSH: remove all keys and known_hosts
# ------------------------------------------------------------------------------
ssh:
	@echo ""
	@echo "🔑  Removing SSH keys..."

	@# Remove all key files (private + public), config, and known_hosts
	@rm -f "$(HOME)/.ssh/id_rsa" \
	        "$(HOME)/.ssh/id_rsa.pub" \
	        "$(HOME)/.ssh/id_ed25519" \
	        "$(HOME)/.ssh/id_ed25519.pub" \
	        "$(HOME)/.ssh/id_ecdsa" \
	        "$(HOME)/.ssh/id_ecdsa.pub" \
	        "$(HOME)/.ssh/id_dsa" \
	        "$(HOME)/.ssh/id_dsa.pub"
	@echo "    ✓ Standard SSH key pairs removed"

	@# Remove any additional keys not matching the standard names
	@find "$(HOME)/.ssh" -type f \
	    ! -name "*.conf" \
	    ! -name "config" \
	    -delete 2>/dev/null || true
	@echo "    ✓ Additional SSH keys removed"

	@# Remove known_hosts (identifies previously connected servers)
	@rm -f "$(HOME)/.ssh/known_hosts" \
	        "$(HOME)/.ssh/known_hosts.old"
	@echo "    ✓ SSH known_hosts removed"

	@# Remove SSH config (contains host aliases, usernames, key references)
	@rm -f "$(HOME)/.ssh/config"
	@echo "    ✓ SSH config removed"

	@# Clear SSH agent keys from memory
	@ssh-add -D 2>/dev/null && echo "    ✓ SSH agent cleared" || \
	    echo "    ℹ️  SSH agent not running or already empty"

	@echo "    SSH cleanup complete."

# ------------------------------------------------------------------------------
# Chrome: remove all profile account/login data (keeps the app itself)
# ------------------------------------------------------------------------------
chrome:
	@echo ""
	@echo "🌐  Cleaning Chrome profiles..."

	@# Close Chrome if running
	@osascript -e 'tell application "Google Chrome" to quit' 2>/dev/null || true
	@sleep 1

	@# The base directory for all Chrome user data
	$(eval CHROME_DIR := $(HOME)/Library/Application Support/Google/Chrome)

	@if [ ! -d "$(CHROME_DIR)" ]; then \
		echo "    ℹ️  Chrome user data directory not found, skipping."; \
	else \
		for profile in "$(CHROME_DIR)"/Default "$(CHROME_DIR)"/Profile\ *; do \
			if [ -d "$$profile" ]; then \
				echo "    Processing: $$profile"; \
				rm -f  "$$profile/Login Data" \
				        "$$profile/Login Data For Account" \
				        "$$profile/Cookies" \
				        "$$profile/Cookies-journal" \
				        "$$profile/History" \
				        "$$profile/History-journal" \
				        "$$profile/Favicons" \
				        "$$profile/Favicons-journal" \
				        "$$profile/Web Data" \
				        "$$profile/Web Data-journal" \
				        "$$profile/Bookmarks.bak" \
				        "$$profile/Visited Links" \
				        "$$profile/Network Action Predictor" \
				        "$$profile/Shortcuts"; \
				rm -rf "$$profile/Cache" \
				        "$$profile/Code Cache" \
				        "$$profile/GPUCache" \
				        "$$profile/Storage" \
				        "$$profile/Session Storage" \
				        "$$profile/Local Storage" \
				        "$$profile/IndexedDB" \
				        "$$profile/databases"; \
			fi; \
		done; \
		echo "    ✓ Chrome profile data removed"; \
		rm -rf "$(CHROME_DIR)/ShaderCache" \
		        "$(CHROME_DIR)/GrShaderCache"; \
		echo "    ✓ Chrome shared cache removed"; \
	fi

	@echo "    Chrome cleanup complete."

# ------------------------------------------------------------------------------
# Files: remove all files from Documents, Desktop, and Downloads
# ------------------------------------------------------------------------------
files:
	@echo ""
	@echo "📁  Cleaning Documents, Desktop & Downloads..."

	@rm -rf "$(HOME)/Documents/"* "$(HOME)/Documents/".* 2>/dev/null || true
	@echo "    ✓ Documents cleared"

	@rm -rf "$(HOME)/Desktop/"* "$(HOME)/Desktop/".* 2>/dev/null || true
	@echo "    ✓ Desktop cleared"

	@rm -rf "$(HOME)/Downloads/"* "$(HOME)/Downloads/".* 2>/dev/null || true
	@echo "    ✓ Downloads cleared"

	@echo "    Files cleanup complete."

# ------------------------------------------------------------------------------
# Help
# ------------------------------------------------------------------------------
help:
	@echo ""
	@echo "macOS Laptop Cleanup Makefile"
	@echo "------------------------------"
	@echo "  make all      Run all cleanup tasks (safari + ssh + chrome + files)"
	@echo "  make safari   Clean Safari history, cookies, cache & storage"
	@echo "  make ssh      Remove SSH keys, known_hosts, config & agent cache"
	@echo "  make chrome   Remove Chrome profile login data, history & cache"
	@echo "  make files    Remove all files from Documents, Desktop & Downloads"
	@echo "  make help     Show this message"
	@echo ""