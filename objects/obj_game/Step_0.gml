/// @description Game logic — vertical scroll, chunk-based obstacle generation

// === MENU STATE ===
if (show_menu) {
    // Start game (single press — no difficulty selection)
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
        scroll_speed = base_scroll_speeds[difficulty];
        spawn_rate = spawn_rates[difficulty];
        show_menu = false;
        game_running = true;
        intensity = 0;
        chunks_spawned = 0;
        chunk_timer = 0;
        chunk_length = 0;
        road_scroll_y = 0;
        challenge_complete = false;
        random_set_seed(daily_seed);
        room_restart();
    }
    exit;
}

// === RESULTS STATE ===
if (show_results) {
    // Submit score + fetch leaderboard exactly once
    if (!score_submitted) {
        score_submitted = true;
        // Check challenge completion one final time
        if (instance_exists(obj_player) && is_struct(challenge)) {
            daily_check_challenge();
        }
        submit_request_id = reddit_submit_score(final_score);
        leaderboard_request_id = reddit_get_leaderboard(10);
        if (instance_exists(obj_player)) {
            reddit_save_state(difficulty, {
                score: final_score,
                distance: floor(obj_player.distance),
                coins: obj_player.coins,
                combo: obj_player.combo_multiplier,
                seed: daily_seed,
                challenge_type: challenge.type,
                challenge_complete: challenge_complete
            });
        }
    }

    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("R"))) {
        show_results = false;
        show_menu = true;
        score_submitted = false;
        leaderboard = [];
        leaderboard_loaded = false;
        room_restart();
    }
    exit;
}

// === GAME RUNNING ===
if (!game_running) exit;

// --- SPEED ACCELERATION ---
var _max_spd = max_scroll_speeds[difficulty];
if (scroll_speed < _max_spd) {
    scroll_speed += speed_accel_rate[difficulty];
    if (scroll_speed > _max_spd) scroll_speed = _max_spd;
}

// --- INTENSITY SCALING (0 to 1 over ~60 seconds) ---
intensity = min(intensity_max, intensity + 0.0003);

// --- ROAD SCROLL ---
road_scroll_y = (road_scroll_y + scroll_speed) mod 40;

// --- SCROLL ALL ENTITIES DOWN ---
with (obj_obstacle) {
    y += other.scroll_speed;
}
with (obj_coin) {
    y += other.scroll_speed;
    if (y > 400) instance_destroy();
}
with (obj_powerup) {
    y += other.scroll_speed;
    if (y > 400) instance_destroy();
}

