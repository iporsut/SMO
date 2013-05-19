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
-module (hand_atk).

-import (lists, [flatlength/1, append/2]).

-compile (export_all).

check_hand_target(PlayerPid) ->
	OpponentPid = mnesia_play:get_opponent_pid(PlayerPid),
	{ok, Hand} = mnesia_play:get_player_data(OpponentPid, hand_cards),
	case flatlength(Hand) of
		0 -> {reject, no_hand_card};
		_ -> {have_target}
	end.
% ------------------------------ Hand Attack Zone --------------------------------------------------------------------------
% 505.1.1. ��û�С�����բ����ͨз����������ͽ��µç��������� Seal ��� At Line ��� Df Line
% ���� Seal ��������դ�������ö������������ Hand Zone�� ������ Effect �������������� Hand Zone ����ҹ��
hand_attack_condition(PlayerPid, CardOwner, CardOrder, CardID) ->
% 505.1.2. ��û�С�����բ���������ö������§ 1 ����� 1 Subturn ��ҹ��
	case mnesia_play:check_player_status(PlayerPid, already_attack_hand) of
		{ok, have_status} ->
			new_assign_atk:remove_attacker_status(CardOwner, CardOrder, CardID),
			new_assign_atk:rejected_attack(PlayerPid, CardOrder, CardID, already_atk_to_hand);
		{ok, have_no_status} ->
			check_hand_target(PlayerPid, CardOwner, CardOrder, CardID)
	end.

% 505.4. ��Ǩ�ͺ��ҽ��µç�������١���բ������ա�������������� �ҡ��������� Seal ����С�������͡�ҡ��û�С������
check_hand_target(PlayerPid, CardOwner, CardOrder, CardID) ->
	case check_hand_target(PlayerPid) of
		{have_target} ->	set_card_status(PlayerPid, CardOwner, CardOrder, CardID);
		{reject, Reason} ->	
			new_assign_atk:remove_attacker_status(CardOwner, CardOrder, CardID),
			new_assign_atk:rejected_attack(CardOwner, CardOrder, CardID, Reason)
	end.

% 505.6. ���� Cost �ͧ������շ����� ���¡ Seal ���١����繵��������� Seal ���� Ability ���зӧҹ����� Seal ����,
% ����� Seal ������� ���� ����� Seal ���բ����Ͷ���ա�����͡��÷ӧҹ�ͧ Ability �������͡�������������͡� Phase ��� --
set_card_status(PlayerPid, CardOwner, CardOrder, CardID) ->
	mnesia_play:set_player_data(PlayerPid, player_status, already_attack_hand),
	{ok, PlayerMp} = mnesia_play:get_player_data(PlayerPid, mp_rest),
	stack_pool:set_stack_option(self(), attack_type, to_hand_attack),
	card_utility:add_card_status(CardOwner, CardOrder, CardID, assign_attack_success, arena_zone),
	gen_server:cast(self(), {update_hand_attacker, PlayerMp, CardOwner, CardOrder, CardID}).	
	
ability_active_when_assign_attack() ->
	{ok, PlayerPid} = mnesia_play:get_game_data (self(), player_turn),
	stack_pool:set_stack_option(self(), play, new_assign_hand_attack_ability_activate),
	mod_ability_activate:check_any_ability_activate(assign_attack, PlayerPid).
	
verify_ability_assign_attack() ->
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mnesia_play:set_player_data(PlayerPid, player_status, assign_attack),
	stack_pool:set_stack_option(self(), play, new_verify_assign_hand_attack_ability_condition),
	mod_ability_activate:verify_ability_condition(assign_attack).

