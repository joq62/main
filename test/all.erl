%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(all).      
 
-export([start/0]).

-include("main.hrl").


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


-define(DeploymentRepoDir,"deployment_specs_test").
-define(DeploymentGit,"https://github.com/joq62/deployment_specs_test.git").

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    
    ok=setup(),
    ok=loop([]),
    io:format("Test OK !!! ~p~n",[?MODULE]),
%    timer:sleep(1000),
%    init:stop(),
    ok.


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
loop(State)->
    ActiveApplications=lists:sort(lib_reconciliate:active_applications()),
    if
	ActiveApplications=/=State->
%	    io:format("ActiveApplications ~p~n",[{ActiveApplications,?MODULE,?LINE}]),
	    NewState=ActiveApplications;
	true->
	    NewState=State
    end,
    loop(NewState).


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    ok=application:start(main),
    pong=main:ping(),
    pong=log:ping(),
    pong=rd:ping(),
    pong=git_handler:ping(),
    pong=catalog:ping(),
    pong=deployment:ping(),
    pong=controller:ping(),

    [rd:add_local_resource(ResourceType,Resource)||{ResourceType,Resource}<-[]],
    [rd:add_target_resource_type(TargetType)||TargetType<-[log,rd,catalog,deployment,adder,git_handler,controller,divi]],
    rd:trade_resources(),
    timer:sleep(3000),
    ok.
