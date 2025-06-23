#!/bin/bash

# Clean Python Project Setup Script
# This script automates the creation of new Python projects from this template

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show progress
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    
    printf "\r["
    printf "%${completed}s" | tr ' ' '#'
    printf "%${remaining}s" | tr ' ' '-'
    printf "] %d%%" $percentage
}

# Check if project name is provided
if [ $# -eq 0 ]; then
    print_error "Usage: $0 <project-name> [template-path]"
    echo "Example: $0 my-new-project"
    echo "Example: $0 my-new-project /path/to/template"
    exit 1
fi

PROJECT_NAME=$1
TEMPLATE_PATH=${2:-$(pwd)}

# Validate project name
if [[ ! $PROJECT_NAME =~ ^[a-zA-Z0-9_-]+$ ]]; then
    print_error "Project name must contain only letters, numbers, hyphens, and underscores"
    exit 1
fi

# Check if project directory already exists
if [ -d "$PROJECT_NAME" ]; then
    print_error "Directory '$PROJECT_NAME' already exists"
    exit 1
fi

print_status "Setting up project: $PROJECT_NAME"

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed. Please install Python 3 first."
    print_status "For Ubuntu/Debian: sudo apt install python3 python3-pip python3-venv"
    print_status "For CentOS/RHEL: sudo dnf install python3 python3-pip python3-venv"
    exit 1
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    print_error "pip3 is not installed. Please install pip3 first."
    exit 1
fi

print_status "Python 3 version: $(python3 --version)"
print_status "pip3 version: $(pip3 --version)"

# Create project directory
print_status "Creating project directory..."
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize git repository
print_status "Initializing git repository..."
git init

# Copy template files with progress
print_status "Copying template files..."
files_to_copy=(
    ".gitignore"
    "requirements.txt"
    "main.py"
    "app.log"
    "analysis.ipynb"
    "setup_guide.md"
    "README.md"
    "Makefile"
    "docker-compose.yml"
    "Dockerfile"
)

total_files=${#files_to_copy[@]}
for i in "${!files_to_copy[@]}"; do
    file="${files_to_copy[$i]}"
    if [ -f "$TEMPLATE_PATH/$file" ]; then
        cp "$TEMPLATE_PATH/$file" .
        show_progress $((i + 1)) $total_files
    else
        print_warning "Template file $file not found, skipping..."
    fi
done
echo ""  # New line after progress bar

# Create virtual environment
print_status "Creating virtual environment..."
python3 -m venv venv

# Activate virtual environment
print_status "Activating virtual environment..."
source venv/bin/activate

# Upgrade pip with progress
print_status "Upgrading pip..."
pip install --upgrade pip > /dev/null 2>&1

# Install dependencies with progress
print_status "Installing dependencies..."
pip install -r requirements.txt > /dev/null 2>&1

# Create .env file
print_status "Creating .env file..."
cat > .env << EOF
APP_NAME=$PROJECT_NAME
DEBUG=True
DATABASE_URL=sqlite:///app.db
SECRET_KEY=your-secret-key-here
POSTGRES_DB=pythonapp
POSTGRES_USER=pythonuser
POSTGRES_PASSWORD=pythonpass
REDIS_URL=redis://localhost:6379
EOF

# Create additional directories
print_status "Creating project directories..."
mkdir -p data output logs

# Test the setup
print_status "Testing the setup..."
if python main.py > /dev/null 2>&1; then
    print_success "Application runs successfully!"
else
    print_warning "Application test failed (this might be expected for a template)"
fi

# Initial git commit
print_status "Making initial git commit..."
git add . > /dev/null 2>&1
git commit -m "Initial project setup from template" > /dev/null 2>&1

print_success "Project '$PROJECT_NAME' setup complete!"
echo ""
print_status "Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. source venv/bin/activate"
echo "3. python main.py"
echo "4. Edit .env file with your configuration"
echo "5. Start coding!"
echo ""
print_status "Available commands:"
echo "- make help          # Show all available make commands"
echo "- make run           # Run the application"
echo "- make test          # Run tests"
echo "- make format        # Format code"
echo "- make lint          # Lint code"
echo "- make jupyter       # Start Jupyter notebook"
echo "- docker-compose up  # Start containerized environment"
echo ""
print_status "Remember to:"
echo "- Update the README.md with your project details"
echo "- Modify requirements.txt as needed"
echo "- Add your remote repository: git remote add origin <your-repo-url>"
echo "- Push to remote: git push -u origin main" 