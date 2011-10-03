%% @author Mochi Media <dev@mochimedia.com>
%% @copyright bomb_game_server Mochi Media <dev@mochimedia.com>

%% @doc Callbacks for the bomb_game_server application.

-module(bomb_game_server_app).
-author("Mochi Media <dev@mochimedia.com>").

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for bomb_game_server.
start(_Type, _StartArgs) ->
    bomb_game_server_deps:ensure(),
    bomb_game_server_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for bomb_game_server.
stop(_State) ->
    ok.
