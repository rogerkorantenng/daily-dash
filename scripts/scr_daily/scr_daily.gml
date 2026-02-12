/// @description Daily challenge seed functions

/// Get today's daily seed
/// @returns {real} A seed number based on today's date
function daily_get_seed() {
    return current_year * 10000 + current_month * 100 + current_day;
}

/// Seeded random number (0 to max-1)
/// @param {real} _seed The seed value
/// @param {real} _index Index into the sequence
/// @param {real} _max Maximum value (exclusive)
/// @returns {real} A pseudo-random number
function daily_random(_seed, _index, _max) {
    var _val = _seed * 1103515245 + _index * 12345;
    _val = abs(_val) mod 2147483647;
    return _val mod _max;
}

/// Get today's daily challenge (type + target + description)
/// @returns {struct} { type, target, description }
function daily_get_challenge() {
    var _seed = daily_get_seed();
    random_set_seed(_seed);
    var _type = irandom(7);
    var _target = 0;
    var _desc = "";

    switch (_type) {
        case 0: // Collect coins
            _target = 50 + irandom(50) * 5; // 50-300
            _desc = "Collect " + string(_target) + " coins";
            break;
        case 1: // Survive distance
            _target = 100 + irandom(40) * 10; // 100-500m
            _desc = "Run " + string(_target) + "m";
            break;
        case 2: // Dodge obstacles
            _target = 10 + irandom(20); // 10-30
            _desc = "Dodge " + string(_target) + " obstacles";
            break;
        case 3: // Hop over obstacles
            _target = 10 + irandom(15); // 10-25
            _desc = "Hop over " + string(_target) + " blocks";
            break;
        case 4: // Duck under barriers
            _target = 8 + irandom(12); // 8-20
            _desc = "Duck under " + string(_target) + " barriers";
            break;
        case 5: // Reach combo
            _target = 20; // 2.0x (stored as int, divide by 10)
            var _combos = [15, 20, 25, 30];
            _target = _combos[irandom(3)];
            _desc = "Hit " + string_format(_target / 10, 1, 1) + "x combo";
            break;
        case 6: // Score target
            _target = 2000 + irandom(8) * 1000; // 2000-10000
            _desc = "Score " + string(_target) + " points";
            break;
        case 7: // Survive with full health
            _target = 3;
            _desc = "Finish with " + string(_target) + " hearts";
            break;
    }

    return { type: _type, target: _target, description: _desc };
}

/// Check if the current challenge target has been met
/// Call from obj_game context (uses obj_game.challenge, obj_player)
function daily_check_challenge() {
    if (!instance_exists(obj_player) || !instance_exists(obj_game)) return;
    if (obj_game.challenge_complete) return;

    var _ch = obj_game.challenge;
    if (!is_struct(_ch)) return;
    var _met = false;

    switch (_ch.type) {
        case 0: _met = (obj_player.coins >= _ch.target); break;
        case 1: _met = (obj_player.distance >= _ch.target); break;
        case 2: _met = (obj_player.dodges >= _ch.target); break;
        case 3: _met = (obj_player.hops_over >= _ch.target); break;
        case 4: _met = (obj_player.ducks_under >= _ch.target); break;
        case 5: _met = (obj_player.combo_multiplier * 10 >= _ch.target); break;
        case 6: _met = (obj_game.final_score >= _ch.target); break;
        case 7: _met = (obj_player.hp >= _ch.target); break;
    }

    if (_met) {
        obj_game.challenge_complete = true;
    }
}

/// Get the current progress value for the active challenge
/// @returns {real} current progress toward target
function daily_get_progress() {
    if (!instance_exists(obj_player) || !instance_exists(obj_game)) return 0;
    var _ch = obj_game.challenge;
    if (!is_struct(_ch)) return 0;

    switch (_ch.type) {
        case 0: return obj_player.coins;
        case 1: return floor(obj_player.distance);
        case 2: return obj_player.dodges;
        case 3: return obj_player.hops_over;
        case 4: return obj_player.ducks_under;
        case 5: return obj_player.combo_multiplier * 10;
        case 6: return obj_game.final_score;
        case 7: return obj_player.hp;
    }
    return 0;
}
