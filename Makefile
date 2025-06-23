# Makefile for Python Project Management
# Usage: make <target>

.PHONY: help install run test clean format lint setup venv

# Default target
help:
	@echo "Available commands:"
	@echo "  make install    - Install dependencies"
	@echo "  make run        - Run the application"
	@echo "  make test       - Run tests"
	@echo "  make format     - Format code with black"
	@echo "  make lint       - Lint code with flake8"
	@echo "  make clean      - Clean up generated files"
	@echo "  make venv       - Create virtual environment"
	@echo "  make setup      - Full project setup"
	@echo "  make jupyter    - Start Jupyter notebook"

# Check if virtual environment exists
check-venv:
	@if [ ! -d "venv" ]; then \
		echo "Virtual environment not found. Run 'make venv' first."; \
		exit 1; \
	fi

# Create virtual environment
venv:
	@echo "Creating virtual environment..."
	python3 -m venv venv
	@echo "Virtual environment created. Activate with: source venv/bin/activate"

# Install dependencies
install: check-venv
	@echo "Installing dependencies..."
	. venv/bin/activate && pip install --upgrade pip
	. venv/bin/activate && pip install -r requirements.txt
	@echo "Dependencies installed successfully!"

# Run the application
run: check-venv
	@echo "Running application..."
	. venv/bin/activate && python main.py

# Run tests
test: check-venv
	@echo "Running tests..."
	. venv/bin/activate && python -m pytest -v

# Format code with black
format: check-venv
	@echo "Formatting code with black..."
	. venv/bin/activate && black .

# Lint code with flake8
lint: check-venv
	@echo "Linting code with flake8..."
	. venv/bin/activate && flake8 .

# Clean up generated files
clean:
	@echo "Cleaning up generated files..."
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".coverage" -delete
	find . -type f -name "*.log" -delete
	@echo "Cleanup complete!"

# Full project setup
setup: venv install
	@echo "Project setup complete!"
	@echo "Next steps:"
	@echo "  1. source venv/bin/activate"
	@echo "  2. make run"
	@echo "  3. Edit .env file with your configuration"

# Start Jupyter notebook
jupyter: check-venv
	@echo "Starting Jupyter notebook..."
	. venv/bin/activate && jupyter notebook

# Install optional data science packages
install-ds: check-venv
	@echo "Installing data science packages..."
	. venv/bin/activate && pip install pandas numpy matplotlib seaborn jupyter ipykernel
	@echo "Data science packages installed!"

# Install optional database packages
install-db: check-venv
	@echo "Installing database packages..."
	. venv/bin/activate && pip install sqlalchemy psycopg2-binary
	@echo "Database packages installed!"

# Install optional API packages
install-api: check-venv
	@echo "Installing API packages..."
	. venv/bin/activate && pip install requests fastapi uvicorn
	@echo "API packages installed!"

# Install all optional packages
install-all: install-ds install-db install-api
	@echo "All optional packages installed!"

# Show project info
info:
	@echo "Project Information:"
	@echo "  Python version: $(shell python3 --version)"
	@echo "  Virtual environment: $(shell if [ -d "venv" ]; then echo "Yes"; else echo "No"; fi)"
	@echo "  Dependencies: $(shell if [ -f "requirements.txt" ]; then echo "Yes"; else echo "No"; fi)"
	@echo "  Main file: $(shell if [ -f "main.py" ]; then echo "Yes"; else echo "No"; fi)" 