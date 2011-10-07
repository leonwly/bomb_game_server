#!/bin/sh
# NOTE: mustache templates need \ because they are not awesome.
exec erl -pa ebin edit deps/*/ebin -boot start_sasl \
    -sname bomb_game_server_dev \
    -s bomb_game_server \
    -s reloader
