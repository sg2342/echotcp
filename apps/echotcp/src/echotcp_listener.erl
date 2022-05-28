%%%-------------------------------------------------------------------
%% @doc echotcp listener.
%%
%% application environment {listen_port, inet:port_number()} controls
%% on which TCP port the service listens (default 7777).
%%
%% @end
%%%-------------------------------------------------------------------
-module(echotcp_listener).

-behaviour(gen_statem).

-ignore_xref([start_link/0]).
-export([start_link/0, socket/0]).

-export([init/1, handle_event/4, callback_mode/0]).

-define(SERVER, ?MODULE).

start_link() ->
    gen_statem:start_link({local, ?SERVER}, ?MODULE, [], []).


socket() ->
    gen_statem:call(?SERVER, socket).


init([]) ->
    {ok, undefined, [], 0}.


callback_mode() ->
    handle_event_function.


handle_event(timeout, 0, undefined, _) ->
    {ok, Port} = application:get_env(listen_port),
    {ok, Socket} = socket:open(inet, stream, tcp),
    ok = socket:bind(Socket, #{ family => inet,
				port => Port,
				addr => any }),
    ok = socket:listen(Socket),
    {next_state, listening, Socket};
handle_event({call, From}, socket, listening, Socket) ->
    {keep_state_and_data, [{reply, From, {ok, Socket}}]}.
