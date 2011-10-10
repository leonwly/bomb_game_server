-module(bomb_game_server_web_tests).
-author("Yongseok Kang <feelform@gmail.com>").
-include_lib("eunit/include/eunit.hrl").

makeRoom_test() ->
    bomb_game_server_web:stop(),
    ?assertEqual(0, 0).
