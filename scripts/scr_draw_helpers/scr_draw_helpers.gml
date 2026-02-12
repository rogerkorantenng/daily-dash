/// @description Helper functions for drawing road, player, and UI elements

/// Draw the scrolling road with lane markers
/// @param {real} _scroll_y Current road scroll offset
function draw_road(_scroll_y) {
    var _road_left = 176;
    var _road_right = 464;
    var _road_w = _road_right - _road_left;

    // Road background (dark asphalt)
    draw_set_colour(make_colour_rgb(50, 50, 60));
    draw_rectangle(_road_left, 0, _road_right, 360, false);

    // Road shoulders (slightly lighter)
    draw_set_colour(make_colour_rgb(70, 70, 80));
    draw_rectangle(_road_left, 0, _road_left + 8, 360, false);
    draw_rectangle(_road_right - 8, 0, _road_right, 360, false);

    // Shoulder edge lines (white)
    draw_set_colour(make_colour_rgb(200, 200, 200));
    draw_line_width(_road_left + 1, 0, _road_left + 1, 360, 2);
    draw_line_width(_road_right - 1, 0, _road_right - 1, 360, 2);

    // Scrolling dashed lane markers
    draw_set_colour(make_colour_rgb(180, 180, 180));
    var _lane_x1 = 272; // between lane 0 and 1
    var _lane_x2 = 368; // between lane 1 and 2
    var _dash_len = 20;
    var _gap_len = 20;
    var _total = _dash_len + _gap_len;

    for (var _y = -_total + (_scroll_y mod _total); _y < 380; _y += _total) {
        // Left lane marker
        draw_line_width(_lane_x1, _y, _lane_x1, _y + _dash_len, 2);
        // Right lane marker
        draw_line_width(_lane_x2, _y, _lane_x2, _y + _dash_len, 2);
    }

    // Side areas (grass/dirt)
    draw_set_colour(make_colour_rgb(60, 120, 60));
    draw_rectangle(0, 0, _road_left - 1, 360, false);
    draw_rectangle(_road_right + 1, 0, 640, 360, false);

    // Grass texture lines
    draw_set_colour(make_colour_rgb(50, 100, 50));
    for (var _gy = (_scroll_y mod 30); _gy < 380; _gy += 30) {
        draw_line(0, _gy, _road_left - 1, _gy);
        draw_line(_road_right + 1, _gy, 640, _gy);
    }

    draw_set_colour(c_white);
}

