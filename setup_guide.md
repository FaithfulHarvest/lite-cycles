# Python Project Setup Guide

This guide provides a repeatable process for setting up new Python projects on a fresh Linux system.

## Prerequisites

Before starting, ensure you have:
- A fresh Linux installation
- Git CLI installed
- Internet connection

## Step 1: Install Python and pip

### Ubuntu/Debian:
```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv
```

### CentOS/RHEL/Fedora:
```bash
sudo dnf install python3 python3-pip python3-venv
# or for older versions: sudo yum install python3 python3-pip python3-venv
```

### Verify installation:
```bash
python3 --version
pip3 --version
```

## Step 2: Set up Python path (if needed)

Most modern Linux distributions automatically add Python to PATH. If you encounter "command not found" errors:

```bash
# Add to ~/.bashrc
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Step 3: Create project directory and initialize git

```bash
# Create project directory
mkdir my-new-project
cd my-new-project

# Initialize git repository
git init
```

## Step 4: Set up virtual environment

```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Verify you're in the virtual environment
which python
which pip
```

## Step 5: Copy template files

Copy these files from the template repository:

1. **`.gitignore`** - Comprehensive Python gitignore
2. **`requirements.txt`** - Dependencies (modify as needed)
3. **`main.py`** - Main application entry point
4. **`app.log`** - Log file
5. **`analysis.ipynb`** - Jupyter notebook template
6. **`setup_guide.md`** - This guide

## Step 6: Install dependencies

```bash
# Make sure virtual environment is activated
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# For development, also install in editable mode if needed
# pip install -e .
```

## Step 7: Test the setup

```bash
# Run the main application
python main.py

# Check if Jupyter works (if using data science packages)
jupyter notebook --version
```

## Step 8: Configure your IDE/Editor

### VS Code:
1. Install Python extension
2. Select the correct Python interpreter (from venv)
3. Install additional extensions as needed:
   - Python Docstring Generator
   - Python Indent
   - Python Type Hint

### PyCharm:
1. Open project
2. Configure interpreter to use venv
3. Install plugins as needed

## Step 9: Initial commit

```bash
# Add all files
git add .

# Initial commit
git commit -m "Initial project setup"

# Add remote repository (if using GitHub/GitLab)
git remote add origin <your-repo-url>
git branch -M main
git push -u origin main
```

## Environment Variables

Create a `.env` file for environment-specific configuration:

```bash
# .env
APP_NAME=My New Project
DEBUG=True
DATABASE_URL=sqlite:///app.db
SECRET_KEY=your-secret-key-here
```

## Project Structure

Your project should look like this:

```
my-new-project/
├── .gitignore
├── .env                    # Environment variables (not in git)
├── requirements.txt
├── main.py
├── app.log
├── analysis.ipynb
├── setup_guide.md
├── venv/                  # Virtual environment (not in git)
├── data/                  # Data files (not in git)
├── output/                # Output files (not in git)
└── logs/                  # Log files (not in git)
```

## Common Issues and Solutions

### Issue: "python3: command not found"
**Solution:** Install Python 3 using your package manager

### Issue: "pip: command not found"
**Solution:** Install pip separately or use `python3 -m pip`

### Issue: Virtual environment not activating
**Solution:** Check if venv is created properly and use `source venv/bin/activate`

### Issue: Permission denied when installing packages
**Solution:** Make sure you're in the virtual environment, not using system pip

### Issue: Jupyter not found
**Solution:** Install jupyter in your virtual environment: `pip install jupyter ipykernel`

## Best Practices

1. **Always use virtual environments** - Never install packages globally
2. **Pin your dependencies** - Use specific versions in requirements.txt
3. **Use .env files** - Keep configuration separate from code
4. **Regular commits** - Commit early and often
5. **Document your setup** - Keep this guide updated for your specific needs
6. **Use linting** - Install and configure flake8, black, or other linters
7. **Write tests** - Include pytest and write unit tests

## Customization

### For Web Development:
```bash
pip install flask django fastapi
```

### For Data Science:
```bash
pip install pandas numpy matplotlib seaborn jupyter
```

### For Machine Learning:
```bash
pip install scikit-learn tensorflow torch
```

### For API Development:
```bash
pip install fastapi uvicorn requests
```

## Automation Script

You can create a setup script to automate this process:

```bash
#!/bin/bash
# setup_project.sh

PROJECT_NAME=$1
if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: ./setup_project.sh <project-name>"
    exit 1
fi

mkdir $PROJECT_NAME
cd $PROJECT_NAME
git init
python3 -m venv venv
source venv/bin/activate
# Copy template files here
pip install -r requirements.txt
echo "Project $PROJECT_NAME setup complete!"
```

## Notes for Next Time

- This template provides a minimal, clean starting point
- Modify requirements.txt based on your specific needs
- Update .gitignore if you add new file types
- Consider using poetry or pipenv for more complex dependency management
- For production deployments, consider using Docker
- Always test your setup on a fresh system to ensure it's truly repeatable

## Troubleshooting

If you encounter issues:

1. Check Python and pip versions
2. Ensure virtual environment is activated
3. Verify all dependencies are installed
4. Check file permissions
5. Review error messages carefully
6. Consult Python and package documentation

## Additional Resources

- [Python Virtual Environments](https://docs.python.org/3/tutorial/venv.html)
- [pip User Guide](https://pip.pypa.io/en/stable/user_guide/)
- [Git Documentation](https://git-scm.com/doc)
- [VS Code Python](https://code.visualstudio.com/docs/languages/python)
- [Jupyter Documentation](https://jupyter.org/documentation) 