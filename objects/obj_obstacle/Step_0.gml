/// @description Obstacle logic

// Moving type: oscillate between lanes
if (type == 2) {
    move_timer++;
    if (move_timer >= 40) {
        move_timer = 0;
        // Switch direction
        target_lane = clamp(lane + move_dir, 0, 2);
        if (target_lane == lane) {
            move_dir = -move_dir;
            target_lane = clamp(lane + move_dir, 0, 2);
        }
        lane = target_lane;
    }
    // Lerp to target lane position
    x = lerp(x, lane_x[lane], 0.15);
}

// Car: extra downward speed
if (type == 3) {
    y += extra_spd;
}

// Train: horizontal movement
if (type == 4) {
    x += hspd;
    // Destroy when fully off-screen horizontally
    if (hspd > 0 && x - train_w/2 > 700) instance_destroy();
    if (hspd < 0 && x + train_w/2 < -60) instance_destroy();
}

// Y movement handled by obj_game scrolling all obstacles down
// Destroy when off-screen (below view)
if (y > 400) {
    instance_destroy();
}
