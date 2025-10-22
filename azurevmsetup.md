# Azure Linux VM Setup Guide
## Complete Setup for MATE Desktop + Cursor AI + Remote Desktop Access

### Prerequisites
- Azure Linux VM created with Ubuntu 22.04
- RSA private key for SSH access
- Windows machine for remote access
- **CRITICAL:** Azure VM must have port 22 (SSH) configured as inbound port during creation
- VM IP address (e.g., 40.80.195.73)
- Username (e.g., "tron" or "azureuser")

---

## Step 1: SSH Connection Setup

### Save Private Key on Windows
1. Save RSA private key to: `C:\Users\[username]\.ssh\azure_vm_key.pem`
2. Set proper permissions:
   ```powershell
   icacls "C:\Users\[username]\.ssh\azure_vm_key.pem" /inheritance:r /grant:r "[username]:F"
   ```
3. **Verify key file exists and has correct permissions**

### Test SSH Connection
```bash
ssh -i C:\Users\[username]\.ssh\azure_vm_key.pem -o StrictHostKeyChecking=no [username]@[VM_IP_ADDRESS]
```
**Expected:** Should connect successfully and show Ubuntu welcome message

### Connect to VM
```bash
ssh -i C:\Users\[username]\.ssh\azure_vm_key.pem -o StrictHostKeyChecking=no [username]@[VM_IP_ADDRESS]
```

---

## Step 2: System Update and MATE Desktop Installation

### Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### Install MATE Desktop Environment
```bash
sudo apt install ubuntu-mate-desktop -y
```

**Note:** This installation includes:
- MATE desktop environment
- MATE applications (file manager, terminal, etc.)
- Ubuntu MATE themes and settings
- All necessary dependencies

**IMPORTANT:** Installation may show "Pending kernel upgrade" dialog - press Enter to dismiss it.

### Reboot After Installation
```bash
sudo reboot
```

**Wait 2-3 minutes for VM to fully reboot, then reconnect via SSH.**

---

## Step 3: Remote Desktop Access Setup

### Install XRDP
```bash
sudo apt install xrdp -y
```

### Configure Desktop Session
```bash
echo "mate-session" > ~/.xsession
```

### Configure Firewall
```bash
sudo ufw allow 3389/tcp
```

### Set User Password (Required for RDP)
```bash
sudo passwd [username]
```

### Verify XRDP Status
```bash
sudo systemctl status xrdp
```

**Expected output:** Service should be active and listening on port 3389

---

## Step 4: Azure Network Security Group Configuration

### Critical Step: Add RDP Port Rule
1. Go to Azure Portal → Your VM → **Networking** tab
2. Click **"Add inbound port rule"**
3. Configure:
   - **Source:** Any
   - **Source port ranges:** *
   - **Destination:** Any
   - **Destination port ranges:** 3389
   - **Protocol:** TCP
   - **Action:** Allow
   - **Priority:** 1000
   - **Name:** Allow-RDP
4. Click **"Add"**

**Note:** This is essential - without this rule, RDP connections will fail with error 0x204.

---

## Step 5: Remote Desktop Connection

### Connect from Windows
1. Open **Remote Desktop Connection** (mstsc)
2. Enter:
   - **Computer:** `[VM_IP_ADDRESS]`
   - **User name:** `[username]`
   - **Password:** `[password_you_set]`
3. Click **"Connect"**

**Expected result:** You should see the MATE desktop environment.

---

## Step 6: Install Cursor AI

### Method 1: Via Desktop (Recommended)
1. **First install Firefox:**
   ```bash
   sudo apt install firefox -y
   ```
2. Open Firefox in MATE desktop
3. Go to https://cursor.sh/
4. Download Linux version (.deb file) - it will be saved to ~/Downloads/
5. Run the installer (double-click the .deb file)
6. **Verify installation:**
   ```bash
   which cursor
   # Should return: /usr/bin/cursor
   ```
7. Create desktop shortcut:
   ```bash
   cat > ~/Desktop/cursor.desktop << 'EOF'
   [Desktop Entry]
   Name=Cursor
   Comment=AI-powered code editor
   Exec=/usr/bin/cursor
   Icon=cursor
   Terminal=false
   Type=Application
   Categories=Development;
   EOF
   ```

### Method 2: Via SSH (Alternative)
```bash
# Download Cursor AI
wget https://downloader.cursor.sh/linux/appImage/x64 -O cursor.AppImage
chmod +x cursor.AppImage
```

---

## Step 7: Verify Installation

### Check Cursor Installation
```bash
which cursor
# Should return: /usr/bin/cursor
```

### Test Cursor Launch
```bash
cursor --version
```

---

## Troubleshooting

### Common Issues

#### RDP Connection Fails (Error 0x204)
- **Cause:** Azure NSG blocking port 3389
- **Solution:** Add inbound rule for port 3389 in Azure Portal

#### SSH Connection Fails
- **Cause:** Wrong username or key path
- **Solution:** Verify username and key file path

#### DNS Resolution Issues
- **Cause:** VM can't resolve external domains
- **Solution:** Check DNS settings or use alternative download methods

#### Kernel Upgrade Dialog Blocks Installation
- **Cause:** System shows "Pending kernel upgrade" dialog during apt install
- **Solution:** Press Enter to dismiss dialog, then continue installation

#### Firefox Not Visible After Installation
- **Cause:** Firefox installed but not showing in applications menu
- **Solution:** Launch from terminal: `firefox &` or restart desktop session

### Useful Commands

#### Check XRDP Status
```bash
sudo systemctl status xrdp
sudo systemctl restart xrdp
```

#### Check Firewall Status
```bash
sudo ufw status
```

#### Check Network Connectivity
```bash
sudo ss -tlnp | grep 3389
```

---

## Final Configuration

### Desktop Shortcuts
- Cursor AI should appear in Applications menu
- Desktop shortcut created for easy access

### System Services
- XRDP: Enabled and running
- MATE Desktop: Installed and configured
- Firewall: Port 3389 allowed

### Access Methods
1. **SSH:** For command-line access
2. **RDP:** For full desktop experience
3. **Both:** Can be used simultaneously

---

## Success Checklist

- [ ] SSH connection working
- [ ] System updated and rebooted
- [ ] MATE desktop installed
- [ ] XRDP service running
- [ ] Azure NSG rule added (port 3389)
- [ ] RDP connection working
- [ ] Firefox installed and accessible
- [ ] Cursor AI downloaded and installed
- [ ] Cursor AI accessible via `which cursor` command
- [ ] Desktop shortcut created
- [ ] Both SSH and RDP connections work simultaneously

---

## Notes

- **VM Specifications:** Ubuntu 22.04.5 LTS
- **Desktop Environment:** MATE (lightweight, good for remote access)
- **Remote Access:** XRDP on port 3389
- **Development Environment:** Cursor AI installed
- **Security:** SSH key authentication + password for RDP

This setup provides a complete development environment with GUI access via Remote Desktop and command-line access via SSH.
