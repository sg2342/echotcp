%%%-------------------------------------------------------------------
%% @doc echotcp public API
%% @end
%%%-------------------------------------------------------------------
-module(echotcp_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    echotcp_sup:start_link().

stop(_State) ->
    ok.