// === CHUNK-BASED PROCEDURAL GENERATION ===
spawn_timer++;
if (spawn_timer >= 10) {
    spawn_timer = 0;

    var _spawn_y = -48; // spawn above the view

    // Start a new chunk if current one is done
    if (chunk_timer <= 0) {
        chunks_spawned++;

        var _roll = irandom(100);

        if (chunks_spawned < 4) {
            // Safe start
            chunk_type = 0;
        } else if (_roll < 20) {
            chunk_type = 1; // coin wave
        } else if (_roll < 35) {
            chunk_type = 2; // single block
        } else if (_roll < 50 && intensity > 0.2) {
            chunk_type = 3; // double block
        } else if (_roll < 65 && intensity > 0.25) {
            chunk_type = 4; // barrier row
        } else if (_roll < 78 && intensity > 0.35) {
            chunk_type = 5; // gauntlet (zigzag)
        } else if (_roll < 85 && chunks_spawned mod 5 == 0) {
            chunk_type = 6; // reward
        } else {
            chunk_type = 0; // safe
        }

        switch (chunk_type) {
            case 0: chunk_length = 3 + irandom(2); break;  // safe: 3-5
            case 1: chunk_length = 5; break;                 // coin wave: 5
            case 2: chunk_length = 2; break;                 // single block: 2
            case 3: chunk_length = 2; break;                 // double block: 2
            case 4: chunk_length = 3; break;                 // barrier row: 3
            case 5: chunk_length = 4 + irandom(2); break;   // gauntlet: 4-6
            case 6: chunk_length = 3; break;                 // reward: 3
        }

        chunk_timer = chunk_length;
        chunk_step = 0;
    }

    // === GENERATE BASED ON CHUNK TYPE ===

    // -- CHUNK 0: SAFE (just coins) --
    if (chunk_type == 0) {
        var _coin_lane = irandom(2);
        instance_create_layer(LANE_X[_coin_lane], _spawn_y, "Instances", obj_coin);
    }

    // -- CHUNK 1: COIN WAVE (lane-switching pattern) --
    else if (chunk_type == 1) {
        // Wave pattern: 0, 1, 2, 1, 0
        var _wave_lanes = [0, 1, 2, 1, 0];
        var _wl = _wave_lanes[chunk_step mod 5];
        instance_create_layer(LANE_X[_wl], _spawn_y, "Instances", obj_coin);
    }

    // -- CHUNK 2: SINGLE BLOCK (one obstacle, coins in other lanes) --
    else if (chunk_type == 2) {
        if (chunk_step == 0) {
            var _block_lane = irandom(2);
            var _obs = instance_create_layer(LANE_X[_block_lane], _spawn_y, "Instances", obj_obstacle);
            _obs.type = 0; // block
            _obs.lane = _block_lane;
            _obs.col = c_red;
            _obs.x = LANE_X[_block_lane];

            // Coins in other lanes
            for (var i = 0; i < 3; i++) {
                if (i != _block_lane) {
                    instance_create_layer(LANE_X[i], _spawn_y, "Instances", obj_coin);
                }
            }
        }
    }

    // -- CHUNK 3: DOUBLE BLOCK (two obstacles, one lane open with coin) --
    else if (chunk_type == 3) {
        if (chunk_step == 0) {
            var _open_lane = irandom(2);
            for (var i = 0; i < 3; i++) {
                if (i != _open_lane) {
                    var _obs = instance_create_layer(LANE_X[i], _spawn_y, "Instances", obj_obstacle);
                    _obs.type = 0;
                    _obs.lane = i;
                    _obs.col = c_red;
                    _obs.x = LANE_X[i];
                }
            }
            // Coin in the open lane
            instance_create_layer(LANE_X[_open_lane], _spawn_y, "Instances", obj_coin);
        }
    }

    // -- CHUNK 4: BARRIER ROW (duck under barriers in 1-2 lanes) --
    else if (chunk_type == 4) {
        if (chunk_step == 0) {
            var _barrier_count = 1 + (intensity > 0.5 ? 1 : 0);
            var _used_lanes = [];
            for (var b = 0; b < _barrier_count; b++) {
                var _bl = irandom(2);
                // Avoid duplicate lanes
                var _dup = false;
                for (var ci = 0; ci < array_length(_used_lanes); ci++) {
                    if (_used_lanes[ci] == _bl) { _dup = true; break; }
                }
                if (!_dup) {
                    var _obs = instance_create_layer(LANE_X[_bl], _spawn_y, "Instances", obj_obstacle);
                    _obs.type = 1; // barrier
                    _obs.lane = _bl;
                    _obs.x = LANE_X[_bl];
                    array_push(_used_lanes, _bl);
                }
            }
            // Coins in free lanes
            for (var i = 0; i < 3; i++) {
                var _is_used = false;
                for (var ci = 0; ci < array_length(_used_lanes); ci++) {
                    if (_used_lanes[ci] == i) { _is_used = true; break; }
                }
                if (!_is_used) {
                    instance_create_layer(LANE_X[i], _spawn_y - 10, "Instances", obj_coin);
                }
            }
        }
    }

    // -- CHUNK 5: GAUNTLET (alternating obstacles in different lanes) --
    else if (chunk_type == 5) {
        var _gaunlet_lane = chunk_step mod 3;
        // Alternate between blocks in different lanes
        if (chunk_step mod 2 == 0) {
            var _obs = instance_create_layer(LANE_X[_gaunlet_lane], _spawn_y, "Instances", obj_obstacle);
            _obs.type = 0;
            _obs.lane = _gaunlet_lane;
            _obs.x = LANE_X[_gaunlet_lane];
        } else {
            // Coin reward between obstacles
            var _safe = (_gaunlet_lane + 1) mod 3;
            instance_create_layer(LANE_X[_safe], _spawn_y, "Instances", obj_coin);
        }
    }

    // -- CHUNK 6: REWARD (power-up center, coins flanking) --
    else if (chunk_type == 6) {
        if (chunk_step == 1) {
            // Power-up in center lane
            instance_create_layer(LANE_X[1], _spawn_y, "Instances", obj_powerup);
        }
        // Coins on sides
        if (chunk_step != 1) {
            instance_create_layer(LANE_X[0], _spawn_y, "Instances", obj_coin);
            instance_create_layer(LANE_X[2], _spawn_y, "Instances", obj_coin);
        }
    }

    chunk_step++;
    chunk_timer--;
}

// Moving obstacles: occasionally spawn them at higher intensity
if (intensity > 0.4 && irandom(300) < 1 + difficulty) {
    var _ml = irandom(2);
    var _obs = instance_create_layer(LANE_X[_ml], -48, "Instances", obj_obstacle);
    _obs.type = 2; // moving
    _obs.lane = _ml;
    _obs.x = LANE_X[_ml];
    _obs.col = make_colour_rgb(180, 60, 200);
}

// Cars: fast approaching vehicles — spawn at medium intensity
if (intensity > 0.3 && irandom(250) < 1 + difficulty) {
    var _cl = irandom(2);
    var _obs = instance_create_layer(LANE_X[_cl], -80, "Instances", obj_obstacle);
    _obs.type = 3;
    _obs.lane = _cl;
    _obs.x = LANE_X[_cl];
    _obs.extra_spd = 1.5 + random(1.5);
    _obs.car_col = choose(c_red, c_blue, make_colour_rgb(40, 40, 40), c_white, make_colour_rgb(255, 165, 0));
}

// Trains: horizontal crossing — spawn at higher intensity
if (intensity > 0.5 && irandom(400) < 1 + difficulty) {
    var _from_left = irandom(1);
    var _sx = _from_left ? -100 : 740;
    var _obs = instance_create_layer(_sx, -48, "Instances", obj_obstacle);
    _obs.type = 4;
    _obs.hspd = _from_left ? 3 : -3;
    _obs.train_w = 140;
}

// === UPDATE PARTICLES ===
for (var i = array_length(particles) - 1; i >= 0; i--) {
    particles[i].x += particles[i].vx;
    particles[i].y += particles[i].vy;
    particles[i].vy += 0.15;
    particles[i].life--;
    if (particles[i].life <= 0) array_delete(particles, i, 1);
}

// === CHECK CHALLENGE PROGRESS ===
if (instance_exists(obj_player) && !obj_player.dead && is_struct(challenge)) {
    daily_check_challenge();
}

// === CALCULATE SCORE ===
if (instance_exists(obj_player) && !obj_player.dead) {
    var _dist = obj_player.distance;
    var _coins = obj_player.coins;
    var _combo = obj_player.combo_multiplier;
    final_score = floor((_dist * 10 + _coins * 50) * _combo);
}
