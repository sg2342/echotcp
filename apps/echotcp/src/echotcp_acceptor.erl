%%%-------------------------------------------------------------------
%% @doc echotcp acceptor.
%% @end
%%%-------------------------------------------------------------------
-module(echotcp_acceptor).

-behaviour(gen_statem).

-ignore_xref([start_link/0]).
-export([start_link/0]).

-export([init/1, handle_event/4, callback_mode/0]).

-define(ERROR_DELAY, 300).

start_link() ->
    gen_statem:start_link(?MODULE, [], []).


init([]) -> {ok, undefined, [], 0}.


callback_mode() ->
    handle_event_function.


handle_event(timeout, _, _, _) ->
    MaybeListenSocket = echotcp_listener:socket(),
    Accepted = accept(MaybeListenSocket),
    Timeout = delay(Accepted, ?ERROR_DELAY),
    {keep_state_and_data, Timeout}.

%% internal functions
accept({error,_ } = E) -> E;
accept({ok, ListenSocket}) ->
    MaybeSocket = socket:accept(ListenSocket),
    accept1(MaybeSocket).

accept1({error, _} = E) -> E;
accept1({ok, Socket}) ->
    echotcp_peer:accepted(Socket).


delay({error, emfile}, Delay) -> Delay;
delay({error, closed}, Delay) -> Delay;
delay(_,_) -> 0. 
