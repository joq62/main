%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2024, c50
%%% @doc
%%%
%%% @end
%%% Created : 11 Jan 2024 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(lib_main).
  

-include("main.hrl").
  
%% API
-export([
	 connect_nodes/0,
	 connect/1
	]).

-export([

	]).

%%%===================================================================
%%% API
%%%===================================================================
connect_nodes()->
    AllHostNames=host:all_hosts(),
    CookieStr=atom_to_list(erlang:get_cookie()),
    NodeName=?ConnectModule++"_"++CookieStr,
    ConnectNodes=[list_to_atom(NodeName++"@"++HostName)||HostName<-AllHostNames],
    Pong=[{N,net_adm:ping(N)}||N<-ConnectNodes],
    Pong.
%%--------------------------------------------------------------------
%% @doc
%% 
%% 
%% @end
%%--------------------------------------------------------------------
connect(Sleep)->
    connect_nodes(),
    timer:sleep(Sleep),
    rpc:cast(node(),main,connect,[]).

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
