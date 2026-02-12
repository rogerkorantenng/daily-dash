/// @description Player movement — 3-lane vertical runner

// --- DEAD STATE ---
if (dead) {
    death_timer++;
    if (death_timer > 60) {
        with (obj_game) {
            game_running = false;
            show_results = true;
        }
    }
    exit;
}

// --- INVINCIBILITY COUNTDOWN ---
if (invincible) {
    invincible_timer++;
    if (invincible_timer >= invincible_duration) {
        invincible = false;
        invincible_timer = 0;
    }
}

// --- INPUT ---
var _left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var _right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _hop = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _duck = keyboard_check(vk_down) || keyboard_check(ord("S"));

// Touch/click to hop
if (mouse_check_button_pressed(mb_left)) {
    _hop = true;
}

// --- LANE SWITCHING ---
if (lane_switch_cooldown > 0) lane_switch_cooldown--;

if (_left && lane_switch_cooldown <= 0) {
    lane = max(0, lane - 1);
    lane_switch_cooldown = 6; // buffer frames
}
if (_right && lane_switch_cooldown <= 0) {
    lane = min(2, lane + 1);
    lane_switch_cooldown = 6;
}

// Smooth lane movement
target_x = LANE_X[lane];
x = lerp(x, target_x, 0.25);

// --- HOP ---
if (_hop && !is_hopping && !is_ducking) {
    is_hopping = true;
    hop_vz = -8;
}

if (is_hopping) {
    hop_vz += hop_gravity;
    hop_z += hop_vz;
    if (hop_z >= 0) {
        hop_z = 0;
        hop_vz = 0;
        is_hopping = false;
    }
}

// --- DUCK ---
if (_duck && !is_hopping && !is_ducking) {
    is_ducking = true;
    duck_timer = duck_duration;
}

if (is_ducking) {
    duck_timer--;
    if (duck_timer <= 0 || !_duck) {
        is_ducking = false;
    }
}

// --- OBSTACLE COLLISION ---
with (obj_obstacle) {
    // Train (type 4) uses X-range collision instead of lane matching
    if (type == 4) {
        var _in_range = (other.x > x - train_w/2 - 12) && (other.x < x + train_w/2 + 12);
        if (_in_range && abs(y - other.y) < 20) {
            if (!other.is_ducking) {
                if (other.has_shield) {
                    other.has_shield = false;
                    other.shield_timer = 0;
                    instance_destroy();
                    if (instance_exists(obj_camera)) {
                        obj_camera.shake_amount = 5;
                        obj_camera.shake_timer = 12;
                    }
                } else if (!other.invincible) {
                    other.hp--;
                    other.invincible = true;
                    other.invincible_timer = 0;
                    other.combo_multiplier = 1.0;
                    if (other.hp <= 0) {
                        other.dead = true;
                        other.death_timer = 0;
                    }
                    if (instance_exists(obj_camera)) {
                        obj_camera.shake_amount = 8;
                        obj_camera.shake_timer = 15;
                    }
                    instance_destroy();
                }
            } else if (!scored) {
                // Ducked under train — track for challenge
                scored = true;
                other.ducks_under++;
            }
        }
    } else {
        // Check if in same lane (or close enough for moving obstacles)
        var _same_lane = (lane == other.lane);
        if (type == 2) {
            // Moving obstacle: check by X distance instead
            _same_lane = (abs(x - other.x) < 30);
        }
        if (type == 3) {
            // Car: check by X distance
            _same_lane = (abs(x - other.x) < 30);
        }

        if (_same_lane && abs(y - other.y) < 24) {
            if (type == 0 || type == 2 || type == 3) {
                // Block/moving/car — must be hopping to avoid
                if (!other.is_hopping || other.hop_z > -6) {
                    if (other.has_shield) {
                        other.has_shield = false;
                        other.shield_timer = 0;
                        instance_destroy();
                        if (instance_exists(obj_camera)) {
                            obj_camera.shake_amount = 5;
                            obj_camera.shake_timer = 12;
                        }
                    } else if (!other.invincible) {
                        other.hp--;
                        other.invincible = true;
                        other.invincible_timer = 0;
                        other.combo_multiplier = 1.0;
                        if (other.hp <= 0) {
                            other.dead = true;
                            other.death_timer = 0;
                        }
                        if (instance_exists(obj_camera)) {
                            obj_camera.shake_amount = 8;
                            obj_camera.shake_timer = 15;
                        }
                        instance_destroy();
                    }
                } else if (!scored) {
                    // Successfully hopped over — track for challenge
                    scored = true;
                    other.hops_over++;
                }
            } else if (type == 1) {
                // Barrier — must be ducking to avoid
                if (!other.is_ducking) {
                    if (other.has_shield) {
                        other.has_shield = false;
                        other.shield_timer = 0;
                        instance_destroy();
                        if (instance_exists(obj_camera)) {
                            obj_camera.shake_amount = 5;
                            obj_camera.shake_timer = 12;
                        }
                    } else if (!other.invincible) {
                        other.hp--;
                        other.invincible = true;
                        other.invincible_timer = 0;
                        other.combo_multiplier = 1.0;
                        if (other.hp <= 0) {
                            other.dead = true;
                            other.death_timer = 0;
                        }
                        if (instance_exists(obj_camera)) {
                            obj_camera.shake_amount = 8;
                            obj_camera.shake_timer = 15;
                        }
                        instance_destroy();
                    }
                } else if (!scored) {
                    // Successfully ducked under — track for challenge
                    scored = true;
                    other.ducks_under++;
                }
            }
        }
    }
}