activate_ability_assign_attack() ->
	stack_pool:set_stack_option(self(), play, new_activate_assign_hand_attack_ability_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(assign_attack, PlayerPid).
	
ability_select_when_attacker() ->
	{ok, PlayerPid} = mnesia_play:get_game_data(self(), player_turn),
	stack_pool:set_stack_option(self(), play, new_hand_attacker_ability_activate),
	mod_ability_activate:check_any_ability_activate(seal_attacker, PlayerPid).

%
% ��÷ӧҹ��ǧ��ѧ Interfere
%
%% 505.9. ��Ǩ�ͺ��� Ability ��鹶١��ͧ������͹�㹡�÷ӧҹ������� ������͹����ú Ability ��鹨����ӧҹ 
%% �ҡ Ability �������ö�觼šѺ������·���˹� ���� ������·���˹�����������Ҿ�������������
%% ����Ѻ����͡������¢ͧ Ability� phase 505.6. ���� �ҡ������������������ Ability ����ö�觼�
%% ���� ��˹��� Ability ��鹨����ӧҹ ������͹�㹡���Դ Ability �ѧ���١��ͧ�����������·��١��ͧ Ability
%% ����� Seal ����, ����� Seal ������� ���� ����� Seal ���բ����ͨзӧҹ� Phase ��� -	
verify_ability_when_hand_attacker(CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option(self(), play, new_verify_seal_hand_attacker_condition),
	mod_ability_activate:verify_ability_condition(seal_attacker).

activate_ability_when_hand_attacker() ->
	stack_pool:set_stack_option(self(), play, new_activate_seal_hand_attacker_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(seal_attacker, PlayerPid).

%% 505.10. ��Ǩ�ͺ��ҡ�����չ�鹶١��ͧ������� Seal �����ѧ���ըе�ͧ����Ҿ Seal ���դú ���
%% ���͹�㹡�����բ����ͤú ��� ����㹷�� Combined �������������ҡ���͹����͡��Combined ���١��ͧ
%% ����������û�С�ȷ�ҷ�������������� Phase 505.3 �ҡ��� Combined �繡������ All
%% ����������û�С�ȷ������ All � Phase 506.2 ������ͧ��Ǩ�ͺ Mp �����駨��� Mp ����
%% Ability ���ӡ�����͡����Ǩ��������ö���͡���ա ��� Ability �ͧ Seal ���ӧҹ����Ǩ����ӧҹ���
%% ����ҡ���͹�㹡�����բ��������١��ͧ ��������������շ�����»�С�� Seal ���١����� Phase 504.6 ����
%% Ability �ͧ Seal ���ӧҹ����Ǩ����ӧҹ��� �ҡ Seal �����ѧ�����������ö��������� Seal ������� �٭������Ҿ Seal ����
%% �� Seal��Ƿ���С�����բ������͡�ҡ��û�С�����բ����� ��С����� Inactive Seal

					% hand_attack_10(CardOwner, CardOrder, CardID) ->
						% stack_pool:set_stack_option (self(), play, play_hand_attack_10),
						% case card_utility:check_active_status(CardOwner, CardOrder, CardID) of
							% active_seal ->
								% check_curse_status(CardOwner, CardOrder, CardID);
							% inactive_seal ->
								% assign_atk:rejected_attack(CardOwner, CardOrder, CardID, seal_not_ready)
						% end.
					% 
					% check_curse_status(CardOwner, CardOrder, CardID) ->
						% CardFx = card_utility:get_all_card_effect (CardOwner, CardOrder, CardID),
						% case curse:check_curse_status(CardFx, assign_atk) of
							% {ok, allow} ->
								% interfere_step:return_play(check_play_step);
							% {ok, disallow} ->
								% new_assign_atk:rejected_attack(CardOwner, CardOrder, CardID, seal_not_ready)
						% end.

%% 505.11. ��������բ�������ͧ͢���µç���� �ӡ�����͡��Ҩ�������� Seal ���� Mystic Card
%% �·ӡ�����͡���촪�Դ��鹺���ͧ͢���µç�������¡������ 1 ���йӡ���㺹��ŧ��ѧ Shrine
activate_hand_target(PlayerList) ->
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	%mnesia_play:set_player_data(PlayerPid, player_status, already_attack_hand),
	{OppHandSize, OppHandData} = hand_zone:get_opponent_hand_data(PlayerPid, PlayerList),
	smo_logger:msg("server send 8821 to client"),
	gen_server:cast(self(), {activate_select_hand_card_target, [16#88, 16#21], PlayerPid, [OppHandSize] ++ OppHandData}).

update_hand_card_target(PlayerPid, PlayerList, CardOrder) ->
	case CardOrder of
		[0] ->  new_assign_atk:rejected_attack(hand_target_mismatch);
		_->	{OwnerPid, CardID} = hand_zone:get_opponent_hand_card (PlayerPid, PlayerList, CardOrder),
			stack_pool:set_stack_option (self(), atk_target, {OwnerPid, CardOrder, CardID}),
			gen_server:cast(self(), {update_hand_card_target, OwnerPid, CardOrder, CardID})
	end.
	
replay_msg(PlayerList, ReplyShrineLevel) ->
	lists:foreach(
								fun({PlayerPid, _}) -> 
									ShrineMessage = shrine_zone:get_shrine_msg (PlayerPid, ReplyShrineLevel, []),
									gen_server:cast(self(), {update_shrine_level, PlayerPid, [16#88, 16#23], ShrineMessage})
								end, PlayerList).

hand_card_attacked() ->
	%% ��ͧ�ӡ�������͹Ҥ� ���Ш��Ѿഷ�ҡ��÷����촵� shrine ᷹
	stack_pool:set_stack_option (self(), play, attack_hand_to_shrine),
	{ok, {OwnerPid, CardOrder, CardID}} = stack_pool:get_last_stack (self(), atk_target),
	shrine_zone:card_to_shrine(OwnerPid, [{OwnerPid, CardOrder, CardID}]).

updated_hand_to_shrine(PlayerList) ->
	ReplyShrineLevel = shrine_zone:update_shrine_level(PlayerList, []),
	replay_msg(PlayerList, ReplyShrineLevel),
	ability_select_hand_attack_success().

%% 505.12.	Ability ���зӧҹ����� Seal ������������������ Seal ���բ���������� ����ա�����͡��÷ӧҹ�ͧ Ability �������͡�������������͡� Phase ��� --
ability_select_hand_attack_success() ->
	stack_pool:set_stack_option(self(), play, new_activate_hand_attack_success),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_activate:check_any_ability_activate(attack_success, PlayerPid).

%% 505.13.	��Ǩ�ͺ��� Ability ��鹶١��ͧ������͹�㹡�÷ӧҹ������� ������͹����ú Ability ��鹨����ӧҹ �ҡ Ability �������ö�觼šѺ������·���˹�
%% ���� ������·���˹�����������Ҿ������������� ����Ѻ����͡������¢ͧ Ability� phase 505.12. ���� �ҡ������������������ Ability ����ö�觼�
%% ���� ��˹���  Ability ��鹨����ӧҹ  ������͹�㹡���Դ Ability �ѧ���١��ͧ�����������·��١��ͧ Ability ����� Seal �������������
%% ����� Seal ���բ���������稨зӧҹ� Phase ��� --
verify_ability_select_hand_attack_success() ->
	stack_pool:set_stack_option(self(), play, new_verify_hand_hand_attack_success),
	mod_ability_activate:verify_ability_condition(attack_success).

activate_ability_select_hand_attack_success() ->
	stack_pool:set_stack_option(self(), play, new_activate_hand_attack_success_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(attack_success, PlayerPid).

	%% 505.14.	Seal ������ա����� Inactive Seal
	%% 505.15.	Seal ������� �٭������Ҿ Seal ����� Phase ��� --
	%% 505.16.	����鹵͹������բ����� �� Seal ����С�����բ������͡�ҡ��û�С������ --
	%mnesia_play:set_player_data (PlayerPid, player_status, already_attack_hand),
% interfere_step.erl [verify_end_of_fighting_ability -> activate_ability_when_end_of_fighting()]	

% ������� activate ability ��������բ����������
ability_select_hand_attack_success2(CardOwner, CardOrder, CardID) ->
	card_utility:add_card_status(CardOwner, CardOrder, CardID, hand_attack_success),
	stack_pool:set_stack_option(self(), play, new_activate_hand_attack_success2),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_activate:check_any_ability_activate(hand_attack_success, PlayerPid).

verify_ability_select_hand_attack_success2() ->
	stack_pool:set_stack_option(self(), play, new_verify_hand_hand_attack_success2),
	mod_ability_activate:verify_ability_condition(hand_attack_success).

activate_ability_select_hand_attack_success2(CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option(self(), play, new_activate_hand_attack_success_effect2),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(hand_attack_success, PlayerPid),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, hand_attack_success).
