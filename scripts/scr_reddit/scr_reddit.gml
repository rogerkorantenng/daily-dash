/// @description Reddit/Devvit API integration functions

/// Submit score to the Devvit leaderboard
/// @param {real} _score The score to submit
function reddit_submit_score(_score) {
    var _url = "/api/score";
    var _body = json_stringify({ score: _score });

    var _headers = ds_map_create();
    ds_map_add(_headers, "Content-Type", "application/json");

    var _req = http_request(_url, "POST", _headers, _body);
    ds_map_destroy(_headers);
    return _req;
}

/// Fetch the leaderboard
/// @param {real} _limit Number of entries to fetch
function reddit_get_leaderboard(_limit) {
    var _url = "/api/leaderboard?limit=" + string(_limit);
    return http_request(_url, "GET", -1, "");
}

/// Save game state to Reddit
/// @param {real} _level Current level
/// @param {struct} _data Additional data
function reddit_save_state(_level, _data) {
    var _url = "/api/state";
    var _body = json_stringify({
        level: _level,
        data: _data
    });

    var _headers = ds_map_create();
    ds_map_add(_headers, "Content-Type", "application/json");

    var _req = http_request(_url, "POST", _headers, _body);
    ds_map_destroy(_headers);
    return _req;
}
