# Clean Python Project Template

A minimal, clean Python project template designed for repeatable setup on fresh Linux systems with Docker support and automation tools.

> **Note:** If you are using this template in Cursor with the AI assistant, the assistant can run commands directly in the background and see the output. This means you do **not** need to copy/paste terminal output back to the assistant for troubleshooting or automation—the assistant will guide you step-by-step and handle errors as they occur.

## Quick Start

### Option 1: Automated Setup (Recommended)
```bash
# Clone this template
git clone <your-template-repo-url>
cd clean-python-template

# Create a new project
./setup_project.sh my-new-project
cd my-new-project

# Run the application
make run
```

### Option 2: Manual Setup
1. **Clone this template:**
   ```bash
   git clone <your-template-repo-url>
   cd clean-python-template
   ```

2. **Set up virtual environment:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the application:**
   ```bash
   python main.py
   ```

## Project Structure

```
clean-python-template/
├── .gitignore          # Comprehensive Python gitignore
├── requirements.txt    # Python dependencies
├── main.py            # Main application entry point
├── app.log            # Application log file
├── analysis.ipynb     # Jupyter notebook template
├── setup_guide.md     # Detailed setup instructions
├── setup_project.sh   # Automated project creation script
├── Makefile           # Common project operations
├── docker-compose.yml # Container orchestration
├── Dockerfile         # Container definition
└── README.md          # This file
```

## Features

- **Minimal and Clean**: No unnecessary files or complexity
- **Repeatable Setup**: Works consistently on fresh Linux systems
- **Virtual Environment**: Proper Python isolation
- **Comprehensive .gitignore**: Covers all common Python artifacts
- **Logging**: Built-in logging configuration
- **Environment Variables**: Support for .env files
- **Jupyter Ready**: Includes comprehensive notebook template for data analysis
- **Docker Support**: Full containerization with docker-compose
- **Automation**: Makefile for common operations
- **Documentation**: Complete setup guide for future reference
- **AI Assistant Integration**: Seamless command execution and troubleshooting in Cursor

## Dependencies

### Core Dependencies
- Flask 3.0.2 - Web framework
- python-dotenv 1.0.0 - Environment variable management

### Development Dependencies
- pytest 7.4.3 - Testing framework
- black 23.11.0 - Code formatting
- flake8 6.1.0 - Linting

### Optional Dependencies (commented in requirements.txt)
- Data science: pandas, numpy, matplotlib, seaborn, jupyter
- Database: sqlalchemy, psycopg2-binary
- API: requests, fastapi, uvicorn

## Usage

### Basic Application
```bash
python main.py
# or
make run
```

### Jupyter Notebook
```bash
jupyter notebook analysis.ipynb
# or
make jupyter
```

### Testing
```bash
pytest
# or
make test
```

### Code Formatting
```bash
black .
# or
make format
```

### Linting
```bash
flake8 .
# or
make lint
```

### Docker Environment
```bash
# Start all services
docker-compose up

# Start specific service
docker-compose up app
docker-compose up jupyter

# Run in background
docker-compose up -d

# Stop services
docker-compose down
```

## Makefile Commands

The included Makefile provides convenient shortcuts for common operations:

```bash
make help          # Show all available commands
make setup         # Full project setup (venv + install)
make install       # Install dependencies
make run           # Run the application
make test          # Run tests
make format        # Format code with black
make lint          # Lint code with flake8
make clean         # Clean up generated files
make jupyter       # Start Jupyter notebook
make install-ds    # Install data science packages
make install-db    # Install database packages
make install-api   # Install API packages
make install-all   # Install all optional packages
make info          # Show project information
```

## Docker Services

The `docker-compose.yml` includes several services:

- **app**: Main Python application (ports 5000, 8000)
- **jupyter**: Jupyter notebook server (port 8888)
- **postgres**: PostgreSQL database (port 5432)
- **redis**: Redis cache (port 6379)

### Docker Quick Start
```bash
# Build and start all services
docker-compose up --build

# Access services
# - App: http://localhost:5000
# - Jupyter: http://localhost:8888
# - PostgreSQL: localhost:5432
# - Redis: localhost:6379
```

## Environment Variables

Create a `.env` file in the project root:

```bash
APP_NAME=My Application
DEBUG=True
DATABASE_URL=sqlite:///app.db
SECRET_KEY=your-secret-key-here
POSTGRES_DB=pythonapp
POSTGRES_USER=pythonuser
POSTGRES_PASSWORD=pythonpass
REDIS_URL=redis://localhost:6379
```

## Jupyter Notebook Template

The `analysis.ipynb` includes:
- Standard data science imports (pandas, numpy, matplotlib, seaborn)
- Plotting configuration
- Sample data generation
- Data exploration examples
- Visualization templates
- Analysis workflow structure

## Customization

1. **Modify requirements.txt** - Add/remove packages as needed
2. **Update main.py** - Replace with your application logic
3. **Customize analysis.ipynb** - Adapt for your data analysis needs
4. **Extend setup_guide.md** - Add project-specific instructions
5. **Modify docker-compose.yml** - Add/remove services as needed
6. **Update Makefile** - Add custom commands for your workflow

## Best Practices

- Always use virtual environments
- Pin dependency versions
- Use environment variables for configuration
- Write tests for your code
- Use linting and formatting tools
- Document your setup process
- Use Docker for consistent environments
- Leverage the Makefile for automation
- Use the AI assistant in Cursor for seamless setup and troubleshooting

## Troubleshooting

See `setup_guide.md` for detailed troubleshooting information and common issues.

> **Note:** When using Cursor, the AI assistant can run commands in the background and see the output directly. You do **not** need to copy/paste terminal output for troubleshooting—the assistant will handle errors and guide you interactively.

### Common Docker Issues
```bash
# If containers won't start
docker-compose down -v
docker-compose up --build

# If ports are already in use
docker-compose down
# Change ports in docker-compose.yml
docker-compose up
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on a fresh system
5. Submit a pull request

## License

This template is provided as-is for educational and development purposes. 