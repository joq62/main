%%%-------------------------------------------------------------------
%% @doc control top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(main_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    ChildSpecs = [
		  #{id => log,               
		    start => {log,start_link,[]}},
		  #{id => rd,               
		    start => {rd,start_link,[]}},
		  #{id => git_handler,               
		    start => {git_handler,start_link,[]}},
		  #{id => catalog,               
		    start => {catalog,start_link,[]}},
		  #{id => deployment,               
		    start => {deployment,start_link,[]}},
		  #{id => controller,               
		    start => {controller,start_link,[]}},
		  #{id => main,               
		    start => {main,start_link,[]}}
		 ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
