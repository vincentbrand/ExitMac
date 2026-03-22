# Exit

A macOS cleanup Makefile that permanently wipes personal data from your laptop. Useful for decommissioning a machine or performing a full personal data reset.

## What it does

| Target | Description |
|--------|-------------|
| `safari` | Closes Safari and removes history, cookies, cache, downloads list, top sites, last session, favicon cache, and web storage |
| `ssh` | Deletes all SSH keys, known_hosts, SSH config, and clears the SSH agent |
| `chrome` | Closes Chrome and removes login data, cookies, history, favicons, web data, bookmarks backup, cache, and local storage across all profiles |
| `files` | Removes all files and folders from ~/Documents, ~/Desktop, and ~/Downloads |

## Usage

Run from the project directory:

```bash
# Run all cleanup tasks (with confirmation prompt)
make all

# Run individual targets
make safari
make ssh
make chrome
make files

# Show available targets
make help
```

> **Warning:** Running `make all` or any individual target is **irreversible**. All targeted data will be permanently deleted. `make all` will prompt for confirmation before proceeding; individual targets will not.
