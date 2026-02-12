/// @description Initialize player — 3-lane vertical runner

// Lane system
lane = 1; // 0=left, 1=center, 2=right
LANE_X = [224, 320, 416];
target_x = LANE_X[lane];
lane_switch_cooldown = 0; // prevent double-tap

// Position (fixed near bottom)
x = LANE_X[lane];
y = 300;

// Hop (Z-axis visual hop)
is_hopping = false;
hop_z = 0;    // visual offset (negative = up)
hop_vz = 0;   // velocity
hop_gravity = 0.6;

// Duck
is_ducking = false;
duck_timer = 0;
duck_duration = 20;

// State
dead = false;
death_timer = 0;
coins = 0;
distance = 0;

// Health system
max_hp = 3;
hp = max_hp;
invincible = false;
invincible_timer = 0;
invincible_duration = 90; // 1.5 sec i-frames at 60fps

// Challenge tracking
dodges = 0;
hops_over = 0;
ducks_under = 0;

// Power-ups
has_shield = false;
shield_timer = 0;
shield_max = 600; // 10 seconds at 60fps

has_magnet = false;
magnet_timer = 0;
magnet_max = 480; // 8 seconds
magnet_range = 100; // pixel radius

// Combo system
combo_multiplier = 1.0;
combo_timer = 0;
combo_decay_time = 120; // 2 seconds to decay
combo_max = 3.0;

// Near-miss
near_miss_flash = 0;
near_miss_cooldown = 0;
near_miss_range = 24;

// Visual juice
tilt = 0;
squash_x = 1.0;
squash_y = 1.0;
was_hopping = false;
