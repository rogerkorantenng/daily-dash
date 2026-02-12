/// @description Setup camera — static position for vertical runner
cam = camera_create_view(0, 0, 640, 360, 0, -1, -1, -1, 0, 0);
view_camera[0] = cam;
view_visible[0] = true;
view_enabled = true;

// Static position (centered on road)
cam_x = 160; // (960 - 640) / 2 = 160 to center 640px view in 960px room
cam_y = 0;

// Screen shake
shake_amount = 0;
shake_timer = 0;

// Scale window to 2x for bigger display
window_set_size(1280, 720);
display_set_gui_size(640, 360);
