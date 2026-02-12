/// @description Draw spinning golden coin - fully geometric

// Spinning effect: vary width with sin
var _phase = (x * 3 + y * 7) mod 360;
var _spin = sin(current_time / 200 + _phase);
var _r = 8;
var _rx = max(1, _r * abs(_spin)); // clamp to 1 to avoid zero-width ellipse
var _ry = _r;

// Outer glow ring (pulsing)
var _glow_a = 0.15 + sin(current_time / 250 + _phase) * 0.1;
draw_set_alpha(_glow_a);
draw_set_colour(make_colour_rgb(255, 230, 80));
draw_circle(x, y, _r + 4, false);
draw_set_alpha(1);

// Golden coin body (ellipse for spin)
draw_set_colour(make_colour_rgb(255, 210, 50));
draw_ellipse(x - _rx, y - _ry, x + _rx, y + _ry, false);

// Inner highlight crescent (only when coin is facing forward enough)
if (abs(_spin) > 0.3) {
    draw_set_colour(make_colour_rgb(255, 240, 140));
    var _hx = x - _rx * 0.25;
    var _hr = max(1, _rx * 0.4);
    draw_ellipse(_hx - _hr, y - _ry * 0.5, _hx + _hr, y + _ry * 0.5, false);
}

// Dollar sign (only when mostly facing)
if (abs(_spin) > 0.5) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(make_colour_rgb(180, 140, 20));
    draw_text(x, y, "$");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_alpha(1);
draw_set_colour(c_white);
