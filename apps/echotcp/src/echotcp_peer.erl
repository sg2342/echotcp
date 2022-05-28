%%%-------------------------------------------------------------------
%% @doc echotcp peer.
%% @end
%%%-------------------------------------------------------------------
-module(echotcp_peer).

-behaviour(gen_statem).

-ignore_xref([start_link/0]).
-export([start_link/0, accepted/1]).

-export([init/1, handle_event/4, callback_mode/0]).

-define(ACCEPT_TIMEOUT, 1000).

start_link() ->
    gen_statem:start_link(?MODULE, [], []).


accepted(Socket) ->
    {ok, Pid} = echotcp_peer_sup:start_child(),
    R = socket:setopt(Socket, {otp, controlling_process}, Pid),
    gen_statem:cast(Pid, {accepted, Socket, R}).


init([]) ->
    {ok, wait_accept, [], ?ACCEPT_TIMEOUT}.


callback_mode() ->
    handle_event_function.


handle_event(timeout, _, wait_accept, _) ->
    stop;
handle_event(cast, {accepted, Socket, ok}, wait_accept, _) ->
    echo(Socket);
handle_event(info, {'$socket', Socket, abort, _}, wait_data, Socket) ->
    stop(Socket);
handle_event(info, {'$socket', Socket, select, Handle}, wait_data, Socket) ->
    echo(socket:recv(Socket, [], Handle), Socket).


%% internal functions
echo(Socket) ->
    echo(socket:recv(Socket, 0, nowait), Socket).

echo({ok, Data}, Socket) ->
    send(Data, Socket);
echo({error, _}, Socket) ->
    stop(Socket);
echo({select, _SelectInfo}, Socket) ->
    {next_state, wait_data, Socket}.


send(Data, Socket) ->
    send1(socket:send(Socket, Data), Socket).

send1(ok, Socket) ->
    echo(Socket);
send1({ok, RestData}, Socket) ->
    send(RestData, Socket);
send1({error, _}, Socket) ->
    stop(Socket).


stop(Socket) ->
    _ = socket:shutdown(Socket, read_write),
    stop.
