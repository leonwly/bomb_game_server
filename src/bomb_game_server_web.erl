%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 feelform.net<feelform@gmail.com>

%% @doc Web server for bomb_game_server.

-module(bomb_game_server_web).
-author("Yongseok Kang <feelform@gmail.com>").

-export([start/1, stop/0, loop/2]).

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    Loop = fun (Req) ->
                   ?MODULE:loop(Req, DocRoot)
           end,
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    mochiweb_http:stop(?MODULE).

loop(Req, DocRoot) ->
    "/" ++ Path = Req:get(path),
    try
        case Req:get(method) of
            Method when Method =:= 'GET'; Method =:= 'HEAD' ->
                case Path of
		    "reversedpush/" ++ Id ->
			Response = Req:ok({"text/html; charset=utf-8",
					   [{"Server", "feelformServer"}],
					   chunked}),
			Response:write_chunk("welcome you!" ++ Id ++ "\n"),
			feed(Response, Id, 1);
		    "makeRoom" ->
			FistDigit = trunc(random:uniform() * 10),
			SecondDigit = trunc(random:uniform() * 10),
			ThirdDigit = trunc(random:uniform() * 10),
			FourthDigit = trunc(random:uniform() * 10),
			Digit = io_lib:format("~p~p~p~p~n", [FistDigit, SecondDigit, ThirdDigit, FourthDigit]),
			chat_server ! {"feelform", Digit, "느림보"},
			Req:respond({200, [{"Content-Type", "text/plain"}], Digit});
                    _ ->
                        Req:serve_file(Path, DocRoot)
                end;
            'POST' ->
                case Path of
                    _ ->
                        Req:not_found()
                end;
            _ ->
                Req:respond({501, [], []})
        end
    catch
        Type:What ->
            Report = ["web request failed",
                      {path, Path},
                      {type, Type}, {what, What},
                      {trace, erlang:get_stacktrace()}],
            error_logger:error_report(Report),
            %% NOTE: mustache templates need \ because they are not awesome.
            Req:respond({500, [{"Content-Type", "text/plain"}],
                         "request failed, sorry\n"})
    end.

feed(Response, Path, N) ->
    receive
    after 10000 ->
	    Msg = io_lib:format("Chunk ~w for id ~s\n", [N, Path]),
	    Response:write_chunk(Msg)
	end,
    feed(Response, Path, N+1).
    
%% Internal API

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.

%%
%% Tests
%%
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

you_should_write_a_test() ->
    ?assertEqual(
       "No, but I will!",
       "Have you written any tests?"),
    ok.

-endif.
