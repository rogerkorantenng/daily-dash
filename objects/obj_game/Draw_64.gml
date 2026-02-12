/// @description Draw HUD, Menu, Results — polished UI

var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _cx = _w / 2;
var _cy = _h / 2;

draw_set_font(-1);

// === DAILY CHALLENGE MENU ===
if (show_menu) {
    // Dark gradient background
    draw_set_alpha(0.97);
    draw_set_colour(make_colour_rgb(20, 20, 50));
    draw_rectangle(0, 0, _w, _h / 2, false);
    draw_set_colour(make_colour_rgb(15, 15, 35));
    draw_rectangle(0, _h / 2, _w, _h, false);
    draw_set_alpha(1);

    // --- Title ---
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_shadow(_cx, _h * 0.10, "DAILY DASH", col_title, make_colour_rgb(120, 90, 0));

    // Subtitle
    draw_text_shadow(_cx, _h * 0.17, "Vertical Runner", make_colour_rgb(120, 150, 255), make_colour_rgb(30, 40, 80));

    // Date badge
    var _date_str = string(current_day) + "/" + string(current_month) + "/" + string(current_year);
    draw_panel(_cx - 70, _h * 0.22 - 9, _cx + 70, _h * 0.22 + 9, make_colour_rgb(40, 40, 70), make_colour_rgb(80, 80, 120), 0.9);
    draw_text_shadow(_cx, _h * 0.22, _date_str, c_white, make_colour_rgb(20, 20, 40));

    // --- Separator ---
    draw_set_colour(make_colour_rgb(60, 60, 100));
    draw_line_width(_cx - 120, _h * 0.28, _cx + 120, _h * 0.28, 1);

    // --- Daily Challenge Card ---
    var _card_y = _h * 0.42;
    var _card_col = make_colour_rgb(255, 180, 50);

    // Challenge card panel
    draw_panel(_cx - 160, _card_y - 40, _cx + 160, _card_y + 40, make_colour_rgb(40, 40, 70), _card_col, 0.95);

    // Accent bar
    draw_set_colour(_card_col);
    draw_rectangle(_cx - 160, _card_y - 40, _cx - 154, _card_y + 40, false);

    // "TODAY'S CHALLENGE" label
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_shadow(_cx, _card_y - 22, "TODAY'S CHALLENGE", _card_col, make_colour_rgb(80, 60, 0));

    // Challenge description
    draw_text_shadow(_cx, _card_y + 2, challenge.description, c_white, make_colour_rgb(10, 10, 20));

    // Target hint
    draw_set_alpha(0.6);
    draw_text_shadow(_cx, _card_y + 24, "Target: " + string(challenge.target), make_colour_rgb(180, 180, 200), make_colour_rgb(10, 10, 20));
    draw_set_alpha(1);

    // --- Separator ---
    draw_set_halign(fa_center);
    draw_set_colour(make_colour_rgb(60, 60, 100));
    draw_line_width(_cx - 120, _h * 0.72, _cx + 120, _h * 0.72, 1);

    // --- Controls with key hints ---
    draw_set_valign(fa_middle);
    var _ky = _h * 0.79;
    draw_key_hint(_cx - 80, _ky, "A");
    draw_key_hint(_cx - 50, _ky, "D");
    draw_set_halign(fa_left);
    draw_text_shadow(_cx - 36, _ky, "Lanes", make_colour_rgb(160, 160, 190), make_colour_rgb(20, 20, 40));

    draw_key_hint(_cx + 30, _ky, "SPACE");
    draw_set_halign(fa_left);
    draw_text_shadow(_cx + 62, _ky, "Hop", make_colour_rgb(160, 160, 190), make_colour_rgb(20, 20, 40));

    draw_key_hint(_cx + 110, _ky, "S");
    draw_set_halign(fa_left);
    draw_text_shadow(_cx + 124, _ky, "Duck", make_colour_rgb(160, 160, 190), make_colour_rgb(20, 20, 40));

    // Start prompt
    draw_set_halign(fa_center);
    var _pulse_a = 0.6 + sin(current_time / 300) * 0.4;
    draw_set_alpha(_pulse_a);
    draw_text_shadow(_cx, _h * 0.89, "Press SPACE to Start", c_white, make_colour_rgb(20, 20, 40));
    draw_set_alpha(1);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

// === RESULTS SCREEN ===
if (show_results) {
    // Dark overlay
    draw_set_alpha(0.8);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _w, _h, false);
    draw_set_alpha(1);

    // Central panel (extended height for leaderboard)
    var _px1 = _cx - 200;
    var _py1 = _cy - 210;
    var _px2 = _cx + 200;
    var _py2 = _cy + 210;
    draw_panel(_px1, _py1, _px2, _py2, make_colour_rgb(25, 25, 50), make_colour_rgb(80, 80, 120), 0.95);

    // Challenge result in panel header
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (is_struct(challenge) && challenge_complete) {
        draw_text_shadow(_cx, _py1 + 18, "CHALLENGE COMPLETE!", make_colour_rgb(100, 255, 100), make_colour_rgb(20, 80, 20));
    } else {
        draw_text_shadow(_cx, _py1 + 18, "CHALLENGE FAILED", make_colour_rgb(255, 100, 80), make_colour_rgb(80, 20, 10));
    }

    // "GAME OVER"
    draw_text_shadow(_cx, _py1 + 40, "GAME OVER", make_colour_rgb(255, 80, 60), make_colour_rgb(100, 20, 10));

    // Challenge progress summary
    var _prog = floor(daily_get_progress());
    var _prog_str = string(_prog) + "/" + string(challenge.target);
    var _prog_col = challenge_complete ? make_colour_rgb(100, 255, 100) : make_colour_rgb(255, 200, 80);
    draw_text_shadow(_cx, _py1 + 58, challenge.description + "  " + _prog_str, _prog_col, c_black);

    // Letter grade
    draw_grade(final_score, _cx, _py1 + 85);

    // Score breakdown
    if (instance_exists(obj_player)) {
        var _row_y = _py1 + 120;
        var _left_col = _cx - 80;
        var _right_col = _cx + 80;

        // Distance row
        draw_set_halign(fa_left);
        draw_text_shadow(_left_col, _row_y, "Distance", make_colour_rgb(100, 220, 255), c_black);
        draw_set_halign(fa_right);
        draw_text_shadow(_right_col, _row_y, string(floor(obj_player.distance)) + "m", c_white, c_black);

        _row_y += 22;
        // Coins row
        draw_set_halign(fa_left);
        draw_coin_icon(_left_col + 6, _row_y, 0.8);
        draw_text_shadow(_left_col + 18, _row_y, "Coins", make_colour_rgb(255, 220, 50), c_black);
        draw_set_halign(fa_right);
        draw_text_shadow(_right_col, _row_y, string(obj_player.coins), c_white, c_black);

        _row_y += 22;
        // Combo row
        draw_set_halign(fa_left);
        draw_text_shadow(_left_col, _row_y, "Best Combo", make_colour_rgb(255, 150, 50), c_black);
        draw_set_halign(fa_right);
        draw_text_shadow(_right_col, _row_y, string_format(obj_player.combo_multiplier, 1, 1) + "x", c_white, c_black);

        // Divider
        _row_y += 18;
        draw_set_colour(make_colour_rgb(80, 80, 120));
        draw_line_width(_cx - 100, _row_y, _cx + 100, _row_y, 1);

        // Final score
        _row_y += 18;
        draw_set_halign(fa_center);
        draw_text_shadow(_cx, _row_y, "SCORE: " + string(final_score), make_colour_rgb(255, 220, 50), make_colour_rgb(100, 80, 0));
    }

    // === LEADERBOARD SECTION ===
    var _lb_top = _cy + 30;

    // Divider above leaderboard
    draw_set_colour(make_colour_rgb(80, 80, 120));
    draw_line_width(_cx - 140, _lb_top, _cx + 140, _lb_top, 1);

    // Submission status
    _lb_top += 14;
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (submit_request_id == -1 && score_submitted) {
        draw_text_shadow(_cx, _lb_top, "Score submitted!", make_colour_rgb(100, 255, 100), c_black);
    } else if (score_submitted) {
        draw_text_shadow(_cx, _lb_top, "Submitting...", make_colour_rgb(180, 180, 180), c_black);
    }

    // Leaderboard title
    _lb_top += 18;
    draw_text_shadow(_cx, _lb_top, "LEADERBOARD", make_colour_rgb(200, 180, 255), make_colour_rgb(60, 40, 80));

    // Leaderboard entries
    _lb_top += 16;
    var _lb_left = _cx - 120;
    var _lb_right = _cx + 120;

    if (!leaderboard_loaded) {
        draw_text_shadow(_cx, _lb_top + 20, "Loading...", make_colour_rgb(150, 150, 170), c_black);
    } else if (array_length(leaderboard) == 0) {
        draw_text_shadow(_cx, _lb_top + 20, "No scores yet", make_colour_rgb(150, 150, 170), c_black);
    } else {
        var _show_count = min(5, array_length(leaderboard));
        for (var i = 0; i < _show_count; i++) {
            var _entry_y = _lb_top + i * 18;

            // Alternating row shading
            if (i mod 2 == 0) {
                draw_set_alpha(0.15);
                draw_set_colour(c_white);
                draw_rectangle(_lb_left, _entry_y - 8, _lb_right, _entry_y + 8, false);
                draw_set_alpha(1);
            }

            // Highlight if this is the player's score
            var _is_player = (leaderboard[i].score == final_score);
            var _name_col = _is_player ? make_colour_rgb(255, 220, 50) : make_colour_rgb(200, 200, 220);

            // Rank
            draw_set_halign(fa_left);
            draw_text_shadow(_lb_left + 4, _entry_y, "#" + string(i + 1), make_colour_rgb(120, 120, 150), c_black);

            // Name
            draw_text_shadow(_lb_left + 36, _entry_y, leaderboard[i].name, _name_col, c_black);

            // Score
            draw_set_halign(fa_right);
            draw_text_shadow(_lb_right - 4, _entry_y, string(leaderboard[i].score), _name_col, c_black);
        }
    }

    // Retry prompt (pulsing)
    var _pulse_a = 0.5 + sin(current_time / 300) * 0.4;
    draw_set_alpha(_pulse_a);
    draw_set_halign(fa_center);
    draw_text_shadow(_cx, _py2 - 22, "SPACE to retry", c_white, c_black);
    draw_set_alpha(1);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

// === IN-GAME HUD ===
if (game_running) {
    // --- Draw particles ---
    for (var i = 0; i < array_length(particles); i++) {
        var _p = particles[i];
        var _a = _p.life / _p.max_life;
        draw_set_alpha(_a);
        draw_set_colour(_p.col);
        draw_circle(_p.x, _p.y, _p.size * _a, false);
    }
    draw_set_alpha(1);

    // --- Top bar panel ---
    draw_panel(0, 0, _w, 36, make_colour_rgb(15, 15, 30), make_colour_rgb(40, 40, 70), 0.75);

    // Score (top-center)
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_shadow(_cx, 3, string(final_score), c_white, make_colour_rgb(10, 10, 20));

    // Distance (below score)
    if (instance_exists(obj_player)) {
        draw_text_shadow(_cx, 17, string(floor(obj_player.distance)) + "m", make_colour_rgb(100, 220, 255), make_colour_rgb(10, 10, 20));
    }

    // Coins (top-left with icon)
    if (instance_exists(obj_player)) {
        draw_coin_icon(16, 12, 1.0);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text_shadow(28, 5, "x" + string(obj_player.coins), c_white, make_colour_rgb(10, 10, 20));
    }

    // Health hearts (between coins and center score)
    if (instance_exists(obj_player)) {
        var _heart_x = 80;
        var _heart_y = 12;
        for (var i = 0; i < obj_player.max_hp; i++) {
            if (i < obj_player.hp) {
                // Filled heart (red)
                draw_set_colour(make_colour_rgb(220, 40, 40));
            } else {
                // Empty heart (dark)
                draw_set_colour(make_colour_rgb(60, 30, 30));
            }
            // Draw heart shape using two circles and a triangle
            var _hx = _heart_x + i * 18;
            draw_circle(_hx - 3, _heart_y - 2, 4, false);
            draw_circle(_hx + 3, _heart_y - 2, 4, false);
            draw_triangle(_hx - 7, _heart_y, _hx + 7, _heart_y, _hx, _heart_y + 8, false);
        }
    }

    // Combo multiplier (top-right)
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    if (instance_exists(obj_player) && obj_player.combo_multiplier > 1.05) {
        var _combo = obj_player.combo_multiplier;
        var _combo_pct = (_combo - 1.0) / 2.0;
        var _combo_col = make_colour_rgb(255, lerp(255, 100, _combo_pct), lerp(100, 50, _combo_pct));

        // Fire glow at high combo
        if (_combo > 2.0) {
            draw_set_alpha(0.3);
            draw_set_colour(make_colour_rgb(255, 160, 30));
            draw_circle(_w - 30, 10, 10 + sin(current_time / 100) * 3, false);
            draw_set_alpha(0.2);
            draw_set_colour(c_yellow);
            draw_circle(_w - 30, 10, 7 + sin(current_time / 80) * 2, false);
            draw_set_alpha(1);
        }

        draw_text_shadow(_w - 8, 3, string_format(_combo, 1, 1) + "x", _combo_col, make_colour_rgb(10, 10, 20));
    }

    // Speed bar (top-right, below combo)
    var _spd_pct = scroll_speed / max_scroll_speeds[difficulty];
    var _bar_w = 50;
    var _bar_x = _w - _bar_w - 8;
    draw_panel(_bar_x - 1, 19, _bar_x + _bar_w + 1, 28, make_colour_rgb(30, 30, 50), make_colour_rgb(50, 50, 70), 0.6);
    var _spd_col = make_colour_rgb(lerp(100, 255, _spd_pct), lerp(255, 80, _spd_pct), 80);
    draw_set_colour(_spd_col);
    draw_rectangle(_bar_x, 20, _bar_x + _bar_w * _spd_pct, 27, false);

    // --- Challenge progress bar (below top bar) ---
    if (instance_exists(obj_player) && is_struct(challenge)) {
        var _prog = daily_get_progress();
        var _target = challenge.target;
        var _pct = clamp(_prog / _target, 0, 1);
        var _bar_bg_x1 = _cx - 100;
        var _bar_bg_x2 = _cx + 100;
        var _bar_y1 = 38;
        var _bar_y2 = 46;

        // Background
        draw_set_alpha(0.5);
        draw_set_colour(make_colour_rgb(20, 20, 40));
        draw_rectangle(_bar_bg_x1, _bar_y1, _bar_bg_x2, _bar_y2, false);
        draw_set_alpha(1);

        // Fill
        var _fill_col = challenge_complete ? make_colour_rgb(80, 220, 80) : make_colour_rgb(255, 180, 50);
        draw_set_colour(_fill_col);
        draw_rectangle(_bar_bg_x1, _bar_y1, _bar_bg_x1 + (_bar_bg_x2 - _bar_bg_x1) * _pct, _bar_y2, false);

        // Border
        draw_set_colour(make_colour_rgb(80, 80, 120));
        draw_rectangle(_bar_bg_x1, _bar_y1, _bar_bg_x2, _bar_y2, true);

        // Text
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        var _prog_text = string(floor(_prog)) + "/" + string(_target);
        if (challenge_complete) _prog_text = "COMPLETE!";
        draw_text_shadow(_cx, _bar_y1 - 1, _prog_text, c_white, make_colour_rgb(10, 10, 20));
    }

    // --- Power-up icons (bottom-left) ---
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    if (instance_exists(obj_player)) {
        var _icon_x = 16;
        var _icon_y = _h - 20;

        if (obj_player.has_shield) {
            var _rem = 1.0 - (obj_player.shield_timer / obj_player.shield_max);
            // Icon
            draw_shield_icon(_icon_x, _icon_y, 1.2);
            // Depletion arc (approximate with shrinking bar)
            draw_set_colour(make_colour_rgb(60, 180, 255));
            draw_set_alpha(0.5);
            draw_rectangle(_icon_x - 10, _icon_y + 12, _icon_x - 10 + 20 * _rem, _icon_y + 15, false);
            draw_set_alpha(1);
            _icon_x += 35;
        }

        if (obj_player.has_magnet) {
            var _rem = 1.0 - (obj_player.magnet_timer / obj_player.magnet_max);
            // Icon
            draw_magnet_icon(_icon_x, _icon_y, 1.2);
            // Depletion bar
            draw_set_colour(make_colour_rgb(255, 220, 50));
            draw_set_alpha(0.5);
            draw_rectangle(_icon_x - 10, _icon_y + 12, _icon_x - 10 + 20 * _rem, _icon_y + 15, false);
            draw_set_alpha(1);
            _icon_x += 35;
        }
    }

    // --- Challenge badge (bottom-right) ---
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_alpha(0.5);
    var _badge_col = challenge_complete ? make_colour_rgb(80, 220, 80) : make_colour_rgb(255, 180, 50);
    draw_set_colour(_badge_col);
    draw_circle(_w - 58, _h - 10, 3, false);
    draw_text_shadow(_w - 8, _h - 16, challenge.description, _badge_col, make_colour_rgb(10, 10, 20));
    draw_set_alpha(1);

    // --- Controls hint (first 5 seconds) ---
    if (instance_exists(obj_player) && obj_player.distance < 5) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_alpha(0.6);
        var _ky = _h - 40;
        draw_key_hint(_cx - 50, _ky, "A");
        draw_key_hint(_cx - 30, _ky, "D");
        draw_key_hint(_cx + 20, _ky, "SPACE");
        draw_key_hint(_cx + 60, _ky, "S");
        draw_set_alpha(1);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
