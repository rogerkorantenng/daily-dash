/// @description Initialize obstacle

// Type: 0=block (hop over), 1=barrier (duck under), 2=moving (oscillates lanes), 3=car (fast, hop over), 4=train (horizontal, duck under)
type = 0;

// Lane position (0=left, 1=center, 2=right)
lane = 0;

// Dimensions
w = 48;
h = 32;

// Color based on type (set after type is assigned)
col = c_red;

// Moving type vars
move_dir = choose(-1, 1);
move_speed = 1.5;
move_timer = 0;
target_lane = lane;

// Lane X positions (must match obj_game)
lane_x = [224, 320, 416];

// Car (type 3) vars
extra_spd = 0;       // additional downward speed beyond scroll
car_col = c_red;     // randomized on spawn

// Train (type 4) vars
hspd = 0;            // horizontal speed (positive=right, negative=left)
train_w = 140;       // train width for collision + drawing

// Challenge tracking (prevent double-count on hop-over/duck-under)
scored = false;

// Set position to lane
x = lane_x[lane];
