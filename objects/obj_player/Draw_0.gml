/// @description Draw player with geometric style + juice

// --- TILT on lane switch ---
tilt = lerp(tilt, (target_x - x) * 0.8, 0.15);

// --- SQUASH/STRETCH on landing ---
if (was_hopping && !is_hopping) {
    squash_x = 1.3;
    squash_y = 0.7;
    // Spawn dust particles on landing
    if (instance_exists(obj_game)) {
        repeat(4) {
            array_push(obj_game.particles, {
                x: x + random_range(-8, 8), y: y,
                vx: random_range(-1, 1), vy: random_range(-1.5, -0.3),
                life: 15, max_life: 15,
                col: make_colour_rgb(180, 180, 160), size: 2
            });
        }
    }
}
squash_x = lerp(squash_x, 1.0, 0.15);
squash_y = lerp(squash_y, 1.0, 0.15);
was_hopping = is_hopping;

// --- SPEED LINES (vertical, scrolling down) ---
if (instance_exists(obj_game) && obj_game.scroll_speed > 3) {
    var _intensity = (obj_game.scroll_speed - 3) / 7;
    var _line_count = 4 + floor(_intensity * 4);
    draw_set_alpha(_intensity * 0.3);
    draw_set_colour(c_white);
    for (var i = 0; i < _line_count; i++) {
        var _lx = x - 24 + i * 10 + random_range(-2, 2);
        var _ly = y - 40 + (current_time mod 20) * i;
        draw_line_width(_lx, _ly, _lx, _ly + 15 + _intensity * 15, 1);
    }
    draw_set_alpha(1);
}

// --- DRAW PLAYER (geometric) ---
if (dead) {
    if (death_timer mod 6 < 3) {
        draw_player(x, y, hop_z, is_ducking, has_shield, near_miss_flash);
    }
} else if (invincible && !dead) {
    // Flicker every 4 frames during invincibility
    if ((invincible_timer div 4) mod 2 == 0) {
        draw_player(x, y, hop_z, is_ducking, has_shield, near_miss_flash);
    }
} else {
    draw_player(x, y, hop_z, is_ducking, has_shield, near_miss_flash);
}

// --- COMBO TEXT POPUP ---
if (combo_multiplier > 1.1) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    var _combo_pct = (combo_multiplier - 1.0) / 2.0;
    var _r = 255;
    var _g = lerp(255, 100, _combo_pct);
    var _b = lerp(100, 50, _combo_pct);
    draw_set_colour(make_colour_rgb(_r, _g, _b));

    var _bob = sin(current_time / 100) * 2;
    var _draw_y = y + hop_z;
    draw_text(x, _draw_y - 44 + _bob, string_format(combo_multiplier, 1, 1) + "x");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// --- MAGNET PULL INDICATOR ---
if (has_magnet) {
    draw_set_alpha(0.15 + sin(current_time / 200) * 0.1);
    draw_set_colour(make_colour_rgb(255, 220, 50));
    draw_circle(x, y, magnet_range, true);
    draw_set_alpha(1);
}

draw_set_colour(c_white);
draw_set_alpha(1);
