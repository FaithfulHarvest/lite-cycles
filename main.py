#!/usr/bin/env python3
"""
Main application entry point.
This is a clean, minimal Python application template.
"""

import os
import logging
from datetime import datetime
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)


def main():
    """Main application function."""
    logger.info("Starting application...")
    
    # Get configuration from environment variables
    app_name = os.getenv('APP_NAME', 'Clean Python Template')
    debug_mode = os.getenv('DEBUG', 'False').lower() == 'true'
    
    logger.info(f"Application: {app_name}")
    logger.info(f"Debug mode: {debug_mode}")
    logger.info(f"Current time: {datetime.now()}")
    
    # Your application logic goes here
    logger.info("Application started successfully!")
    
    return 0


if __name__ == "__main__":
    exit(main()) 