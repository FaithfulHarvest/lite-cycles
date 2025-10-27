#!/usr/bin/env python3
"""
Installation and Setup Instructions for Lite Cycles Game

Before running the game, you need to install pygame:

Option 1 (Recommended): Using pip with virtual environment
    python3 -m venv game_env
    source game_env/bin/activate
    pip install pygame==2.5.2
    python tron_light_cycles.py

Option 2: Using system package manager (Ubuntu/Debian)
    sudo apt install python3-pygame
    python3 tron_light_cycles.py

Option 3: Using pipx
    sudo apt install pipx
    pipx install pygame
    python3 tron_light_cycles.py

Option 4: Force install (not recommended)
    pip3 install --break-system-packages pygame==2.5.2
    python3 tron_light_cycles.py
"""

import sys

def check_pygame():
    """Check if pygame is available."""
    try:
        import pygame
        print(f"✅ Pygame is available! Version: {pygame.version.ver}")
        return True
    except ImportError:
        print("❌ Pygame is not installed.")
        print("\nPlease install pygame using one of the methods above.")
        return False

def main():
    """Check pygame availability and provide instructions."""
    print("Lite Cycles - Installation Check")
    print("=" * 40)
    
    if check_pygame():
        print("\n🎮 Ready to play! Run: python3 tron_light_cycles.py")
    else:
        print("\n📋 Installation Instructions:")
        print(__doc__)

if __name__ == "__main__":
    main()
