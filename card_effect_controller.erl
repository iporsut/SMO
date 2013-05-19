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
-module (card_effect_controller).

-import (lists, [foreach/2]).

-compile (export_all).

% hand_cards_add (PlayerLists, HandSize, Cards) ->
	% foreach ( fun({PlayerPid, _}) ->
			% CardSize = lists:flatlength (Cards),
			% CardData = get_card_data_reply (PlayerPid, Cards),
			% io:format ("Card data ~p~n", [CardData]),
			% gen_server:cast(PlayerPid, {send, [16#88, 16#77, HandSize, CardSize] ++ CardData})
		% end, PlayerLists).

get_card_data_reply (_, []) -> [];
get_card_data_reply (PlayerPid, [{PlayerPid, CardOrder, CardID} | Cards]) ->
	[1, CardOrder, <<CardID:16>>] ++ get_card_data_reply (PlayerPid, Cards);
get_card_data_reply (PlayerPid, [{_, CardOrder, CardID} | Cards]) ->
	[0, CardOrder, <<CardID:16>>] ++ get_card_data_reply (PlayerPid, Cards).
	
hand_cards_add(PlayerLists, Cards) ->
	foreach(fun({PlayerPid, _}) ->
		% 㹡óշ����� ��ͧ�Ӣ����� �շ�� �ͧ�ͧ��� ��ͧ����� ���� �ͧ Player ��������� Loop �ա�����˹��ҧ
		ThisPlayerCard = separate_each_player_card(PlayerPid, Cards, []),
		case ThisPlayerCard of
			[] -> 
				Opponent = mnesia_play:get_opponent_pid (PlayerPid),
				SealSize = hand_zone:check_card_size(Opponent, is_seal),
				MysSize = hand_zone:check_card_size(Opponent, is_not_seal),
				gen_server:cast(PlayerPid, {send, [16#88, 16#76, 16#02, SealSize, MysSize]});
			_ ->
				% ��ҡ��� ���йӢ����� �ա��촷���繢ͧ �����蹹������� ���������� Client ���� Update ���촺���� �µ�ͧ�觷���ͧ���
				% ��觷������Ңͧ �Ѻ������Ҵ���� ����� ��ǹ��觷���������Ңͧ �Ѻ����� ����¹����Ţ�ʴ� ���촺���ͧ͢��觵ç����
				CardSize = length(ThisPlayerCard),
				{ok, Hands} = mnesia_play:get_player_data(PlayerPid, hand_cards),
				HandSize = length(Hands),
				lists:foreach(fun({Pid, _}) ->
					CardData = get_card_data_reply(Pid, ThisPlayerCard),
					io:format ("Card data ~p~n", [CardData]),
					gen_server:cast(Pid, {send, [16#88, 16#77, HandSize, CardSize] ++ CardData}) end, PlayerLists)
		end
	end, PlayerLists).

separate_each_player_card(_, [], ThisPlayerCard) -> ThisPlayerCard;
separate_each_player_card(PlayerPid, [{PlayerPid, CardOrder, CardID}| Cards], ThisPlayerCard) -> separate_each_player_card(PlayerPid, Cards, ThisPlayerCard ++ [{PlayerPid, CardOrder, CardID}]);
separate_each_player_card(PlayerPid, [_|Cards], ThisPlayerCard) -> separate_each_player_card(PlayerPid, Cards, ThisPlayerCard).