%% Copyright (c) 2008-2013, Nanusorn Photpipat <nanusorn@photpipat.com>
%%
%% Permission to use, copy, modify, and/or distribute this software for any
%% purpose with or without fee is hereby granted, provided that the above
%% copyright notice and this permission notice appear in all copies.
%%
%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
%% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
%% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.-module (ability_effect).
-module(main_smo).
-author('nanusorn@playpal.co.th').
-export([start/0, stop/0]).

start() ->
	net_adm:ping(node1@smogame1),
	net_adm:ping(node2@smogame2),
	net_adm:ping(node3@smogame3),
	net_adm:ping(node4@smogame4),
	net_adm:ping(node5@smogame5),
	%net_adm:ping(dottwo@dottwo),
	application:start(smo),
	gen_server:cast(smo_interval_activity, update_ccu).
	
stop() ->
	application:stop(smo).
