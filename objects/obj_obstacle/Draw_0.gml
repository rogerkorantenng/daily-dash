/// @description Draw obstacle based on type — enhanced visuals

// --- Warning indicator when entering view ---
if (y < 30 && y > -20) {
    var _warn_alpha = 0.5 + sin(current_time / 80) * 0.4;
    draw_set_alpha(_warn_alpha);
    draw_set_colour(make_colour_rgb(255, 220, 50));
    if (type == 1) {
        // Barrier: downward "v" arrow
        draw_triangle(x - 6, 4, x + 6, 4, x, 14, false);
    } else if (type == 4) {
        // Train: horizontal arrow in travel direction
        var _ax = x;
        var _ad = sign(hspd);
        draw_line_width(_ax - 10 * _ad, 8, _ax + 10 * _ad, 8, 2);
        draw_triangle(_ax + 10 * _ad, 8, _ax + 4 * _ad, 4, _ax + 4 * _ad, 12, false);
    } else if (type == 3) {
        // Car: red "!" warning
        draw_set_colour(make_colour_rgb(255, 60, 60));
        draw_triangle(x, 2, x - 7, 14, x + 7, 14, false);
        draw_set_colour(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(x, 9, "!");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    } else {
        // Block/moving: "!" triangle
        draw_triangle(x, 2, x - 7, 14, x + 7, 14, false);
        draw_set_colour(make_colour_rgb(40, 30, 0));
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(x, 9, "!");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
    draw_set_alpha(1);
}

switch (type) {
    case 0: // Block - hop over
        // Shadow
        draw_set_alpha(0.3);
        draw_set_colour(c_black);
        draw_roundrect_ext(x - w/2 + 2, y - h/2 + 2, x + w/2 + 2, y + h/2 + 2, 4, 4, false);
        draw_set_alpha(1);

        // Body (gradient effect: lighter top, darker bottom)
        draw_set_colour(make_colour_rgb(240, 80, 65));
        draw_roundrect_ext(x - w/2, y - h/2, x + w/2, y, 4, 4, false);
        draw_set_colour(make_colour_rgb(200, 50, 40));
        draw_roundrect_ext(x - w/2, y, x + w/2, y + h/2, 4, 4, false);

        // Highlight
        draw_set_colour(make_colour_rgb(255, 120, 90));
        draw_roundrect_ext(x - w/2 + 3, y - h/2 + 3, x + w/2 - 3, y - h/2 + 10, 3, 3, false);

        // Faint "X" cross on face
        draw_set_alpha(0.25);
        draw_set_colour(make_colour_rgb(120, 20, 15));
        draw_line_width(x - w/2 + 6, y - h/2 + 6, x + w/2 - 6, y + h/2 - 6, 2);
        draw_line_width(x + w/2 - 6, y - h/2 + 6, x - w/2 + 6, y + h/2 - 6, 2);
        draw_set_alpha(1);

        // Warning stripes
        draw_set_colour(make_colour_rgb(180, 40, 30));
        draw_line_width(x - w/2 + 4, y + h/2 - 4, x + w/2 - 4, y + h/2 - 4, 2);
        break;

    case 1: // Barrier - duck under (animated stripes)
        var _bw = 56;
        var _bh = 10;

        // Shadow
        draw_set_alpha(0.3);
        draw_set_colour(c_black);
        draw_rectangle(x - _bw/2 + 2, y - _bh/2 + 2, x + _bw/2 + 2, y + _bh/2 + 2, false);
        draw_set_alpha(1);

        // Animated yellow/black hazard stripes (scroll with time)
        var _stripe_w = 8;
        var _stripe_offset = floor((current_time / 100) mod _stripe_w);
        for (var i = -1; i < _bw / _stripe_w + 1; i++) {
            var _sx = x - _bw/2 + i * _stripe_w + _stripe_offset;
            var _sx1 = max(_sx, x - _bw/2);
            var _sx2 = min(_sx + _stripe_w, x + _bw/2);
            if (_sx1 >= _sx2) continue;
            if (i mod 2 == 0) {
                draw_set_colour(make_colour_rgb(255, 200, 0));
            } else {
                draw_set_colour(make_colour_rgb(40, 40, 40));
            }
            draw_rectangle(_sx1, y - _bh/2, _sx2, y + _bh/2, false);
        }

        // Border
        draw_set_colour(make_colour_rgb(200, 160, 0));
        draw_rectangle(x - _bw/2, y - _bh/2, x + _bw/2, y + _bh/2, true);

        // Support poles on sides
        draw_set_colour(make_colour_rgb(100, 100, 100));
        draw_rectangle(x - _bw/2 - 3, y - _bh/2, x - _bw/2, y + 20, false);
        draw_rectangle(x + _bw/2, y - _bh/2, x + _bw/2 + 3, y + 20, false);
        break;

    case 2: // Moving block - pulsing glow + arrow
        // Pulsing outer glow
        var _glow_r = w/2 + 6 + sin(current_time / 150) * 4;
        draw_set_alpha(0.15 + sin(current_time / 150) * 0.1);
        draw_set_colour(make_colour_rgb(220, 100, 255));
        draw_circle(x, y, _glow_r, false);
        draw_set_alpha(1);

        // Shadow
        draw_set_alpha(0.3);
        draw_set_colour(c_black);
        draw_roundrect_ext(x - w/2 + 2, y - h/2 + 2, x + w/2 + 2, y + h/2 + 2, 4, 4, false);
        draw_set_alpha(1);

        // Body (purple/magenta for moving)
        draw_set_colour(make_colour_rgb(180, 60, 200));
        draw_roundrect_ext(x - w/2, y - h/2, x + w/2, y + h/2, 4, 4, false);

        // Highlight
        draw_set_colour(make_colour_rgb(220, 100, 240));
        draw_roundrect_ext(x - w/2 + 3, y - h/2 + 3, x + w/2 - 3, y - h/2 + 10, 3, 3, false);

        // Direction arrow
        draw_set_colour(c_white);
        var _ax = x + move_dir * 8;
        draw_triangle(
            _ax + move_dir * 8, y,
            _ax - move_dir * 4, y - 6,
            _ax - move_dir * 4, y + 6,
            false
        );
        break;

    case 3: // Car — top-down approaching vehicle
        var _cw = 32;
        var _ch = 56;

        // Shadow
        draw_set_alpha(0.3);
        draw_set_colour(c_black);
        draw_roundrect_ext(x - _cw/2 + 3, y - _ch/2 + 3, x + _cw/2 + 3, y + _ch/2 + 3, 5, 5, false);
        draw_set_alpha(1);

        // Body
        draw_set_colour(car_col);
        draw_roundrect_ext(x - _cw/2, y - _ch/2, x + _cw/2, y + _ch/2, 5, 5, false);

        // Windshield (top portion — darker tint)
        draw_set_colour(make_colour_rgb(40, 60, 80));
        draw_roundrect_ext(x - _cw/2 + 4, y - _ch/2 + 6, x + _cw/2 - 4, y - _ch/2 + 20, 3, 3, false);

        // Rear window
        draw_set_colour(make_colour_rgb(50, 70, 90));
        draw_roundrect_ext(x - _cw/2 + 5, y + _ch/2 - 18, x + _cw/2 - 5, y + _ch/2 - 8, 2, 2, false);

        // Wheels (left side)
        draw_set_colour(make_colour_rgb(30, 30, 30));
        draw_rectangle(x - _cw/2 - 3, y - _ch/2 + 8, x - _cw/2 + 1, y - _ch/2 + 18, false);
        draw_rectangle(x - _cw/2 - 3, y + _ch/2 - 18, x - _cw/2 + 1, y + _ch/2 - 8, false);
        // Wheels (right side)
        draw_rectangle(x + _cw/2 - 1, y - _ch/2 + 8, x + _cw/2 + 3, y - _ch/2 + 18, false);
        draw_rectangle(x + _cw/2 - 1, y + _ch/2 - 18, x + _cw/2 + 3, y + _ch/2 - 8, false);

        // Headlights (top = front since car approaches)
        draw_set_colour(make_colour_rgb(255, 255, 180));
        draw_circle(x - _cw/2 + 5, y - _ch/2 + 3, 3, false);
        draw_circle(x + _cw/2 - 5, y - _ch/2 + 3, 3, false);

        // Taillights (bottom)
        draw_set_colour(make_colour_rgb(255, 30, 30));
        draw_circle(x - _cw/2 + 5, y + _ch/2 - 3, 2, false);
        draw_circle(x + _cw/2 - 5, y + _ch/2 - 3, 2, false);

        // Body outline
        draw_set_colour(merge_colour(car_col, c_black, 0.4));
        draw_roundrect_ext(x - _cw/2, y - _ch/2, x + _cw/2, y + _ch/2, 5, 5, true);
        break;

    case 4: // Train — side-view horizontal crossing
        var _tw = train_w;
        var _th = 28;

        // Shadow
        draw_set_alpha(0.3);
        draw_set_colour(c_black);
        draw_rectangle(x - _tw/2 + 3, y - _th/2 + 3, x + _tw/2 + 3, y + _th/2 + 3, false);
        draw_set_alpha(1);

        // Main body (dark gray)
        draw_set_colour(make_colour_rgb(70, 75, 85));
        draw_roundrect_ext(x - _tw/2, y - _th/2, x + _tw/2, y + _th/2, 4, 4, false);

        // Red/yellow warning stripe along middle
        draw_set_colour(make_colour_rgb(200, 50, 30));
        draw_rectangle(x - _tw/2 + 2, y - 2, x + _tw/2 - 2, y + 2, false);
        draw_set_colour(make_colour_rgb(255, 200, 0));
        draw_rectangle(x - _tw/2 + 2, y - 1, x + _tw/2 - 2, y + 1, false);

        // Windows row (series of light-blue rectangles)
        draw_set_colour(make_colour_rgb(160, 210, 240));
        var _win_start = x - _tw/2 + 10;
        var _win_y1 = y - _th/2 + 4;
        var _win_y2 = y - 4;
        for (var _wi = 0; _wi < 8; _wi++) {
            var _wx = _win_start + _wi * 16;
            if (_wx + 10 > x + _tw/2 - 6) break;
            draw_rectangle(_wx, _win_y1, _wx + 10, _win_y2, false);
        }

        // Wheels along bottom (dark circles)
        draw_set_colour(make_colour_rgb(30, 30, 30));
        for (var _whi = 0; _whi < 6; _whi++) {
            var _whx = x - _tw/2 + 14 + _whi * 24;
            if (_whx > x + _tw/2 - 10) break;
            draw_circle(_whx, y + _th/2 - 2, 4, false);
            // Axle highlight
            draw_set_colour(make_colour_rgb(80, 80, 80));
            draw_circle(_whx, y + _th/2 - 2, 2, false);
            draw_set_colour(make_colour_rgb(30, 30, 30));
        }

        // Coupling rods at front/back
        draw_set_colour(make_colour_rgb(100, 100, 110));
        draw_rectangle(x - _tw/2 - 6, y - 3, x - _tw/2, y + 3, false);
        draw_rectangle(x + _tw/2, y - 3, x + _tw/2 + 6, y + 3, false);

        // Body outline
        draw_set_colour(make_colour_rgb(50, 55, 60));
        draw_roundrect_ext(x - _tw/2, y - _th/2, x + _tw/2, y + _th/2, 4, 4, true);
        break;
}

draw_set_alpha(1);
draw_set_colour(c_white);
