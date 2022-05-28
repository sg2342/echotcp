%%%-------------------------------------------------------------------
%% @doc echotcp acceptor supervisor.
%%
%% application environment {acceptors, pos_integer()} controls number
%% of concurrent acceptor processes (default: 5)
%%
%% @end
%%%-------------------------------------------------------------------

-module(echotcp_acceptor_sup).

-behaviour(supervisor).

-ignore_xref([start_link/0]).
-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


init([]) ->
    {ok, NumAcceptors} = application:get_env(acceptors),
    Flags = #{strategy => one_for_one,
	      intensity => 0,
	      period => 1},
    Specs = lists:map(
	      fun(Id) ->
		      #{ id => Id,
			 start => {echotcp_acceptor, start_link, []} } end,
		      lists:seq(1, NumAcceptors)),
    {ok, {Flags, Specs}}.