/// Draw a Mario-inspired player character
/// @param {real} _x Player X position
/// @param {real} _y Player Y position
/// @param {real} _hop_z Hop offset (negative = up)
/// @param {bool} _is_ducking Whether player is ducking
/// @param {bool} _has_shield Whether shield is active
/// @param {real} _near_miss_flash Flash timer for near-miss
function draw_player(_x, _y, _hop_z, _is_ducking, _has_shield, _near_miss_flash) {
    var _draw_y = _y + _hop_z;
    var _body_w = 24;
    var _body_h = _is_ducking ? 16 : 32;
    var _body_y = _draw_y;

    // Shadow on ground
    draw_set_alpha(0.3);
    draw_set_colour(c_black);
    var _shadow_scale = 1.0 + (_hop_z / -50) * 0.3;
    draw_ellipse(
        _x - 14 * _shadow_scale, _y - 4,
        _x + 14 * _shadow_scale, _y + 4,
        false
    );
    draw_set_alpha(1);

    // Accent color (cap + shirt) changes on hop
    var _accent_col = make_colour_rgb(220, 40, 40); // red
    if (_hop_z < -2) {
        _accent_col = make_colour_rgb(100, 220, 255); // light blue when hopping
    }

    // Near-miss flash overrides all colors to white
    var _flash_white = false;
    if (_near_miss_flash > 0) {
        if ((_near_miss_flash mod 4) < 2) _flash_white = true;
    }

    var _skin_col     = _flash_white ? c_white : make_colour_rgb(255, 200, 150);
    var _shirt_col    = _flash_white ? c_white : _accent_col;
    var _overall_col  = _flash_white ? c_white : make_colour_rgb(50, 80, 200);
    var _boot_col     = _flash_white ? c_white : make_colour_rgb(100, 60, 30);
    var _belt_col     = _flash_white ? c_white : make_colour_rgb(220, 200, 50);
    var _mustache_col = _flash_white ? c_white : make_colour_rgb(60, 30, 10);

    if (_is_ducking) {
        // === DUCKING (16px compressed Mario) ===

        // Boots (bottom 4px)
        draw_set_colour(_boot_col);
        draw_roundrect_ext(_x - 10, _body_y - 4, _x - 2, _body_y, 2, 2, false);
        draw_roundrect_ext(_x + 2, _body_y - 4, _x + 10, _body_y, 2, 2, false);

        // Overalls (4-10px)
        draw_set_colour(_overall_col);
        draw_rectangle(_x - _body_w/2, _body_y - 10, _x + _body_w/2, _body_y - 4, false);

        // Overall straps (two thin lines)
        draw_set_colour(_overall_col);
        draw_line_width(_x - 4, _body_y - 12, _x - 4, _body_y - 10, 2);
        draw_line_width(_x + 4, _body_y - 12, _x + 4, _body_y - 10, 2);

        // Face (10-14px)
        draw_set_colour(_skin_col);
        draw_roundrect_ext(_x - 8, _body_y - 14, _x + 8, _body_y - 10, 2, 2, false);

        // Eyes
        if (!_flash_white) {
            draw_set_colour(c_white);
            draw_circle(_x - 4, _body_y - 12, 1.5, false);
            draw_circle(_x + 4, _body_y - 12, 1.5, false);
            draw_set_colour(c_black);
            draw_circle(_x - 4, _body_y - 12, 0.8, false);
            draw_circle(_x + 4, _body_y - 12, 0.8, false);
        }

        // Cap (14-16px)
        draw_set_colour(_shirt_col);
        draw_roundrect_ext(_x - 10, _body_y - 16, _x + 8, _body_y - 14, 2, 2, false);
        // Brim
        draw_rectangle(_x + 4, _body_y - 15, _x + 12, _body_y - 14, false);
    } else {
        // === STANDING (32px full Mario) ===

        // Boots (bottom 6px) — two brown rounded rects
        draw_set_colour(_boot_col);
        draw_roundrect_ext(_x - 10, _body_y - 6, _x - 2, _body_y, 2, 2, false);
        draw_roundrect_ext(_x + 2, _body_y - 6, _x + 10, _body_y, 2, 2, false);

        // Overalls / legs (6-16px)
        draw_set_colour(_overall_col);
        draw_rectangle(_x - _body_w/2, _body_y - 16, _x + _body_w/2, _body_y - 6, false);

        // Overall buttons (two yellow dots)
        draw_set_colour(_belt_col);
        draw_circle(_x - 4, _body_y - 12, 1, false);
        draw_circle(_x + 4, _body_y - 12, 1, false);

        // Belt (16-17px)
        draw_set_colour(_belt_col);
        draw_rectangle(_x - _body_w/2, _body_y - 17, _x + _body_w/2, _body_y - 16, false);

        // Shirt / torso (17-23px)
        draw_set_colour(_shirt_col);
        draw_rectangle(_x - _body_w/2, _body_y - 23, _x + _body_w/2, _body_y - 17, false);

        // Arms (red circles on sides)
        draw_set_colour(_shirt_col);
        draw_circle(_x - _body_w/2 - 3, _body_y - 20, 3, false);
        draw_circle(_x + _body_w/2 + 3, _body_y - 20, 3, false);

        // Hands (skin-colored circles below arms)
        draw_set_colour(_skin_col);
        draw_circle(_x - _body_w/2 - 3, _body_y - 17, 2, false);
        draw_circle(_x + _body_w/2 + 3, _body_y - 17, 2, false);

        // Overall straps over shirt
        draw_set_colour(_overall_col);
        draw_line_width(_x - 4, _body_y - 23, _x - 4, _body_y - 17, 2);
        draw_line_width(_x + 4, _body_y - 23, _x + 4, _body_y - 17, 2);

        // Face (23-29px)
        draw_set_colour(_skin_col);
        draw_roundrect_ext(_x - 8, _body_y - 29, _x + 8, _body_y - 23, 3, 3, false);

        // Mustache
        draw_set_colour(_mustache_col);
        draw_ellipse(_x - 6, _body_y - 25, _x + 6, _body_y - 23, false);

        // Eyes
        if (!_flash_white) {
            draw_set_colour(c_white);
            draw_circle(_x - 4, _body_y - 27, 2, false);
            draw_circle(_x + 4, _body_y - 27, 2, false);
            draw_set_colour(c_black);
            draw_circle(_x - 4, _body_y - 27, 1, false);
            draw_circle(_x + 4, _body_y - 27, 1, false);
        }

        // Cap (29-32px)
        draw_set_colour(_shirt_col);
        draw_roundrect_ext(_x - 10, _body_y - 32, _x + 8, _body_y - 29, 3, 3, false);
        // Cap brim extending right
        draw_rectangle(_x + 4, _body_y - 31, _x + 13, _body_y - 29, false);

        // Cap emblem (white circle on front of cap)
        if (!_flash_white) {
            draw_set_colour(c_white);
            draw_circle(_x - 2, _body_y - 31, 2, false);
        }
    }

    // Shield bubble (unchanged)
    if (_has_shield) {
        var _pulse = 0.3 + sin(current_time / 150) * 0.2;
        draw_set_alpha(_pulse);
        draw_set_colour(make_colour_rgb(100, 220, 255));
        draw_circle(_x, _body_y - _body_h/2, _body_h * 0.7, false);
        draw_set_alpha(0.7);
        draw_set_colour(make_colour_rgb(150, 240, 255));
        draw_circle(_x, _body_y - _body_h/2, _body_h * 0.7, true);
        draw_set_alpha(1);
    }

    draw_set_colour(c_white);
}

