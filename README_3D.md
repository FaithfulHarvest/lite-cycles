# TRON 3D - Ultimate Light Cycles

A modern 3D implementation of the classic TRON Light Cycle game, built with Python and modern OpenGL libraries.

## 🎮 Features

### 3D Graphics & Rendering
- **Full 3D Environment**: Complete 3D arena with floor, walls, and atmospheric effects
- **Modern Lighting**: Dynamic lighting system with multiple light sources and neon glow effects
- **Particle Systems**: Advanced particle effects for trails, explosions, and atmospheric elements
- **Smooth Camera**: Intelligent camera that follows the action with smooth interpolation

### Gameplay
- **Two Player Mode**: Local multiplayer with separate controls
- **AI Opponent**: Advanced AI with improved decision-making and collision avoidance
- **3D Light Cycles**: Detailed 3D motorcycle models with animations and effects
- **Collision Detection**: Precise 3D collision detection for trails and walls
- **Modern Controls**: Responsive controls adapted for 3D movement

### Visual Effects
- **Neon Aesthetics**: Authentic TRON-style neon colors and glow effects
- **Trail Effects**: Glowing particle trails that fade over time
- **Explosion Effects**: Particle explosions when cycles crash
- **Dynamic Lighting**: Multiple light sources with realistic attenuation
- **Bloom Effects**: Enhanced neon glow with rim lighting

## 🚀 Quick Start

### Option 1: Easy Launcher (Recommended)
```bash
python launch_3d.py
```

The launcher will automatically:
- Check for required dependencies
- Install missing packages
- Launch the best available 3D version

### Option 2: Manual Installation
```bash
# Install dependencies
pip install -r requirements.txt

# Run the ultimate 3D version
python tron_3d_ultimate.py
```

## 🎯 Controls

### Player 1 (Blue Cycle)
- **Arrow Keys**: Movement (Up, Down, Left, Right)
- **F**: Toggle Fullscreen
- **ESC**: Exit Game

### Player 2 (Orange Cycle)
- **WASD**: Movement (W=Up, S=Down, A=Left, D=Right)

### Game Controls
- **1**: Two Player Mode
- **2**: AI Opponent Mode
- **R**: Restart Game (Game Over screen)
- **M**: Main Menu (Game Over screen)

## 📁 File Structure

```
game1/
├── launch_3d.py              # Easy launcher script
├── tron_3d_ultimate.py       # Ultimate 3D version (recommended)
├── tron_3d_enhanced.py       # Enhanced 3D version
├── tron_3d.py                # Basic 3D version
├── lite_cycles.py            # Original 2D version (backed up)
├── requirements.txt          # Updated with 3D dependencies
└── backup_python_version_*/  # Backup of original 2D version
```

## 🔧 Technical Details

### Dependencies
- **ModernGL**: Modern OpenGL wrapper for Python
- **moderngl-window**: Window management and context creation
- **PyOpenGL**: OpenGL bindings
- **NumPy**: Numerical computations
- **Pyrr**: 3D math library (matrices, vectors)
- **GLFW**: Window management

### Architecture
- **Modular Design**: Separate classes for Camera, LightCycle, ParticleSystem, etc.
- **Modern OpenGL**: Uses OpenGL 3.3+ with shaders
- **Efficient Rendering**: Optimized geometry and particle systems
- **Smooth Animation**: 60 FPS with smooth interpolation

### 3D Features
- **Perspective Camera**: 3D perspective projection with configurable FOV
- **Multiple Light Sources**: Dynamic lighting with realistic attenuation
- **Particle Systems**: GPU-accelerated particle effects
- **3D Collision Detection**: Precise collision detection in 3D space
- **Smooth Following**: Camera smoothly follows the action

## 🎨 Visual Enhancements

### Lighting System
- **Multiple Light Sources**: 5 dynamic lights positioned around the arena
- **Neon Glow**: Rim lighting effects for authentic TRON aesthetics
- **Pulsing Effects**: Dynamic pulsing for enhanced visual appeal
- **Realistic Attenuation**: Distance-based light falloff

### Particle Effects
- **Trail Particles**: Glowing particles that follow the cycles
- **Explosion Effects**: Particle explosions on collision
- **Circular Particles**: Proper circular particle rendering
- **Fade Effects**: Particles fade out over time

### 3D Models
- **Light Cycles**: Detailed 3D motorcycle models
- **Arena**: Complete 3D environment with floor and walls
- **Animations**: Bob animation for cycles
- **Proper Scaling**: Realistic proportions and scaling

## 🔄 Version Comparison

### tron_3d_ultimate.py (Recommended)
- ✅ Complete 3D environment with walls
- ✅ Advanced particle systems
- ✅ Multiple light sources
- ✅ Smooth camera following
- ✅ Explosion effects
- ✅ Advanced AI

### tron_3d_enhanced.py
- ✅ Basic 3D environment
- ✅ Particle trails
- ✅ Simple lighting
- ✅ Basic camera
- ✅ Improved AI

### tron_3d.py
- ✅ Basic 3D structure
- ✅ Simple rendering
- ✅ Basic camera
- ✅ Foundation for 3D

## 🐛 Troubleshooting

### Common Issues

**"ModuleNotFoundError: No module named 'moderngl'"**
```bash
pip install -r requirements.txt
```

**"OpenGL context creation failed"**
- Update your graphics drivers
- Ensure your system supports OpenGL 3.3+

**"Game runs slowly"**
- Close other applications
- Try the basic version: `python tron_3d.py`

**"Controls not responding"**
- Ensure the game window has focus
- Try clicking on the game window

### System Requirements
- **Python**: 3.8+
- **OpenGL**: 3.3+ support
- **Graphics**: Modern graphics card recommended
- **RAM**: 4GB+ recommended
- **OS**: Windows, macOS, or Linux

## 🎉 What's New in 3D

### From 2D to 3D Transformation
1. **3D Environment**: Complete 3D arena instead of flat 2D grid
2. **3D Models**: Actual 3D light cycle models instead of 2D sprites
3. **3D Movement**: Full 3D movement and collision detection
4. **3D Camera**: Perspective camera with smooth following
5. **3D Lighting**: Multiple light sources with realistic effects
6. **3D Particles**: Particle systems with depth and 3D positioning
7. **3D Audio**: Spatial audio positioning (foundation laid)

### Modern Gaming Features
- **60 FPS**: Smooth 60 FPS rendering
- **Modern Graphics**: OpenGL 3.3+ with shaders
- **Particle Effects**: GPU-accelerated particle systems
- **Dynamic Lighting**: Real-time lighting calculations
- **Smooth Animation**: Interpolated movement and camera following
- **Responsive Controls**: Immediate input response

## 🔮 Future Enhancements

- **3D Models**: Import actual 3D motorcycle models
- **Textures**: Add textures to cycles and environment
- **Shadows**: Real-time shadow mapping
- **Post-Processing**: Bloom, HDR, and other effects
- **Sound**: 3D spatial audio
- **Multiplayer**: Network multiplayer support
- **VR Support**: Virtual Reality compatibility

## 📝 Credits

- **Original 2D Game**: Based on the classic TRON Light Cycle concept
- **3D Implementation**: Modern 3D graphics and effects
- **Libraries**: ModernGL, PyOpenGL, NumPy, Pyrr
- **Inspiration**: TRON (1982) and TRON: Legacy (2010)

---

**Enjoy the ultimate 3D TRON Light Cycle experience!** 🏍️💨

