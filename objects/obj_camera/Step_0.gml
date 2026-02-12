/// @description Static camera with screen shake only

// Screen shake
var _shake_x = 0;
var _shake_y = 0;
if (shake_timer > 0) {
    shake_timer--;
    _shake_x = random_range(-shake_amount, shake_amount);
    _shake_y = random_range(-shake_amount, shake_amount);
    shake_amount *= 0.85;
    if (shake_timer <= 0) {
        shake_amount = 0;
    }
}

camera_set_view_pos(cam, cam_x + _shake_x, cam_y + _shake_y);