/// Draw a rounded-rect panel with border
function draw_panel(_x1, _y1, _x2, _y2, _bg_col, _border_col, _alpha) {
    draw_set_alpha(_alpha);
    draw_set_colour(_bg_col);
    draw_roundrect_ext(_x1, _y1, _x2, _y2, 6, 6, false);
    draw_set_colour(_border_col);
    draw_roundrect_ext(_x1, _y1, _x2, _y2, 6, 6, true);
    draw_set_alpha(1);
}

/// Draw text with a dark shadow behind it
function draw_text_shadow(_xx, _yy, _str, _col, _shadow_col) {
    draw_set_colour(_shadow_col);
    draw_text(_xx + 1, _yy + 1, _str);
    draw_set_colour(_col);
    draw_text(_xx, _yy, _str);
}

/// Draw a golden coin icon
function draw_coin_icon(_xx, _yy, _scale) {
    var _r = 7 * _scale;
    // Outer gold
    draw_set_colour(make_colour_rgb(255, 210, 50));
    draw_circle(_xx, _yy, _r, false);
    // Inner highlight
    draw_set_colour(make_colour_rgb(255, 240, 140));
    draw_circle(_xx - _r * 0.2, _yy - _r * 0.2, _r * 0.5, false);
    // Dollar sign
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(make_colour_rgb(180, 140, 20));
    draw_text(_xx, _yy, "$");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// Draw a hexagonal shield icon
function draw_shield_icon(_xx, _yy, _scale) {
    var _r = 9 * _scale;
    // Hex shape via 6 triangles
    draw_set_colour(make_colour_rgb(60, 180, 255));
    for (var _i = 0; _i < 6; _i++) {
        var _a1 = (_i * 60 - 90) * pi / 180;
        var _a2 = ((_i + 1) * 60 - 90) * pi / 180;
        draw_triangle(
            _xx, _yy,
            _xx + cos(_a1) * _r, _yy + sin(_a1) * _r,
            _xx + cos(_a2) * _r, _yy + sin(_a2) * _r,
            false
        );
    }
    // Inner cross-bar
    draw_set_colour(make_colour_rgb(200, 240, 255));
    draw_line_width(_xx - _r * 0.4, _yy, _xx + _r * 0.4, _yy, 2);
    draw_line_width(_xx, _yy - _r * 0.4, _xx, _yy + _r * 0.4, 2);
}

/// Draw a U-shaped magnet icon
function draw_magnet_icon(_xx, _yy, _scale) {
    var _pw = 4 * _scale;  // pole width
    var _ph = 10 * _scale; // pole height
    var _gap = 6 * _scale;  // gap between poles
    // Left pole (red)
    draw_set_colour(make_colour_rgb(220, 60, 60));
    draw_rectangle(_xx - _gap - _pw, _yy - _ph, _xx - _gap, _yy, false);
    // Right pole (blue)
    draw_set_colour(make_colour_rgb(60, 100, 220));
    draw_rectangle(_xx + _gap, _yy - _ph, _xx + _gap + _pw, _yy, false);
    // Bottom connector (gray)
    draw_set_colour(make_colour_rgb(160, 160, 170));
    draw_rectangle(_xx - _gap - _pw, _yy, _xx + _gap + _pw, _yy + _pw, false);
}

/// Draw a keyboard key hint
function draw_key_hint(_xx, _yy, _key_text) {
    var _kw = string_width(_key_text) + 12;
    var _kh = 18;
    // Key background
    draw_set_colour(make_colour_rgb(60, 60, 80));
    draw_roundrect_ext(_xx - _kw/2, _yy - _kh/2, _xx + _kw/2, _yy + _kh/2, 4, 4, false);
    // Key border
    draw_set_colour(make_colour_rgb(120, 120, 150));
    draw_roundrect_ext(_xx - _kw/2, _yy - _kh/2, _xx + _kw/2, _yy + _kh/2, 4, 4, true);
    // Key text
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(_xx, _yy, _key_text);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

/// Draw scrolling scenery along road sides
function draw_scenery(_scroll_y) {
    var _road_left = 176;
    var _road_right = 464;
    var _wrap = 400;
    var _offset = _scroll_y * 2;

    // --- LEFT SIDE TREES ---
    for (var _i = 0; _i < 6; _i++) {
        var _ty = ((_i * 70 + _offset) mod _wrap) - 40;
        var _tx = _road_left - 40 - (_i mod 3) * 20;
        // Trunk
        draw_set_colour(make_colour_rgb(80, 60, 40));
        draw_rectangle(_tx - 2, _ty + 6, _tx + 2, _ty + 16, false);
        // 3 layered triangles (dark to light green)
        draw_set_colour(make_colour_rgb(30, 80, 30));
        draw_triangle(_tx, _ty - 10, _tx - 12, _ty + 6, _tx + 12, _ty + 6, false);
        draw_set_colour(make_colour_rgb(40, 110, 40));
        draw_triangle(_tx, _ty - 6, _tx - 10, _ty + 3, _tx + 10, _ty + 3, false);
        draw_set_colour(make_colour_rgb(60, 140, 60));
        draw_triangle(_tx, _ty - 2, _tx - 7, _ty + 1, _tx + 7, _ty + 1, false);
    }

    // --- RIGHT SIDE BUILDINGS ---
    for (var _i = 0; _i < 5; _i++) {
        var _by = ((_i * 80 + 30 + _offset) mod _wrap) - 40;
        var _bx = _road_right + 20 + (_i mod 2) * 25;
        var _bw = 18 + (_i mod 3) * 8;
        var _bh = 25 + (_i mod 4) * 10;
        // Building body
        var _gray = 55 + (_i mod 3) * 15;
        draw_set_colour(make_colour_rgb(_gray, _gray, _gray + 10));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
        // Windows (small dots)
        draw_set_colour(make_colour_rgb(200, 200, 120));
        for (var _wy = _by + 5; _wy < _by + _bh - 3; _wy += 7) {
            for (var _wx = _bx + 4; _wx < _bx + _bw - 3; _wx += 6) {
                draw_rectangle(_wx, _wy, _wx + 2, _wy + 3, false);
            }
        }
    }

    // --- SMALL DOTS (flowers/rocks) on both sides ---
    for (var _i = 0; _i < 8; _i++) {
        var _dy = ((_i * 50 + 15 + _offset) mod _wrap) - 20;
        // Left side
        var _dx = 10 + (_i * 37 mod 150);
        var _fc = (_i mod 3 == 0) ? make_colour_rgb(200, 80, 80) : ((_i mod 3 == 1) ? make_colour_rgb(200, 200, 80) : make_colour_rgb(130, 130, 130));
        draw_set_colour(_fc);
        draw_circle(_dx, _dy, 2, false);
        // Right side
        _dx = _road_right + 10 + (_i * 23 mod 160);
        draw_circle(_dx, _dy + 20, 2, false);
    }

    draw_set_colour(c_white);
}

/// Draw a letter grade based on score
function draw_grade(_score, _xx, _yy) {
    var _grade = "D";
    var _col = make_colour_rgb(150, 150, 150);
    if (_score > 5000) { _grade = "S"; _col = make_colour_rgb(255, 220, 50); }
    else if (_score > 3000) { _grade = "A"; _col = make_colour_rgb(100, 220, 100); }
    else if (_score > 1500) { _grade = "B"; _col = make_colour_rgb(100, 150, 255); }
    else if (_score > 500) { _grade = "C"; _col = c_white; }

    // Glow behind grade
    draw_set_alpha(0.3 + sin(current_time / 200) * 0.15);
    draw_set_colour(_col);
    draw_circle(_xx, _yy, 24, false);
    draw_set_alpha(1);

    // Grade letter
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_shadow(_xx, _yy, _grade, _col, c_black);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
