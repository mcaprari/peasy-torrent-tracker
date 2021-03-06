-module(peasy_supervisor).

-behaviour(supervisor).

-export([start_link/1, init/1]).

start_link(Args) ->
	supervisor:start_link({local,?MODULE}, ?MODULE, Args).

init([TrackerPort, RestPort]) ->
	process_flag(trap_exit, true),
	io:format("~p (~p) starting...~n", [?MODULE, self()]),
	Am	=	{announce_manager, {gen_event, start_link, [{global, announce_manager}]},
			permanent, 5000, worker, [announce_manager]},
	Info =	{torrent_info, {torrent_info, start_link, []},
			 permanent, 5000, worker, [torrent_info]},
	Web =	{peasy_web, {peasy_web, start_link, [TrackerPort]},
			permanent, 5000, worker, [peasy_web]},
	Rest =	{rest_interface, {rest_interface, start_link, [RestPort]},
			permanent, 5000, worker, [rest_interface]},
	Db  =	{db, {db, start_link, []},
			permanent, 5000, worker, [db]},
	
	{ok, {{one_for_one, 5, 30}, [Am, Web, Db, Rest, Info]}}.

