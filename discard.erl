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
-module (discard).

-compile (export_all).

player_discard (PlayerPid, Cards) ->
% 702. ��鹵͹��ö١ Discard
	io:format ("Discards ~p~n", [Cards]),
	stack_pool:push_stack (self(), PlayerPid, 0, 0, [{play, player_discard_0}, {cards_discard, Cards}]),
	interfere_step:return_play (check_play_step).

% 702.1. ����� Seal ���� Mystic Card �١ Discard ���� Effect ��ҧ� �����¡ Seal ���� Mystic Card ���١ Discard ��� ���촷��١ Discard
player_discard_1 () ->
	stack_pool:set_stack_option (self(), play, play_player_discard_1),
	{ok, Cards} = stack_pool:get_last_stack (self(), cards_discard),
	set_card_status (Cards),
	interfere_step:return_play (check_play_step).

set_card_status ([]) -> ok;
set_card_status ([{PlayerPid, CardOrder, CardID} | Cards]) ->
%	Zone = card_utility:check_card_zone (PlayerPid, CardOrder, CardID),
	card_utility:add_card_status (PlayerPid, CardOrder, CardID, discard, hand_cards),
	set_card_status (Cards).

% 702.2. Ablity ����� Discard, ����� Discard �����, ����Ͷ١ Discard ���/���� Ability ����Ͷ١ Discard ����� ����ա�����͡��÷ӧҹ������͡� Phase ��� --
% ��Ш�����ա������¹�ŧ �͡�ҡ���� Effect �������ö���� --
player_discard_2 () ->
	stack_pool:set_stack_option (self(), play, play_player_discard_2),
	interfere_step:return_play (check_play_step).

% 702.3. �ҡ��ͧ�ӡ�����͡������� ������͡�������� Phase ��� --
player_discard_3 () ->
	stack_pool:set_stack_option (self(), play, play_player_discard_3),
	interfere_step:return_play (check_play_step).

% 702.4. ��Ǩ�ͺ��� Ability ����ö�觼šѺ������·���˹���������� �ҡ Ability �������ö�觼šѺ������·���˹� ���� 
% ������·���˹�����������Ҿ������������� ����Ѻ����͡�������� Phase 702.3 ���� �ҡ������������������ Ability ����
% ����ö�觼� ���� ��˹��� Ability ��鹨����ӧҹ
player_discard_4 () ->
	stack_pool:set_stack_option (self(), play, play_player_discard_4),
	interfere_step:return_play (check_play_step).

% 702.5. Ability ����� Discard, ����� Discard �����, ����Ͷ١ Discard ���/���� Ability ����Ͷ١ Discard ����� �зӧҹ� Phase ��� ������͹�㹡���Դ �ѧ�١��ͧ
player_discard_5 () ->
	stack_pool:set_stack_option (self(), play, play_player_discard_5),
	interfere_step:return_play (check_play_step).

% 702.6. ���촷��١ Discard ���٭������Ҿ���촷��١ Discard � Phase ��� --
player_discard_6 (PlayerPid) ->
	stack_pool:set_stack_option(self(), play, play_player_discard_6),
	{ok, Cards} = stack_pool:get_last_stack(self(), cards_discard),
	DiscardSize = lists:flatlength(Cards),
	DiscardData = remove_discard_status (Cards),
	{ok, Hand} = mnesia_play:get_player_data(PlayerPid, hand_cards),
	%%%self() ! {response_discard, PlayerPid, lists:flatlength(Hand) - 1, DiscardSize, DiscardData}.
	%gen_server:cast(self(), {response_discard, PlayerPid, lists:flatlength(Hand) - 1, DiscardSize, DiscardData}).
	gen_server:cast(self(), {response_discard, PlayerPid, lists:flatlength(Hand), DiscardSize, DiscardData}).

remove_discard_status ([]) -> [];
remove_discard_status ([{PlayerPid, CardOrder, CardID} | Cards]) ->
	card_utility:remove_card_status (PlayerPid, CardOrder, CardID, discard, hand_cards),
	[CardOrder, <<CardID:16>>] ++ remove_discard_status (Cards).

% 702.7. �ӡ��촹����ѧ Shrine ¡����� Effect ����к�������������蹹��
discard_to_shrine (PlayerPid) ->
	{ok, Cards} = stack_pool:get_last_stack (self(), cards_discard),
	stack_pool:pop_stack_out(self()),
	shrine_zone:card_to_shrine(PlayerPid, Cards).

% ��觪��������ж١���¡�����������ǡѺ��� Main Flow �ͧ��÷�駡���
check_cards_discard (PlayerPid) ->
	case stack_pool:get_last_stack (self(), play) of
		{ok, attack_subturn_discard} ->
			stack_pool:set_stack_option (self(), play, attack_subturn_discarded);
		{ok, defend_subturn_discard} ->
			stack_pool:set_stack_option (self(), play, defend_subturn_discarded)
	end,
	{ok, Hands} = mnesia_play:get_player_data (PlayerPid, hand_cards),
	{ok, DiscardType} = stack_pool:get_last_stack (self(), discard_type),
	case DiscardType of
		seal_card ->
			Discards = get_cards_discard (Hands, is_seal),
			player_discard (PlayerPid, Discards);
		mystic_card ->
			Discards = get_cards_discard (Hands, is_not_seal),
			player_discard (PlayerPid, Discards);
		_ ->	io:format ("Other discard type ~p~n", [DiscardType]),
			player_discard (PlayerPid, Hands)
	end.

get_cards_discard ([], _) -> [];
get_cards_discard ([{{PlayerPid, CardOrder, CardID}, _} | Hands], CardType) ->
	case mnesia_odbc:is_seal_card (CardID) of
		CardType ->
			[{PlayerPid, CardOrder, CardID}] ++ get_cards_discard (Hands, CardType);
		_ ->	get_cards_discard (Hands, CardType)
	end.