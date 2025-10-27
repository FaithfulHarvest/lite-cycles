# Lite Cycles Game

A 2D light cycle game built with Python and Pygame.

## 🎮 Game Description

Two players ride glowing light cycles that leave colored trails behind them. If a cycle collides with a trail (including its own) or the wall, that player loses. The last player remaining wins the round.

## 🚀 Quick Start

1. **Install pygame** (choose one method):
   ```bash
   # Option 1: Virtual environment (recommended)
   python3 -m venv game_env
   source game_env/bin/activate
   pip install pygame==2.5.2
   
   # Option 2: System package manager
   sudo apt install python3-pygame
   
   # Option 3: Using pipx
   sudo apt install pipx
   pipx install pygame
   ```

2. **Run the game**:
   ```bash
   python3 lite_cycles.py
   ```

3. **Check installation** (optional):
   ```bash
   python3 setup_check.py
   ```

## 🎯 Game Features

- **Neon Aesthetic**: Dark background with bright glowing trails
- **Two Game Modes**:
  - Two Player Mode: Player 1 (Arrow Keys) vs Player 2 (WASD)
  - AI Opponent Mode: Player 1 (Arrow Keys) vs AI
- **Grid-based Movement**: Each frame moves the cycle one unit forward
- **Collision Detection**: Crash on walls or any trail
- **Visual Effects**: Glowing trails with fade effects
- **Sound Effects**: Crash sounds and background hum
- **Game States**: Menu, Playing, Game Over with restart options

## 🎮 Controls

### Player 1 (Blue Cycle)
- ↑ Arrow: Move Up
- ↓ Arrow: Move Down  
- ← Arrow: Move Left
- → Arrow: Move Right

### Player 2 (Orange Cycle)
- W: Move Up
- S: Move Down
- A: Move Left
- D: Move Right

### Game Controls
- **1**: Two Player Mode
- **2**: AI Opponent Mode
- **R**: Restart Game (after game over)
- **M**: Main Menu (after game over)
- **ESC**: Exit Game

## 🎨 Visual Style

- **Background**: Deep black with subtle grid lines
- **Player 1**: Neon blue (#00FFFF)
- **Player 2**: Neon orange (#FF8000)
- **Trails**: Glowing with fade effects
- **UI**: Clean neon aesthetic with "Lite Cycles" title

## 🤖 AI Opponent

The AI opponent uses a simple strategy:
- Avoids walls and trails
- Prefers current direction if safe
- Makes random decisions when multiple safe options exist
- Calculates distances to walls for optimal positioning

## 🔧 Customization

The game is easily modifiable. Key constants in `lite_cycles.py`:

```python
WINDOW_WIDTH = 1000      # Game window width
WINDOW_HEIGHT = 700      # Game window height
GRID_SIZE = 10           # Size of grid cells
FPS = 60                 # Frames per second
NEON_BLUE = (0, 255, 255)    # Player 1 color
NEON_ORANGE = (255, 128, 0)  # Player 2 color
```

## 🎵 Sound Effects

- **Crash Sound**: Generated noise burst when players crash
- **Background Hum**: Low-frequency sine wave for atmosphere
- Sound effects are optional and will work without audio if pygame sound fails

## 🏆 Game Rules

1. Players start on opposite sides of the screen
2. Light cycles move continuously in their current direction
3. Players can change direction (but not reverse 180°)
4. Collision with any trail or wall results in crash
5. Last player standing wins the round
6. Game supports ties when both players crash simultaneously

## 🐛 Troubleshooting

If you encounter issues:

1. **Pygame not found**: Run `python3 setup_check.py` for installation help
2. **Sound issues**: Game will work without sound effects
3. **Performance issues**: Reduce FPS or increase GRID_SIZE
4. **Display issues**: Check your pygame installation

## 📁 Files

- `lite_cycles.py`: Main game file
- `setup_check.py`: Installation verification script
- `requirements.txt`: Python dependencies
- `README.md`: This documentation

Enjoy the game! 🎮
