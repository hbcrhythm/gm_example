%%%-------------------------------------------------------------------
%% @doc gm_example top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(gm_example_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1, acceptRequest/0]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->

	% acceptRequest(),

    {ok, { {one_for_all, 0, 1}, []} }.

%%====================================================================
%% Internal functions
%%====================================================================

%% 这里就是收到客户端协议后的处理。
acceptRequest() ->
	File = "../../../../../src/gm_list.php",
	Cmd = "php " ++ File,
	GmList = os:cmd(Cmd),
	GmTermList = string_to_term(GmList),
	io:format("GmTermList ~w",[GmTermList]).
	%% 只需要把GmTermList 按给定格式返回给客户端就可以。

%% term反序列化，string转换为term，e.g., "[{a},1]"  => [{a},1]
string_to_term(String) ->
    case erl_scan:string(String ++ ".") of
        {ok, Tokens, _} ->
            case erl_parse:parse_term(Tokens) of
                {ok, Term} -> Term;
                _Err -> _Err
            end;
        _Error ->
            undefined
    end.

%% gm_example_sup:acceptRequest().