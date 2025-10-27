#!/usr/bin/env python3
"""
Lite Cycles Game
A 2D light cycle game using Python and Pygame.

Two players ride glowing light cycles that leave colored trails behind them.
If a cycle collides with a trail (including its own) or the wall, that player loses.
The last player remaining wins the round.
"""

import pygame
import random
import math
import sys
from typing import List, Tuple, Optional

# Initialize Pygame
pygame.init()

# Constants
WINDOW_WIDTH = 1400
WINDOW_HEIGHT = 900
GRID_SIZE = 20  # Proper grid size for TRON-like gameplay
FPS = 60  # Higher FPS for faster, more responsive gameplay

# Colors (Neon Tron aesthetic)
BLACK = (0, 0, 0)
DARK_GRAY = (20, 20, 20)
NEON_BLUE = (0, 255, 255)
NEON_ORANGE = (255, 128, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)

# Game states
MENU = 0
PLAYING = 1
GAME_OVER = 2

class Player:
    """Represents a light cycle player with position, direction, and trail."""
    
    def __init__(self, x: int, y: int, color: Tuple[int, int, int], 
                 controls: dict, name: str = "Player"):
        self.x = x
        self.y = y
        self.color = color
        self.controls = controls
        self.name = name
        self.direction = (1, 0)  # Moving right initially
        self.trail = [(x, y)]  # List of (x, y) positions
        self.alive = True
        self.speed = GRID_SIZE
        
    def move(self) -> None:
        """Move the player in the current direction."""
        if not self.alive:
            return
            
        # Move at optimal TRON speed - 1.5x grid cells per frame
        move_distance = GRID_SIZE * 1.5  # Slightly slower than before
        self.x += self.direction[0] * move_distance
        self.y += self.direction[1] * move_distance
        
        # Add current position to trail
        self.trail.append((self.x, self.y))
        
        # Limit trail length to prevent memory issues (keep last 1000 positions)
        if len(self.trail) > 1000:
            self.trail = self.trail[-1000:]
        
    def change_direction(self, new_direction: Tuple[int, int]) -> None:
        """Change the player's direction (prevents 180-degree turns)."""
        if not self.alive:
            return
            
        # Prevent reversing into own trail
        opposite_direction = (-self.direction[0], -self.direction[1])
        if new_direction != opposite_direction:
            self.direction = new_direction
            
    def check_collision(self, other_player: 'Player', walls: List[Tuple[int, int]], screen_width: int, screen_height: int) -> bool:
        """Check if player collides with walls, own trail, or other player's trail."""
        if not self.alive:
            return False
            
        # Check wall collision
        if (self.x < 0 or self.x >= screen_width or 
            self.y < 0 or self.y >= screen_height):
            return True
            
        # Check collision with own trail (except the head)
        if len(self.trail) > 1:
            for i, (trail_x, trail_y) in enumerate(self.trail[:-1]):
                # Check if we're within one grid cell of the trail
                if abs(self.x - trail_x) < GRID_SIZE and abs(self.y - trail_y) < GRID_SIZE:
                    return True
                    
        # Check collision with other player's trail
        for trail_x, trail_y in other_player.trail:
            # Check if we're within one grid cell of the trail
            if abs(self.x - trail_x) < GRID_SIZE and abs(self.y - trail_y) < GRID_SIZE:
                return True
                
        return False
        
    def crash(self) -> None:
        """Handle player crash."""
        self.alive = False

class AIPlayer(Player):
    """AI opponent that tries to avoid walls and trails."""
    
    def __init__(self, x: int, y: int, color: Tuple[int, int, int], name: str = "AI"):
        super().__init__(x, y, color, {}, name)
        self.direction = (-1, 0)  # Moving left initially
        self.last_decision_time = 0
        self.decision_interval = 100  # milliseconds between decisions - responsive AI
        
    def make_decision(self, other_player: Player, walls: List[Tuple[int, int]], screen_width: int, screen_height: int) -> None:
        """Make AI decision for movement direction."""
        if not self.alive:
            return
            
        # Simple AI that always tries to avoid collision
        directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]
        
        # Remove opposite direction to prevent 180-degree turns
        opposite_direction = (-self.direction[0], -self.direction[1])
        if opposite_direction in directions:
            directions.remove(opposite_direction)
            
        # Find safe directions
        safe_directions = []
        for direction in directions:
            move_distance = GRID_SIZE * 1.5  # Match the movement distance
            test_x = self.x + direction[0] * move_distance
            test_y = self.y + direction[1] * move_distance
            
            # Check walls
            if test_x < 0 or test_x >= screen_width or test_y < 0 or test_y >= screen_height:
                continue
                
            # Check own trail
            safe = True
            for trail_x, trail_y in self.trail[:-1]:
                if abs(test_x - trail_x) < GRID_SIZE and abs(test_y - trail_y) < GRID_SIZE:
                    safe = False
                    break
                    
            # Check opponent trail
            if safe:
                for trail_x, trail_y in other_player.trail:
                    if abs(test_x - trail_x) < GRID_SIZE and abs(test_y - trail_y) < GRID_SIZE:
                        safe = False
                        break
                        
            if safe:
                safe_directions.append(direction)
                
        # Choose direction - prefer current if safe, otherwise pick any safe direction
        if safe_directions:
            if self.direction in safe_directions:
                new_direction = self.direction
            else:
                new_direction = safe_directions[0]  # Pick first safe direction
        else:
            # No safe directions - pick any direction
            new_direction = directions[0]
            
        self.change_direction(new_direction)

