-module(chat_group).
-import(lists, [foreach/2, reverse/2]).

-export([start/2]).

start(C, Nick) ->
    process_flag(trap_exit, true),
    c ! ack,
    self() ! {C, {relay, Nick, "I'm starting the group"}},
    group_controller([{C, Nick}]).

delete(Pid, [{Pid, Nick}|T], L) -> {Nick, reverse(T, L)};
delete(Pid, [H|T], L) -> delete(Pid, T, [H|L]);
delete(_, [], L) -> {"????", L}.

group_controller([]) ->
    exit(allGone);
group_controller(L) ->
    receive
    {C, {relay, Nick, Str}} ->
			    foreach(fun({Pid, _}) ->
					    Pid ! {msg, Nick, C, Str} end, L),
			    group_controller(L);
	{login, C, Nick} ->
			    C ! ack,
			    self() ! {C, {relay, Nick, "I'm joinig the group"}},
			    group_controller(L);
	{close, C} ->
			    {Nick, L1} = delete(C, L, []),
			    self() ! {C, {relay, Nick, "I'm leaving the group"}},
			    group_controller(L1);
	Any ->
			    io:format("group controller received Msg=~p~n", [Any]),
			    group_controller(L)
     end.
	       
			    

			

    
