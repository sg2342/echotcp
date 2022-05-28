%%%-------------------------------------------------------------------
%% @doc echotcp peer supervisor.
%% @end
%%%-------------------------------------------------------------------
-module(echotcp_peer_sup).

-behaviour(supervisor).

-ignore_xref([start_link/0]).
-export([start_link/0, start_child/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


start_child() ->
    supervisor:start_child(?SERVER, []).


init([]) ->
    Flags = #{strategy => simple_one_for_one,
	      intensity => 0,
	      period => 1},
    Specs = [#{id => echotcp_peer,
	       start => {echotcp_peer, start_link, []},
	       shutdown => brutal_kill,
	       restart => temporary
	      }],
    {ok, {Flags, Specs}}.
