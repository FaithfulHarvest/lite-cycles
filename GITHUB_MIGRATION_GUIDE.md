# GitHub-Based Migration Guide

This guide explains how to use GitHub as a secure transfer medium for migrating your data from laptop to desktop.

## 🚀 Quick Start

### Prerequisites
- GitHub account
- GitHub Personal Access Token (with `repo` permissions)
- Git installed on both machines
- GitHub CLI (will be installed automatically if missing)

### Step 1: Create GitHub Personal Access Token

1. Go to [GitHub Settings > Tokens](https://github.com/settings/tokens)
2. Click "Generate new token (classic)"
3. Give it a name like "Migration Backup"
4. Select scopes:
   - ✅ `repo` (Full control of private repositories)
5. Click "Generate token"
6. **Copy the token** - you'll need it for both machines

## 📋 Migration Workflow

### Phase 1: Source Machine (Laptop)

1. **Copy the script to your laptop:**
   ```bash
   # Copy github_migration.sh to your laptop
   # Then run:
   ./github_migration.sh
   ```

2. **Choose option 1** when prompted

3. **Enter your GitHub credentials:**
   - GitHub username
   - GitHub Personal Access Token

4. **The script will:**
   - Create a comprehensive backup
   - Create a private GitHub repository
   - Push the backup to GitHub
   - Exclude sensitive files (SSH keys, passwords, etc.)

5. **Note the repository name** - you'll need it for the desktop

### Phase 2: Target Machine (Desktop)

1. **Copy the script to your desktop:**
   ```bash
   # Copy github_migration.sh to your desktop
   # Then run:
   ./github_migration.sh
   ```

2. **Choose option 2** when prompted

3. **Enter the repository details:**
   - GitHub username
   - Repository name (from step 1)

4. **The script will:**
   - Clone the backup repository
   - Run the restoration process
   - Set up all your configurations

## 🔒 Security Features

### What's Excluded from GitHub
The script automatically excludes sensitive files:
- SSH private keys (`ssh/id_*`)
- Known hosts file
- GPG private keys
- Browser login data and cookies
- Postman local storage
- Password manager databases

### What's Included
- SSH public keys and configuration
- Application settings and preferences
- System configurations
- User documents and data
- Package lists
- Repository information

## 📁 Repository Structure

The GitHub repository will contain:
```
migration-backup-YYYYMMDD/
├── README.md                 # Migration information
├── .gitignore               # Excludes sensitive files
├── github/                  # Repository information and patches
├── ssh/                     # SSH configuration (no private keys)
├── postman/                 # Postman collections and settings
├── mozilla/                 # Firefox profile
├── chrome/                  # Chrome profile
├── brave/                   # Brave profile
├── vscode/                  # VS Code settings
├── documents/               # User documents
├── pictures/                # User pictures
├── downloads/               # User downloads
├── desktop/                 # Desktop files
├── crontab                  # Scheduled tasks
├── installed_packages.txt   # Package list
└── ... (other configurations)
```

## 🔄 Alternative Workflow

If you prefer to use the traditional scripts:

1. **On laptop:** Run `migration_script.sh`
2. **Transfer:** Use USB drive, network, or cloud storage
3. **On desktop:** Run `desktop_restore.sh`

## 🛠️ Troubleshooting

### GitHub CLI Issues
```bash
# If GitHub CLI installation fails
sudo apt update
sudo apt install gh

# Or install manually
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

### Repository Access Issues
```bash
# Test GitHub authentication
gh auth status

# Re-authenticate if needed
gh auth login
```

### Large File Issues
If the backup is very large (>100MB), consider:
1. Using Git LFS (Large File Storage)
2. Splitting the backup into multiple repositories
3. Using traditional transfer methods

## 🧹 Cleanup

After successful migration:

1. **Test everything** on the desktop
2. **Delete the local backup** on both machines
3. **Delete the GitHub repository:**
   ```bash
   gh repo delete migration-backup-YYYYMMDD --yes
   ```

## 📊 Advantages of GitHub Method

### ✅ Pros
- **Secure:** Private repository with access control
- **Reliable:** GitHub's infrastructure
- **Versioned:** Git history of changes
- **Accessible:** Available from anywhere
- **Free:** No storage costs
- **Fast:** Efficient Git transfer

### ⚠️ Considerations
- **Size limits:** GitHub has file size limits
- **Sensitive data:** Must be careful with exclusions
- **Internet required:** Needs network connection
- **Token management:** Requires GitHub token

## 🔧 Customization

### Modify Exclusions
Edit the `.gitignore` section in the script to exclude additional files:
```bash
# Add to .gitignore
*.log
*.tmp
*.cache
```

### Change Repository Name
Modify the `REPO_NAME` variable in the script:
```bash
REPO_NAME="my-migration-$(date +%Y%m%d)"
```

### Add More Applications
Add more backup directories in the script:
```bash
# Add to backup section
backup_dir "$HOME/.config/myapp" "$BACKUP_DIR/myapp"
```

## 📞 Support

If you encounter issues:

1. Check the troubleshooting section
2. Review GitHub CLI documentation
3. Verify your GitHub token permissions
4. Check network connectivity
5. Review the script logs

## 🎯 Next Steps

1. **Create your GitHub Personal Access Token**
2. **Copy the script to your laptop**
3. **Run the migration workflow**
4. **Test everything on your desktop**
5. **Clean up the temporary files**

Good luck with your migration! 