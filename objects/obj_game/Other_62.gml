/// @description Handle HTTP responses from Reddit/Devvit API

var _id = async_load[? "id"];
var _status = async_load[? "status"];
var _result = async_load[? "result"];

if (_status == 0) {
    // Leaderboard response
    if (_id == leaderboard_request_id) {
        leaderboard = [];
        leaderboard_loaded = true;
        var _data = json_parse(_result);
        if (is_array(_data)) {
            for (var i = 0; i < array_length(_data); i++) {
                array_push(leaderboard, {
                    name: _data[i][$ "name"] ?? ("Player " + string(i + 1)),
                    score: _data[i][$ "score"] ?? 0
                });
            }
        }
        leaderboard_request_id = -1;
    }

    // Score submission confirmation
    if (_id == submit_request_id) {
        submit_request_id = -1;
    }
}