// --- POWER-UP TIMERS ---
if (has_shield) {
    shield_timer++;
    if (shield_timer >= shield_max) {
        has_shield = false;
        shield_timer = 0;
    }
}

if (has_magnet) {
    magnet_timer++;
    if (magnet_timer >= magnet_max) {
        has_magnet = false;
        magnet_timer = 0;
    }
}

// --- COIN COLLECTION (with magnet pull) ---
with (obj_coin) {
    var _dist = point_distance(x, y, other.x, other.y);

    // Magnet pull
    if (other.has_magnet && _dist < other.magnet_range) {
        var _dir = point_direction(x, y, other.x, other.y);
        x += lengthdir_x(5, _dir);
        y += lengthdir_y(5, _dir);
        _dist = point_distance(x, y, other.x, other.y);
    }

    // Collection
    if (_dist < 20) {
        other.coins++;
        other.combo_multiplier = min(other.combo_multiplier + 0.1, other.combo_max);
        other.combo_timer = 0;
        // Spawn coin burst particles
        if (instance_exists(obj_game)) {
            repeat(5) {
                array_push(obj_game.particles, {
                    x: x, y: y,
                    vx: random_range(-2, 2), vy: random_range(-3, -1),
                    life: 20, max_life: 20,
                    col: c_yellow, size: 3
                });
            }
        }
        instance_destroy();
    }
}

// --- POWER-UP COLLECTION ---
with (obj_powerup) {
    if (point_distance(x, y, other.x, other.y) < 24) {
        switch (power_type) {
            case 0: // Shield
                other.has_shield = true;
                other.shield_timer = 0;
                break;
            case 1: // Magnet
                other.has_magnet = true;
                other.magnet_timer = 0;
                break;
        }
        other.combo_multiplier = min(other.combo_multiplier + 0.2, other.combo_max);
        other.combo_timer = 0;
        instance_destroy();
    }
}

// --- NEAR-MISS DETECTION ---
if (near_miss_cooldown > 0) near_miss_cooldown--;

if (near_miss_cooldown <= 0) {
    var _near = false;

    with (obj_obstacle) {
        if (abs(y - other.y) < 30 && abs(y - other.y) > 10) {
            if (type == 4) {
                // Train near-miss: close vertically and ducking to dodge
                var _in_range = (other.x > x - train_w/2 - 20) && (other.x < x + train_w/2 + 20);
                if (_in_range && other.is_ducking) {
                    _near = true;
                }
            } else {
                // Obstacle is close vertically but we're not colliding
                if (lane != other.lane || (type == 0 && other.is_hopping) || (type == 1 && other.is_ducking) || (type == 3 && other.is_hopping)) {
                    if (abs(other.LANE_X[lane] - other.x) < 96) {
                        _near = true;
                    }
                }
            }
        }
    }

    if (_near) {
        combo_multiplier = min(combo_multiplier + 0.15, combo_max);
        combo_timer = 0;
        near_miss_flash = 15;
        near_miss_cooldown = 30;
        coins += 1;
        dodges++;

        if (instance_exists(obj_camera)) {
            obj_camera.shake_amount = 2;
            obj_camera.shake_timer = 6;
        }
    }
}

if (near_miss_flash > 0) near_miss_flash--;

// --- COMBO DECAY ---
combo_timer++;
if (combo_timer >= combo_decay_time) {
    combo_multiplier = max(1.0, combo_multiplier - 0.02);
}

// --- TRACK DISTANCE ---
if (instance_exists(obj_game)) {
    distance += obj_game.scroll_speed / 60;
}
