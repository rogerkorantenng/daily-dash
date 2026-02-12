/// @description Draw power-up — fully geometric icons

// Bob up and down
var _bob = sin((current_time / 300) + bob_offset) * 3;
var _dy = y + _bob;

// Glow pulse
glow_alpha = 0.3 + sin(current_time / 200) * 0.3;

// Orbiting dot angle
var _orbit_angle = (current_time / 400 + bob_offset) * pi / 180 * 60;
var _orbit_r = 16;

if (power_type == 0) {
    // === SHIELD (Hexagon) ===
    // Outer glow ring
    draw_set_alpha(glow_alpha * 0.5);
    draw_set_colour(make_colour_rgb(60, 200, 255));
    draw_circle(x, _dy, 16, false);
    draw_set_alpha(1);

    // Hexagonal shape
    draw_set_colour(make_colour_rgb(60, 180, 255));
    var _r = 10;
    for (var _i = 0; _i < 6; _i++) {
        var _a1 = (_i * 60 - 90) * pi / 180;
        var _a2 = ((_i + 1) * 60 - 90) * pi / 180;
        draw_triangle(
            x, _dy,
            x + cos(_a1) * _r, _dy + sin(_a1) * _r,
            x + cos(_a2) * _r, _dy + sin(_a2) * _r,
            false
        );
    }

    // Inner cross-bar
    draw_set_colour(make_colour_rgb(200, 240, 255));
    draw_line_width(x - _r * 0.4, _dy, x + _r * 0.4, _dy, 2);
    draw_line_width(x, _dy - _r * 0.4, x, _dy + _r * 0.4, 2);

    // Orbiting dot
    draw_set_colour(make_colour_rgb(150, 230, 255));
    draw_circle(x + cos(_orbit_angle) * _orbit_r, _dy + sin(_orbit_angle) * _orbit_r, 2, false);

} else {
    // === MAGNET (U-shape) ===
    // Outer glow ring
    draw_set_alpha(glow_alpha * 0.5);
    draw_set_colour(make_colour_rgb(255, 220, 50));
    draw_circle(x, _dy, 16, false);
    draw_set_alpha(1);

    // U-shape: two vertical poles + bottom connector
    var _pw = 4;
    var _ph = 10;
    var _gap = 5;

    // Left pole (red)
    draw_set_colour(make_colour_rgb(220, 60, 60));
    draw_rectangle(x - _gap - _pw, _dy - _ph, x - _gap, _dy, false);
    // Right pole (blue)
    draw_set_colour(make_colour_rgb(60, 100, 220));
    draw_rectangle(x + _gap, _dy - _ph, x + _gap + _pw, _dy, false);
    // Bottom connector
    draw_set_colour(make_colour_rgb(160, 160, 170));
    draw_rectangle(x - _gap - _pw, _dy, x + _gap + _pw, _dy + _pw, false);

    // Magnetic field arcs (small lines above opening)
    draw_set_alpha(0.4);
    draw_set_colour(make_colour_rgb(255, 200, 100));
    for (var _i = 0; _i < 3; _i++) {
        var _arc_y = _dy - _ph - 3 - _i * 3;
        var _arc_w = _gap + _pw - _i * 2;
        draw_line(x - _arc_w, _arc_y, x + _arc_w, _arc_y - 1);
    }
    draw_set_alpha(1);

    // Orbiting dot
    draw_set_colour(make_colour_rgb(255, 240, 120));
    draw_circle(x + cos(_orbit_angle) * _orbit_r, _dy + sin(_orbit_angle) * _orbit_r, 2, false);
}

draw_set_alpha(1);
draw_set_colour(c_white);
