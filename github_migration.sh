#!/bin/bash

# GitHub-Based Migration Workflow
# This script helps migrate data using GitHub as the transfer medium

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== GitHub-Based Migration Workflow ===${NC}"
echo "This script uses GitHub as a secure transfer medium for migration."
echo ""

# Configuration
REPO_NAME="migration-backup-$(date +%Y%m%d)"
BACKUP_DIR="$HOME/migration_backup_$(date +%Y%m%d_%H%M%S)"
GITHUB_USERNAME=""
GITHUB_TOKEN=""
WORKFLOW_MODE=""

# Function to create section headers
section() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to backup directory
backup_dir() {
    local source="$1"
    local dest="$2"
    if [ -d "$source" ]; then
        echo "Backing up $source to $dest"
        cp -r "$source" "$dest" 2>/dev/null || echo "Warning: Could not backup $source"
    else
        echo "Directory $source does not exist, skipping"
    fi
}

# Function to backup file
backup_file() {
    local source="$1"
    local dest="$2"
    if [ -f "$source" ]; then
        echo "Backing up $source to $dest"
        cp "$source" "$dest" 2>/dev/null || echo "Warning: Could not backup $source"
    else
        echo "File $source does not exist, skipping"
    fi
}

# Check prerequisites
section "Checking Prerequisites"
if ! command_exists git; then
    echo -e "${RED}Error: Git is not installed. Please install git first.${NC}"
    exit 1
fi

if ! command_exists gh; then
    echo -e "${YELLOW}Warning: GitHub CLI not found. Installing...${NC}"
    # Install GitHub CLI
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh
fi

# Get workflow mode
echo "Choose workflow mode:"
echo "1. Create backup and push to GitHub (Source machine - Laptop)"
echo "2. Pull backup from GitHub and restore (Target machine - Desktop)"
read -p "Enter choice (1 or 2): " WORKFLOW_MODE

if [ "$WORKFLOW_MODE" = "1" ]; then
    section "Source Machine Workflow - Creating Backup"
    
    # Get GitHub credentials
    read -p "Enter your GitHub username: " GITHUB_USERNAME
    echo "You'll need a GitHub Personal Access Token with repo permissions."
    echo "Create one at: https://github.com/settings/tokens"
    read -s -p "Enter your GitHub token: " GITHUB_TOKEN
    echo ""
    
    # Authenticate with GitHub
    echo "$GITHUB_TOKEN" | gh auth login --with-token
    
    # Create backup directory
    echo -e "${YELLOW}Creating backup directory: $BACKUP_DIR${NC}"
    mkdir -p "$BACKUP_DIR"
    
    # Create comprehensive backup (same as migration_script.sh)
    section "1. GitHub Repositories"
    echo "Creating list of GitHub repositories..."
    mkdir -p "$BACKUP_DIR/github"
    
    # Find all git repositories
    find "$HOME" -name ".git" -type d 2>/dev/null | while read -r gitdir; do
        repo_path=$(dirname "$gitdir")
        repo_name=$(basename "$repo_path")
        
        echo "Found repository: $repo_path"
        
        # Create repository info
        cat > "$BACKUP_DIR/github/$repo_name.info" << EOF
