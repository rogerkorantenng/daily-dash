# Daily Dash

A fast-paced vertical endless runner built with GameMaker Studio 2, deployed to Reddit via Devvit.

## Gameplay

Dodge obstacles, collect coins, and complete daily challenges as you dash through an ever-accelerating course.

### Controls

| Key | Action |
|-----|--------|
| **A / D** or **Left / Right** | Switch lanes |
| **Space / W / Up** | Hop over obstacles |
| **S / Down** | Duck under barriers |

### Core Mechanics

- **3-Lane Runner** -- Swipe between left, center, and right lanes to dodge obstacles
- **Hop & Duck** -- Jump over blocks and cars, duck under barriers and trains
- **Coins & Combos** -- Collect coins and chain near-misses to build your combo multiplier (up to 3.0x)
- **Power-ups** -- Grab shields (absorb one hit) and magnets (pull coins toward you)

### Health System

You have **3 hearts**. Each hit costs one heart and grants 1.5 seconds of invincibility frames (player flashes). The game ends when all hearts are lost. Shields still absorb hits without losing health.

### Daily Challenge System

Every day, a new seeded challenge is generated for all players. The menu shows today's challenge -- press SPACE to start.

**Challenge types:**

| Challenge | Example |
|-----------|---------|
| Collect coins | "Collect 75 coins" |
| Survive distance | "Run 300m" |
| Dodge obstacles | "Dodge 30 obstacles" |
| Hop over blocks | "Hop over 20 blocks" |
| Duck under barriers | "Duck under 15 barriers" |
| Reach combo | "Hit 2.0x combo" |
| Score target | "Score 5000 points" |
| Survive with full health | "Finish with 3 hearts" |

Challenge progress is shown in the HUD during gameplay, and the results screen shows whether you completed or failed the challenge.

### Leaderboard

Scores are submitted to a global Reddit leaderboard. All players compete on the same board regardless of the daily challenge.

## Tech Stack

- **Game Engine**: GameMaker Studio 2 (GML)
- **Platform**: Reddit Devvit (HTML5/WASM)
- **Procedural Generation**: Chunk-based obstacle spawning, seeded daily for consistent challenges
- **Leaderboard**: Reddit Devvit API for score submission and retrieval

## Project Structure

```
DailyDash/
  objects/
    obj_player/     -- Player movement, collision, health, challenge tracking
    obj_game/       -- Game controller, menus, HUD, procedural generation
    obj_obstacle/   -- Obstacle types (block, barrier, moving, car, train)
    obj_coin/       -- Collectible coins
    obj_powerup/    -- Shield and magnet power-ups
    obj_camera/     -- Screen shake effects
  scripts/
    scr_daily/      -- Daily seed, challenge generator, progress tracking
    scr_reddit/     -- Reddit/Devvit API integration
    scr_draw_helpers/ -- UI drawing utilities
  rooms/
    rm_game/        -- Main game room
```

## Development

### Prerequisites

- GameMaker Studio 2 (2024+)
- Node.js 20+
- Reddit Devvit CLI (`npx devvit`)

### Build & Deploy

1. Open `DailyDash.yyp` in GameMaker Studio 2
2. Build for Reddit target (F5)
3. Deploy to Reddit:
   ```bash
   npx devvit upload
   ```

### Local Testing

```bash
npx devvit playtest
```
