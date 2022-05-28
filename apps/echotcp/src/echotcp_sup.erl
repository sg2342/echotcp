%%%-------------------------------------------------------------------
%% @doc echotcp top level supervisor.
%% @end
%%%-------------------------------------------------------------------
-module(echotcp_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


init([]) ->
   Flags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    Specs = lists:map(
	      fun(#{ id := Id } = M) -> M#{ start => {Id, start_link, []} } end,
		      [#{ id => echotcp_listener },
		       #{ id => echotcp_peer_sup, type => supervisor },
		       #{ id => echotcp_acceptor_sup, type => supervisor }]),
    {ok, {Flags, Specs}}.
