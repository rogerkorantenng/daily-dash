/// @description Initialize game controller — vertical endless runner

// Draw road behind everything (higher depth = drawn first = behind)
depth = 10;

// Daily seed
daily_seed = current_year * 10000 + current_month * 100 + current_day;
randomize();

// Game state
game_running = false;
show_menu = true;
show_results = false;
difficulty = 1; // fixed at normal for all challenges

// Daily challenge
challenge = daily_get_challenge();
challenge_complete = false;

// Lane positions (3 lanes, centered in 640px view)
LANE_X = [224, 320, 416];

// Difficulty settings [easy, normal, hard]
base_scroll_speeds = [2, 3, 4];
max_scroll_speeds = [5, 8, 11];
speed_accel_rate = [0.003, 0.005, 0.008];
spawn_rates = [90, 60, 40]; // frames between chunk ticks

// Current settings
scroll_speed = 0;
spawn_rate = 60;
spawn_timer = 0;

// Scoring
final_score = 0;

// Road scrolling
road_scroll_y = 0;

// Chunk-based generation
// Chunk types: 0=safe, 1=coin_wave, 2=single_block, 3=double_block, 4=barrier_row, 5=gauntlet, 6=reward
chunk_type = 0;
chunk_timer = 0;
chunk_length = 0;
chunk_step = 0;
chunks_spawned = 0;

// Intensity scaling (0 to 1 over time)
intensity = 0;
intensity_max = 1.0;

// Particles
particles = [];

// Colors
col_menu_bg = make_colour_rgb(30, 30, 60);
col_title = make_colour_rgb(255, 220, 50);
col_easy = make_colour_rgb(100, 220, 100);
col_normal = make_colour_rgb(220, 180, 50);
col_hard = make_colour_rgb(220, 80, 80);

// Reddit/Devvit API state
score_submitted = false;
leaderboard = [];
leaderboard_loaded = false;
submit_request_id = -1;
leaderboard_request_id = -1;