REPO_PATH=$repo_path
REPO_NAME=$repo_name
REMOTE_URL=$(cd "$repo_path" && git remote get-url origin 2>/dev/null || echo "No remote")
BRANCH=$(cd "$repo_path" && git branch --show-current 2>/dev/null || echo "Unknown")
EOF
        
        # Check for uncommitted changes
        if cd "$repo_path" 2>/dev/null && ! git diff-index --quiet HEAD -- 2>/dev/null; then
            echo "  - Has uncommitted changes"
            echo "HAS_CHANGES=true" >> "$BACKUP_DIR/github/$repo_name.info"
            
            # Create patch for uncommitted changes
            cd "$repo_path"
            git diff > "$BACKUP_DIR/github/${repo_name}_uncommitted.patch" 2>/dev/null || true
            git diff --cached > "$BACKUP_DIR/github/${repo_name}_staged.patch" 2>/dev/null || true
        else
            echo "  - Clean working directory"
            echo "HAS_CHANGES=false" >> "$BACKUP_DIR/github/$repo_name.info"
        fi
    done
    
    section "2. SSH Keys and Configuration"
    backup_dir "$HOME/.ssh" "$BACKUP_DIR/ssh"
    backup_file "$HOME/.ssh/config" "$BACKUP_DIR/ssh_config"
    backup_file "$HOME/.ssh/known_hosts" "$BACKUP_DIR/known_hosts"
    
    section "3. Git Configuration"
    backup_file "$HOME/.gitconfig" "$BACKUP_DIR/gitconfig"
    backup_file "$HOME/.gitignore_global" "$BACKUP_DIR/gitignore_global"
    
    section "4. Application Configurations"
    # Postman
    backup_dir "$HOME/.config/Postman" "$BACKUP_DIR/postman"
    backup_dir "$HOME/.config/Postman/User Data" "$BACKUP_DIR/postman_user_data"
    
    # Browser profiles
    backup_dir "$HOME/.mozilla" "$BACKUP_DIR/mozilla"
    backup_dir "$HOME/.config/google-chrome" "$BACKUP_DIR/chrome"
    backup_dir "$HOME/.config/brave" "$BACKUP_DIR/brave"
    
    # Password managers
    backup_dir "$HOME/.config/keepassxc" "$BACKUP_DIR/keepassxc"
    backup_dir "$HOME/.config/bitwarden" "$BACKUP_DIR/bitwarden"
    
    # Development tools
    backup_dir "$HOME/.vscode" "$BACKUP_DIR/vscode"
    backup_dir "$HOME/.config/Code" "$BACKUP_DIR/vscode_config"
    backup_dir "$HOME/.config/nvim" "$BACKUP_DIR/nvim"
    backup_dir "$HOME/.config/emacs" "$BACKUP_DIR/emacs"
    
    section "5. System Configuration"
    # Dotfiles
    backup_file "$HOME/.bashrc" "$BACKUP_DIR/bashrc"
    backup_file "$HOME/.bash_profile" "$BACKUP_DIR/bash_profile"
    backup_file "$HOME/.profile" "$BACKUP_DIR/profile"
    backup_file "$HOME/.zshrc" "$BACKUP_DIR/zshrc"
    backup_file "$HOME/.inputrc" "$BACKUP_DIR/inputrc"
    
    # Environment variables
    backup_file "$HOME/.env" "$BACKUP_DIR/env"
    backup_file "$HOME/.bash_aliases" "$BACKUP_DIR/bash_aliases"
    
    # Cron jobs
    crontab -l > "$BACKUP_DIR/crontab" 2>/dev/null || echo "No crontab found"
    
    section "6. Application Data"
    # Desktop environment
    backup_dir "$HOME/.config/cinnamon" "$BACKUP_DIR/cinnamon"
    backup_dir "$HOME/.config/nemo" "$BACKUP_DIR/nemo"
    backup_dir "$HOME/.config/gtk-3.0" "$BACKUP_DIR/gtk3"
    backup_dir "$HOME/.config/gtk-4.0" "$BACKUP_DIR/gtk4"
    
    # Terminal configurations
    backup_dir "$HOME/.config/terminator" "$BACKUP_DIR/terminator"
    backup_dir "$HOME/.config/tilix" "$BACKUP_DIR/tilix"
    backup_dir "$HOME/.config/gnome-terminal" "$BACKUP_DIR/gnome_terminal"
    
    # Package lists
    echo "Creating package lists..."
    dpkg --get-selections > "$BACKUP_DIR/installed_packages.txt"
    apt list --installed > "$BACKUP_DIR/apt_installed.txt" 2>/dev/null || true
    
    section "7. GPG Keys"
    backup_dir "$HOME/.gnupg" "$BACKUP_DIR/gnupg"
    
    section "8. Custom Scripts and Binaries"
    backup_dir "$HOME/bin" "$BACKUP_DIR/bin"
    backup_dir "$HOME/.local/bin" "$BACKUP_DIR/local_bin"
    backup_dir "$HOME/scripts" "$BACKUP_DIR/scripts"
    
    section "9. Important Directories"
    # Documents, Pictures, etc.
    backup_dir "$HOME/Documents" "$BACKUP_DIR/documents"
    backup_dir "$HOME/Pictures" "$BACKUP_DIR/pictures"
    backup_dir "$HOME/Downloads" "$BACKUP_DIR/downloads"
    backup_dir "$HOME/Desktop" "$BACKUP_DIR/desktop"
    
    section "10. Creating GitHub Repository"
    echo "Creating private GitHub repository for migration backup..."
    
    # Create private repository
    gh repo create "$REPO_NAME" --private --description "Migration backup from $(hostname) - $(date)"
    
    # Initialize git in backup directory
    cd "$BACKUP_DIR"
    git init
    git add .
    
    # Create .gitignore for sensitive files
    cat > .gitignore << EOF
