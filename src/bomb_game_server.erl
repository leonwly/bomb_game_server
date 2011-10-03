%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc bomb_game_server.

-module(bomb_game_server).
-author("Mochi Media <dev@mochimedia.com>").
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.


%% @spec start() -> ok
%% @doc Start the bomb_game_server server.
start() ->
    bomb_game_server_deps:ensure(),
    ensure_started(crypto),
    application:start(bomb_game_server).


%% @spec stop() -> ok
%% @doc Stop the bomb_game_server server.
stop() ->
    application:stop(bomb_game_server).
