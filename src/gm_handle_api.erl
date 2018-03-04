%%-------------------------------
%% @doc gm命令入口
%%-------------------------------
-module(gm_handle_api).
-author('labihbc@gmail.com').

-export([handle/2]).

%% @doc
%% @doc 添加gm命令只需要添加一个handle_gm函数 并且处理你相应的GM命令逻辑就可以
%% @doc 多条gm命令以空格区分,所以单条gm命令里面不能包含有空格。
%% @doc 每条gm命令记得加上例子注释，方便后面做注释提取（格式一定要【】）。 example: 【add_gold=100 加100元宝】
%% @doc 上面那一条注释别改，会影响注释提取。
%% @doc 一条命令多参数的话需要调用string2integerlist 把参数转换成整形列表再处理。

%% @spec handle_gm(Cmd, Player) -> {ok, Player} | {true, NewPlayer}
%% @doc 单条gm命令处理逻辑

%% @doc【add_gold=9999999 加元宝=9999999】
handle_gm("加元宝=" ++ StringParam, Player) ->
	handle_gm("add_gold" ++ StringParam, Player);
handle_gm("add_gold=" ++ StringParam, Player) ->
	IntgerParam = to_integer(StringParam),
	%% 这里调用实际加道具的api
	{ok, Player};

%% @doc【add_coin=9999999 加银两=9999999】
handle_gm("加银两=" ++ StringParam, Player) ->
	handle_gm("add_coin" ++ StringParam, Player);
handle_gm("add_coin=" ++ StringParam, Player) ->
	IntgerParam = to_integer(StringParam),
	%% 这里调用实际加银两的api
	{ok, Player};

%% @doc【add_exp=9999999 加经验=9999999】
handle_gm("加经验=" ++ StringParam, Player) ->
	handle_gm("add_exp" ++ StringParam, Player);
handle_gm("add_exp=" ++ StringParam, Player) ->
	IntgerParam = to_integer(StringParam),
	%% 这里调用实际加经验的api
	{ok, Player};

%% @doc【add_goods=100011,10 加道具=100011,10 加道具id为100011的道具10个】
handle_gm("加道具=" ++ StringParam, Player) ->
	handle_gm("add_goods=" ++ StringParam, Player);
handle_gm("add_goods=" ++ StringParam, Player) ->
	[GoodId, Num|_] = string2integerlist(StringParam),
	%% 这里调用实际加道具的api
	{ok, Player};

handle_gm(Err, _Player) ->
	io:format("你看看你瞎输的啥GM命令 ~w",[Err]),
	{error, Err}.

%% @doc 外部接口，聊天模块调用。
handle(Msg, Player) ->
	Gms = gms(Msg),
	handle_gms(Gms, [], Player).

handle_gms([], ReturnMsgs, Player) ->
	{true, ReturnMsgs, Player};
handle_gms([H | T], ReturnMsgs, Player) ->
	case handle_gm(misc:to_utf8_string(H), Player) of
		{true, NewPlayer} ->
			ReturnMsg = io_lib:format(" ~w success !" ,[H]),
			NewReturnMsgs = [ReturnMsg | ReturnMsgs],
			handle_gms(T, NewReturnMsgs, NewPlayer);
		{ok, NewPlayer} ->
			ReturnMsg = io_lib:format(" ~w success !" ,[H]),
			NewReturnMsgs = [ReturnMsg | ReturnMsgs],
			handle_gms(T, NewReturnMsgs, NewPlayer);
		{error, _Err} ->
			ReturnMsg = io_lib:format(" ~w  fail 认真点，你看看你瞎输的啥GM命令 ! !" ,[H]),
			NewReturnMsgs = [ReturnMsg | ReturnMsgs],
			handle_gms(T, NewReturnMsgs, Player)
	end.

gms(Msg) ->
	gms(Msg, 1, []).

gms(Msg, Num, Gms) ->
	case string:sub_word(Msg, Num) of
		[] ->
			Gms;
		Other -> 
			gms(Msg, Num + 1, [Other | Gms])
	end.

%% @spec string2integerlist("10011,2") -> [10011,2].
%% @doc 将字符串参数用逗号分隔，并转换成整数列表
string2integerlist(StringParam) ->
	string2integerlist(StringParam, 1, []).

string2integerlist(StringParam, Num, IntegerList) ->
	case string:sub_word(StringParam, Num, $,) of
		[] ->
			lists:reverse(IntegerList);
		Other ->
			string2integerlist(StringParam, Num + 1, [to_integer(Other) | IntegerList])
	end.

%% 各种转换---integer
to_integer(Msg) when is_integer(Msg) -> 
    Msg;
to_integer(Msg) when is_binary(Msg) ->
	Msg2 = binary_to_list(Msg),
    list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) -> 
    list_to_integer(Msg);
to_integer(_Msg) ->
    0.