# Exclude sensitive files
ssh/id_*
ssh/known_hosts
gnupg/private-keys-v1.d/
gnupg/*.key
postman/User Data/IndexedDB/
postman/User Data/Local Storage/
chrome/Default/Login Data*
chrome/Default/Cookies*
brave/Default/Login Data*
brave/Default/Cookies*
mozilla/firefox/*.default*/logins.json
mozilla/firefox/*.default*/key4.db
mozilla/firefox/*.default*/key3.db
EOF
    
    # Create README
    cat > README.md << EOF
# Migration Backup

This repository contains a migration backup from $(hostname) created on $(date).

## Contents

- GitHub repositories and their status
- SSH keys and configurations
- Application settings (Postman, browsers, etc.)
- System configurations
- User data and documents
- Cron jobs
- Package lists

## Security Notice

This repository contains sensitive information. Please:
- Keep this repository private
- Delete after successful migration
- Review all files before sharing

## Restoration

Use the \`desktop_restore.sh\` script to restore this backup on the target machine.
EOF
    
    # Commit and push
    git add .
    git commit -m "Initial migration backup from $(hostname)"
    git branch -M main
    git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    git push -u origin main
    
    echo -e "\n${GREEN}Backup created and pushed to GitHub successfully!${NC}"
    echo -e "Repository: ${YELLOW}https://github.com/$GITHUB_USERNAME/$REPO_NAME${NC}"
    echo -e "Backup location: ${YELLOW}$BACKUP_DIR${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Go to your desktop machine"
    echo "2. Run this script again and choose option 2"
    echo "3. Enter the repository name: $REPO_NAME"
    
elif [ "$WORKFLOW_MODE" = "2" ]; then
    section "Target Machine Workflow - Restoring from GitHub"
    
    # Get repository information
    read -p "Enter GitHub username: " GITHUB_USERNAME
    read -p "Enter repository name: " REPO_NAME
    echo "You'll need a GitHub Personal Access Token with repo permissions."
    read -s -p "Enter your GitHub token: " GITHUB_TOKEN
    echo ""
    
    # Authenticate with GitHub
    echo "$GITHUB_TOKEN" | gh auth login --with-token
    
    # Clone the repository
    echo "Cloning migration backup repository..."
    git clone "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git" "$BACKUP_DIR"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${RED}Error: Failed to clone repository${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Repository cloned successfully!${NC}"
    echo -e "Backup location: ${YELLOW}$BACKUP_DIR${NC}"
    
    # Run the restoration script
    section "Running Restoration"
    if [ -f "./desktop_restore.sh" ]; then
        echo "Running desktop restoration script..."
        ./desktop_restore.sh
    else
        echo -e "${YELLOW}Desktop restoration script not found.${NC}"
        echo "Please run the restoration manually or download the script."
    fi
    
    # Clean up
    section "Cleanup"
    echo "After successful restoration, you should:"
    echo "1. Test all applications and configurations"
    echo "2. Delete the local backup directory: $BACKUP_DIR"
    echo "3. Delete the GitHub repository: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
    
else
    echo -e "${RED}Invalid choice. Please run the script again and choose 1 or 2.${NC}"
    exit 1
fi

echo -e "\n${GREEN}GitHub-based migration workflow completed!${NC}" 