class TronGame:
    """Main game class handling game logic, rendering, and input."""
    
    def __init__(self):
        self.fullscreen = False
        self.screen = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))
        pygame.display.set_caption("Lite Cycles - Press F for Fullscreen")
        self.clock = pygame.time.Clock()
        self.font = pygame.font.Font(None, 72)  # Increased for better fullscreen visibility
        self.title_font = pygame.font.Font(None, 144)  # Much larger title for fullscreen
        self.small_font = pygame.font.Font(None, 48)  # Larger small text for fullscreen
        
        # Game state
        self.state = MENU
        self.game_over_timer = 0
        self.winner = None
        
        # Players
        self.player1 = None
        self.player2 = None
        self.ai_mode = False
        
        # Input queue for responsive controls
        self.input_queue = []
        
        # Sound effects (optional)
        self.sounds = {}
        try:
            # Create simple sound effects using pygame's sound generation
            self.sounds['crash'] = self.create_crash_sound()
            self.sounds['background'] = self.create_background_hum()
        except:
            # If sound creation fails, continue without sound
            self.sounds = {}
            
    def toggle_fullscreen(self) -> None:
        """Toggle between fullscreen and windowed mode."""
        self.fullscreen = not self.fullscreen
        if self.fullscreen:
            self.screen = pygame.display.set_mode((0, 0), pygame.FULLSCREEN)
            pygame.display.set_caption("Lite Cycles - Press F to Exit Fullscreen")
        else:
            self.screen = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))
            pygame.display.set_caption("Lite Cycles - Press F for Fullscreen")
            
    def create_crash_sound(self) -> pygame.mixer.Sound:
        """Create a simple crash sound effect."""
        try:
            # Generate a short burst of noise
            sample_rate = 22050
            duration = 0.3
            frames = int(duration * sample_rate)
            arr = []
            for i in range(frames):
                arr.append([int(32767 * random.random() * (1 - i/frames)) for _ in range(2)])
            sound = pygame.sndarray.make_sound(pygame.array.array('i', arr))
            return sound
        except:
            return None
            
    def create_background_hum(self) -> pygame.mixer.Sound:
        """Create a background hum sound."""
        try:
            # Generate a low-frequency hum
            sample_rate = 22050
            duration = 2.0
            frames = int(duration * sample_rate)
            arr = []
            for i in range(frames):
                # Low frequency sine wave
                frequency = 60  # Hz
                amplitude = 1000
                sample = int(amplitude * math.sin(2 * math.pi * frequency * i / sample_rate))
                arr.append([sample, sample])
            sound = pygame.sndarray.make_sound(pygame.array.array('i', arr))
            return sound
        except:
            return None
            
    def reset_game(self) -> None:
        """Reset the game to initial state."""
        # Get current screen dimensions
        screen_width, screen_height = self.screen.get_size()
        
        # Calculate grid-aligned starting positions
        grid_cols = screen_width // GRID_SIZE
        grid_rows = screen_height // GRID_SIZE
        
        # Player 1 (blue) starts from left side, grid-aligned
        player1_x = (grid_cols // 4) * GRID_SIZE
        player1_y = (grid_rows // 2) * GRID_SIZE
        
        self.player1 = Player(
            player1_x, 
            player1_y, 
            NEON_BLUE,
            {
                pygame.K_UP: (0, -1),
                pygame.K_DOWN: (0, 1),
                pygame.K_LEFT: (-1, 0),
                pygame.K_RIGHT: (1, 0)
            },
            "Player 1"
        )
        
        if self.ai_mode:
            # AI opponent (orange) starts from right side, grid-aligned
            player2_x = (3 * grid_cols // 4) * GRID_SIZE
            player2_y = (grid_rows // 2) * GRID_SIZE
            
            self.player2 = AIPlayer(
                player2_x,
                player2_y,
                NEON_ORANGE,
                "AI"
            )
        else:
            # Player 2 (orange) starts from right side, grid-aligned
            player2_x = (3 * grid_cols // 4) * GRID_SIZE
            player2_y = (grid_rows // 2) * GRID_SIZE
            
            self.player2 = Player(
                player2_x,
                player2_y,
                NEON_ORANGE,
                {
                    pygame.K_w: (0, -1),
                    pygame.K_s: (0, 1),
                    pygame.K_a: (-1, 0),
                    pygame.K_d: (1, 0)
                },
                "Player 2"
            )
            
        self.state = PLAYING
        self.game_over_timer = 0
        self.winner = None
        
        # Clear input queue for fresh start
        self.input_queue.clear()
        
    def handle_input(self) -> None:
        """Handle keyboard input."""
        keys = pygame.key.get_pressed()
        
        # Handle continuous key presses for movement
        if self.state == PLAYING:
            # Player 1 controls
            for key, direction in self.player1.controls.items():
                if keys[key]:
                    self.player1.change_direction(direction)
                    
            # Player 2 controls (if not AI)
            if not self.ai_mode:
                for key, direction in self.player2.controls.items():
                    if keys[key]:
                        self.player2.change_direction(direction)
                        
                
    def process_input_queue(self) -> None:
        """Process queued input events for immediate responsiveness."""
        while self.input_queue and self.state == PLAYING:
            key = self.input_queue.pop(0)
            
            # Player 1 controls
            if key in self.player1.controls:
                self.player1.change_direction(self.player1.controls[key])
                
            # Player 2 controls (if not AI)
            if not self.ai_mode and key in self.player2.controls:
                self.player2.change_direction(self.player2.controls[key])
                
    def handle_key_event(self, key) -> None:
        """Handle single key press events."""
        if key == pygame.K_f:
            self.toggle_fullscreen()
        elif key == pygame.K_ESCAPE:
            pygame.quit()
            sys.exit()
            
        if self.state == MENU:
            if key == pygame.K_1:
                self.ai_mode = False
                self.reset_game()
            elif key == pygame.K_2:
                self.ai_mode = True
                self.reset_game()
                
        elif self.state == GAME_OVER:
            if key == pygame.K_r:
                self.reset_game()
            elif key == pygame.K_m:
                self.state = MENU
                
        elif self.state == PLAYING:
            # Queue movement keys for immediate processing
            if (key in [pygame.K_UP, pygame.K_DOWN, pygame.K_LEFT, pygame.K_RIGHT] or
                key in [pygame.K_w, pygame.K_s, pygame.K_a, pygame.K_d]):
                self.input_queue.append(key)
                
    def update(self) -> None:
        """Update game logic."""
        if self.state != PLAYING:
            return
            
        # Process input queue for immediate responsiveness
        self.process_input_queue()
        
        # AI decision making
        if self.ai_mode and isinstance(self.player2, AIPlayer):
            screen_width, screen_height = self.screen.get_size()
            self.player2.make_decision(self.player1, [], screen_width, screen_height)
            
        # Get current screen dimensions
        screen_width, screen_height = self.screen.get_size()
            
        # Move players
        self.player1.move()
        self.player2.move()
        
        # Check collisions
        if self.player1.check_collision(self.player2, [], screen_width, screen_height):
            self.player1.crash()
            if self.sounds.get('crash'):
                self.sounds['crash'].play()
                
        if self.player2.check_collision(self.player1, [], screen_width, screen_height):
            self.player2.crash()
            if self.sounds.get('crash'):
                self.sounds['crash'].play()
                
        # Check for game over
        if not self.player1.alive or not self.player2.alive:
            self.state = GAME_OVER
            self.game_over_timer = pygame.time.get_ticks()
            
            if not self.player1.alive and not self.player2.alive:
                self.winner = "Tie"
            elif not self.player1.alive:
                self.winner = self.player2.name
            else:
                self.winner = self.player1.name
                
    def draw_trail(self, trail: List[Tuple[int, int]], color: Tuple[int, int, int]) -> None:
        """Draw a glowing trail with fade effect."""
        for i, (x, y) in enumerate(trail):
            # Calculate alpha based on trail position (newer = brighter)
            alpha = int(255 * (i / len(trail)) if len(trail) > 0 else 255)
            
            # Create a surface for the trail segment
            trail_surface = pygame.Surface((GRID_SIZE, GRID_SIZE))
            trail_surface.set_alpha(alpha)
            trail_surface.fill(color)
            
            # Draw with glow effect
            self.screen.blit(trail_surface, (x, y))
            
            # Add a brighter center
            center_color = tuple(min(255, c + 50) for c in color)
            pygame.draw.rect(self.screen, center_color, 
                           (x + GRID_SIZE//4, y + GRID_SIZE//4, 
                            GRID_SIZE//2, GRID_SIZE//2))
                            
    def draw_player(self, player: Player) -> None:
        """Draw a player with glow effect."""
        if not player.alive:
            return
            
        # Draw trail first
        self.draw_trail(player.trail, player.color)
        
        # Draw player head with glow
        head_rect = pygame.Rect(player.x, player.y, GRID_SIZE, GRID_SIZE)
        
        # Outer glow
        glow_color = tuple(min(255, c + 100) for c in player.color)
        pygame.draw.rect(self.screen, glow_color, head_rect)
        
        # Inner bright core
        core_rect = pygame.Rect(player.x + 2, player.y + 2, GRID_SIZE - 4, GRID_SIZE - 4)
        pygame.draw.rect(self.screen, WHITE, core_rect)
        
    def draw_menu(self) -> None:
        """Draw the main menu."""
        self.screen.fill(BLACK)
        
        # Get screen dimensions
        screen_width, screen_height = self.screen.get_size()
        
        # Title
        title_text = self.title_font.render("LITE CYCLES", True, NEON_BLUE)
        title_rect = title_text.get_rect(center=(screen_width//2, screen_height//4))
        self.screen.blit(title_text, title_rect)
        
        # Instructions
        instructions = [
            "Choose Game Mode:",
            "",
            "1 - Two Player Mode",
            "   Player 1: Arrow Keys",
            "   Player 2: WASD",
            "",
            "2 - AI Opponent Mode",
            "   Player 1: Arrow Keys",
            "   AI: Automatic",
            "",
            "F - Toggle Fullscreen",
            "ESC - Exit Game"
        ]
        
        y_offset = screen_height//3
        for instruction in instructions:
            if instruction.startswith("LITE") or instruction.startswith("Choose"):
                color = NEON_BLUE
                font = self.font
            elif instruction.startswith("1") or instruction.startswith("2"):
                color = NEON_ORANGE
                font = self.font
            else:
                color = WHITE
                font = self.small_font
                
            text = font.render(instruction, True, color)
            text_rect = text.get_rect(center=(screen_width//2, y_offset))
            self.screen.blit(text, text_rect)
            y_offset += 40
            
    def draw_game(self) -> None:
        """Draw the game screen."""
        self.screen.fill(BLACK)
        
        # Get current screen dimensions
        screen_width, screen_height = self.screen.get_size()
        
        # Draw grid lines (subtle) - scale to screen size
        for x in range(0, screen_width, GRID_SIZE * 5):
            pygame.draw.line(self.screen, DARK_GRAY, (x, 0), (x, screen_height))
        for y in range(0, screen_height, GRID_SIZE * 5):
            pygame.draw.line(self.screen, DARK_GRAY, (0, y), (screen_width, y))
            
        # Draw players
        self.draw_player(self.player1)
        self.draw_player(self.player2)
        
        # Draw UI
        player1_text = self.small_font.render(f"{self.player1.name}: {NEON_BLUE}", True, NEON_BLUE)
        player2_text = self.small_font.render(f"{self.player2.name}: {NEON_ORANGE}", True, NEON_ORANGE)
        
        self.screen.blit(player1_text, (10, 10))
        self.screen.blit(player2_text, (10, 40))
        
    def draw_game_over(self) -> None:
        """Draw the game over screen."""
        self.screen.fill(BLACK)
        
        # Get screen dimensions
        screen_width, screen_height = self.screen.get_size()
        
        # Winner announcement
        if self.winner == "Tie":
            winner_text = self.title_font.render("TIE GAME!", True, WHITE)
        else:
            winner_text = self.title_font.render(f"{self.winner} WINS!", True, NEON_BLUE)
            
        winner_rect = winner_text.get_rect(center=(screen_width//2, screen_height//2 - 100))
        self.screen.blit(winner_text, winner_rect)
        
        # Instructions
        instructions = [
            "R - Play Again",
            "M - Main Menu",
            "F - Toggle Fullscreen",
            "ESC - Exit Game"
        ]
        
        y_offset = screen_height//2 + 50
        for instruction in instructions:
            text = self.font.render(instruction, True, WHITE)
            text_rect = text.get_rect(center=(screen_width//2, y_offset))
            self.screen.blit(text, text_rect)
            y_offset += 40
            
    def draw(self) -> None:
        """Main draw method."""
        if self.state == MENU:
            self.draw_menu()
        elif self.state == PLAYING:
            self.draw_game()
        elif self.state == GAME_OVER:
            self.draw_game_over()
            
        pygame.display.flip()
        
    def run(self) -> None:
        """Main game loop."""
        running = True
        
        # Start background sound
        if self.sounds.get('background'):
            self.sounds['background'].play(-1)  # Loop indefinitely
            
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.KEYDOWN:
                    self.handle_key_event(event.key)
                    
            self.handle_input()
            self.update()
            self.draw()
            self.clock.tick(FPS)
            
        pygame.quit()
        sys.exit()

def main():
    """Main function to run the game."""
    game = TronGame()
    game.run()

if __name__ == "__main__":
    main()
