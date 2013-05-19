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
-module (attack_all).

-export ([check_target_attack/4]).
-export ([activate_battle/3]).
%-export ([complete_attack_all/3]).
-export ([attack_all_9/3]).%,  attack_all_13/3]).
-export([
						check_attacked_all_ability_activate/1,
						set_attacked_status/1,
						%check_target_select_a_0/4,
						%check_mp/4,
						attack_all_interfere/0,
						check_atk_all_interfere/3,
						normal_check/3,
						check_target_select_a/4,
						check_last/3,
						verify_attacker_all_ability/0,
						verify_attacked_all_ability/0,
						activate_attacker_all_effect/0,
						activate_attacker_all_suspend_effect/3,
						activate_attacked_all_effect/0,
						activate_target_suspend_effect/0,
						pre_attack_all_ability_active/3,
						ability_select_attack_success/0,
						ability_select_object_success/0,
						verify_ability_when_attack_success/0,
						activate_ability_when_attack_success/0,
						verify_ability_when_object_success/0,
						activate_ability_when_object_success/0,
						destroy_looser_seal/3,
						delete_each_attack_round_data/3
					]).
					
check_target_attack(PlayerPid, CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option(self(), play, attack_all_check_target),
	SealsTarget = target_attack:check_target_attack_all(PlayerPid, CardOwner, CardOrder, CardID, assign_atk),
	stack_pool:set_stack_option(self(), attack_target_selected, SealsTarget),
	case lists:flatlength(SealsTarget) of
		%0 ->	new_assign_atk:rejected_attack(CardOwner, CardOrder, CardID, no_target_attack);
		_ -> set_attacked_status(SealsTarget)
	end.

% 506.6. ��С�ȼ����蹽��µç�������ж١���� All ���¡ Seal �ء�� At Line ��� Df Line �ͧ���µç������� Seal �١���� --
set_attacked_status(SealsTarget) ->
	lists:foreach(
								fun({PlayerPid, CardOrder, CardID}) ->
									card_utility:add_card_status(PlayerPid, CardOrder, CardID, attacked, arena_zone)
								end, SealsTarget),
	check_attacker_all_ability_activate().
	
% 506.7. Ability ���зӧҹ ����� Seal ���� ���/���� ����� Seal ���� All ����ա�����͡��÷ӧҹ�ͧ Ability �������͡�������������͡� Phase ��� --
check_attacker_all_ability_activate() ->
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	stack_pool:set_stack_option (self(), play, check_attacker_all_ability_activate),
	mod_ability_activate:check_any_ability_activate(seal_attacker, PlayerPid).

% 506.8. Ability ���зӧҹ����� Seal �١���� ���/���� ����� Seal �١���� All ����ա�����͡��÷ӧҹ�ͧ Ability �������͡�������������͡� Phase ��� --
check_attacked_all_ability_activate(PlayerPid) ->
	stack_pool:set_stack_option (self(), play, check_attacked_all_ability_activate),
	%stack_pool:set_stack_option (self(), play, check_test),
	mod_ability_activate:check_any_ability_activate(seal_attacked, PlayerPid).
	
attack_all_interfere() ->
	%stack_pool:set_stack_option (self(), play, card_attack_all_interfere),
	stack_pool:set_stack_option(self(), play, check_interfere_atk_all),
% 506.7.	Interfere Step	
	interfere_step:into_sub_interfere().


% 506.8. ��Ǩ�ͺ��� Ability ��鹶١��ͧ������͹�㹡�÷ӧҹ������� ������͹����ú Ability ��鹨����ӧҹ �ҡ Ability �������ö�觼šѺ������·���˹�
% ���� ������·���˹�����������Ҿ�������������  ����Ѻ����͡������¢ͧ Ability�  phase 506.5 ���� 506.6 ���� �ҡ������������������ Ability ����ö�觼�
% ���� ��˹���  Ability ��鹨����ӧҹ  ������͹�㹡���Դ Ability �ѧ���١��ͧ�����������·��١��ͧ Ability ���зӧҹ
% ����� Seal ����, ����� Seal ���� All, ����� Seal �١���� ���� ����� Seal �١���� All�зӧҹ� Phase ��� --

check_atk_all_interfere(CardOwner, CardOrder, CardID) ->
	AbilityFx = ability_effect:check_card_effect(CardOwner, CardOrder, CardID, attack_any_action),
	% ������ѧ�� Effect �������͡����������������
	AttackType =
	case AbilityFx of
		% �ó��ѧ��
		{ok, have_effect} ->
			case stack_pool:get_last_stack(self(), attack_type) of
				% ��ҷ�����͡�繷�� Attack All �������
				{ok, attack_all} -> attack_all;
				_ -> normal_attack
			end;
		{ok, no_effect} ->
			ATT = seal_card:get_seal_base_power(CardOwner, CardOrder, CardID, attack_time),
			io:format("attack all post interfere check attack type ~p~n", [ATT]),
			case ATT of
				{ok, 1} -> attack_all;
				{ok, _} -> normal_attack;
				_ -> normal_attack
			end
	end,
	stack_pool:set_stack_option(self(), attack_type, AttackType),
	stack_pool:set_stack_option(self(), play, check_normal),
	interfere_step:return_play(check_play_step).

normal_check(CardOwner, CardOrder, CardID) ->
	case stack_pool:get_last_stack(self(), attack_type) of
		{ok, attack_all} ->
			%stack_pool:set_stack_option(self(), play, card_attack_all_interfere),
			%interfere_step:into_sub_interfere ();
			io:format("previous case is ~p~n", [attack_all]),
			{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
				case stack_pool:get_last_stack(self(), option) of
					{ok, Option} ->
						case is_atk_target(Option) of
							{already} ->
								stack_pool:set_stack_option(self(), play, card_attack_all_interfere),
								interfere_step:return_play(check_play_step);
								
								%interfere_step:into_sub_interfere();
								%attack_all:verify_attacker_all_ability();
							{no_target} ->
								io:format("previous case is with ~p~n", [no_target]),
								remove_attack_all_target_status(),
								check_target_select_a(PlayerPid, CardOwner, CardOrder, CardID)
						end;
					{error, no_stack} ->
						io:format("previous case is with ~p~n", [cannot_find_option]),
						remove_attack_all_target_status(),
						check_target_select_a(PlayerPid, CardOwner, CardOrder, CardID)
				end;
		{ok, normal_attack} ->
			io:format("previous case is ~p~n", [notmal_attack]),
			remove_attack_all_target_status(),
			stack_pool:set_stack_option(self(), play, normal_atk),
			{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
			check_target_select_a(PlayerPid, CardOwner, CardOrder, CardID)
	end.

remove_attack_all_target_status() ->
	io:format("get attack all target ~p~n", [stack_pool:get_last_stack(self(), attack_target_selected)]),
	case stack_pool:get_last_stack(self(), attack_target_selected) of
		{ok, AtkAllTarget} -> remove_attacked_status(AtkAllTarget);
		_ -> do_nothing
	end.
	
remove_attacked_status(AtkAllTarget) ->
	lists:foreach(
		fun({TPid, TOrder, TID}) ->
			card_utility:remove_card_status(TPid, TOrder, TID, attacked, arena_zone)
		end, AtkAllTarget).
		
is_atk_target([{attack_target_selected, _}|_]) -> {already};
is_atk_target([_|T]) -> is_atk_target (T);
is_atk_target([]) -> {no_target}.

check_target_select_a(PlayerPid, CardOwner, CardOrder, CardID) ->
	case target_attack:check_attack_target(PlayerPid, CardOwner, CardOrder, CardID) of
		{no_target, attack_to_hand}->
			stack_pool:set_stack_option(self(), assign_attack, to_hand_attack),
			hand_atk:hand_attack_condition(PlayerPid, CardOwner, CardOrder, CardID);
		{no_target, can_not_attack_to_hand} ->
			new_assign_atk:rejected_attack(PlayerPid, CardOrder, CardID, no_target_attack);
		{have_target, AttackTarget} ->
			%stack_pool:set_stack_option(self(), atk_target, AttackTarget),
			stack_pool:set_stack_option(self(), all_can_be_target, AttackTarget),
			stack_pool:set_stack_option(self(), assign_attack, normal_attack),
			new_assign_atk:send_activate_select_target()
	end.

check_last(CardOwner, CardOrder, CardID) ->
	case get(a) of
		{play_in} ->
			erase(a),
			%attack_all:check_target_attack(CardOwner, CardOrder, CardID);
			{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
			SealsTarget = target_attack:check_target_attack_all(PlayerPid, CardOwner, CardOrder, CardID, attack),
			stack_pool:set_stack_option(self(), attack_target_selected, SealsTarget),
			set_attacked_status(SealsTarget);
		_ ->
			erase(a),
			%verify_attacker_all_ability()
			attack_all_9(CardOwner, CardOrder, CardID)
	end.
	
% 506.9.	��Ǩ�ͺ��ҡ�����չ�鹶١��ͧ������� Seal �����ѧ���ըе�ͧ����Ҿ Seal ����, ���͹�㹡������ All �������㹷�� Combined
% �������������� �ҡ���͹�㹡������ All ���͡��Combined���١��ͧ ����������û�С�ȷ�ҷ�������յ�� Phase 504.2, 506.2 ���� 507.2 ������ Combined ��й��
% ������ͧ��Ǩ�ͺ Cost �����駨��� Cost ���� Ability ���ӡ�����͡����Ǩ��������ö���͡���ա ��� Ability �ͧ Seal ���ӧҹ����Ǩ����ӧҹ���
% ���ҡ Seal �����ѧ�����������ö������ ��� Seal �������/�١���� �٭������Ҿ Seal ����/�١���� �� Seal ��Ƿ���С�������͡�ҡ��û�С������ -
% ��С����� Inactive Seal
attack_all_9(CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option(self(), play, play_attack_all_9),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	case new_assign_atk:seal_status(PlayerPid, CardOwner, CardOrder, CardID, post_interfere) of
		{attack} -> recheck_attack_type(PlayerPid, CardOwner, CardOrder, CardID);
		{cancel_attack, Reason} -> 
			remove_attacker_status(CardOwner, CardOrder, CardID),
			new_assign_atk:rejected_attack(PlayerPid, CardOrder, CardID, Reason)
	end.
	
recheck_attack_type(PlayerPid, CardOwner, CardOrder, CardID) ->
	AbilityFx = ability_effect:check_card_effect(CardOwner, CardOrder, CardID, attack_any_action),
	% ������ѧ�� Effect �������͡����������������
	case AbilityFx of
		% �ó��ѧ��
		{ok, have_effect} ->
			case stack_pool:get_last_stack(self(), attack_type) of
				% ��ҷ�����͡�繷�� Attack All �������
				{ok, attack_all} -> verify_attacker_all_ability();%activate_battle(CardOwner, CardOrder, CardID);
				_ -> recheck_attack_type_1(PlayerPid, CardOwner, CardOrder, CardID)
			end;
		{ok, no_effect} ->
			recheck_attack_type_1(PlayerPid, CardOwner, CardOrder, CardID)
	end.
	
recheck_attack_type_1(PlayerPid, CardOwner, CardOrder, CardID) ->
	ATT =  
	case card_utility:check_card_status(CardOwner, CardOrder, CardID, be_combine, arena_zone) of
		{ok, have_no_status} ->
			case card_utility:check_card_status(CardOwner, CardOrder, CardID, combine_with_effect, arena_zone) of
				{ok, have_no_status} -> {ok, 0};
				{ok, have_status} -> seal_card:get_seal_base_power(CardOwner, CardOrder, CardID, attack_time)
			end;
		{ok, have_status} -> seal_card:get_seal_base_power(CardOwner, CardOrder, CardID, attack_time)
	end,
	AttackType = 
	case ATT of
		{ok, 1} -> attack_all;
		{ok, _} -> normal_attack
	end,
	case AttackType of
		normal_attack -> 
			{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
			{ok, SealsTarget} = stack_pool:get_last_stack(self(), attack_target_selected),
			new_assign_atk:remove_attacked_status(SealsTarget),
			new_assign_atk:recheck_attacker_condition(CardOwner, CardOrder, CardID);
		attack_all -> verify_attacker_all_ability()%activate_battle(CardOwner, CardOrder, CardID)
	end.

verify_attacker_all_ability() ->
	stack_pool:set_stack_option (self(), play, verify_attacker_all_ability),
	mod_ability_activate:verify_ability_condition(seal_attacker).
	
verify_attacked_all_ability() ->
	stack_pool:set_stack_option (self(), play, verify_attacked_all_ability),
	mod_ability_activate:verify_ability_condition(seal_attacked).
	
activate_attacker_all_effect() ->
	stack_pool:set_stack_option (self(), play, activate_attacker_all_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	mod_ability_effect:check_any_ability_activate(seal_attacker, PlayerPid).

activate_attacker_all_suspend_effect(CardOwner, CardOrder, CardID) ->
	AttackFx = new_assign_atk:check_when_attack_effect(CardOwner, CardOrder, CardID),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	stack_pool:set_stack_option(self(), play, activate_suspend_attacker_all_effect),
	new_assign_atk:activate_when_attack_effect(PlayerPid, AttackFx).
	
activate_attacked_all_effect() ->
	stack_pool:set_stack_option (self(), play, activate_attacked_all_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	mod_ability_effect:check_any_ability_activate(seal_attacked, PlayerPid).
	
activate_target_suspend_effect() ->
	{ok, AttackTarget} = stack_pool:get_last_stack(self(), attack_target_selected),
	TargetFx = new_assign_atk:check_when_target_effect(AttackTarget),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	stack_pool:set_stack_option(self(), play, activate_suspend_target_all_effect),
	new_assign_atk:activate_when_attack_effect(PlayerPid, TargetFx).

% 506.10.	������������Ẻ All 
activate_battle(CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option (self(), play, play_attack_all_10),
	case stack_pool:get_last_stack (self(), selected_attack_option) of
		{ok, {_, CombineCurrent}} ->
			%{ok, CombineCurrent} = stack_pool:get_last_stack (self(), current_combine_data),
			combat:calculate_battle_all_target(CardOwner, CardOrder, CardID),
			combat:remove_end_of_fighting_effect(),
			card_utility:update_card_option_field (CardOwner, CardOrder, CardID, combine, CombineCurrent),
			effect_activate:send_update_activate_effect(CardOwner, CardOrder, CardID, [], update),
			stack_pool:remove_stack_option (self(), selected_attack_option);
		_ ->	
			combat:calculate_battle_all_target(CardOwner, CardOrder, CardID),
			combat:remove_end_of_fighting_effect()
	end,
	interfere_step:return_play(check_play_step).
	
pre_attack_all_ability_active(CardOwner, CardOrder, CardID) ->
	card_utility:add_card_status(CardOwner, CardOrder, CardID, attack_success, arena_zone),
	{ok, SealTarget} = stack_pool:get_last_stack(self(), attack_target_selected),
	lists:foreach(
								fun({TPlayerPid, TCardOrder, TCardID}) ->
									card_utility:add_card_status(TPlayerPid, TCardOrder, TCardID, been_attack_success, arena_zone)
								end, SealTarget),
	ability_select_attack_success().

% 506.11.	Ability ���зӧҹ����� Seal ���������, ����� Seal �١���������, ����� Seal ���� All ����� ��������� Seal �١���� All �����
% ����ա�����͡��÷ӧҹ�ͧ Ability �������͡�������������͡� Phase ��� --
ability_select_attack_success() ->
	stack_pool:set_stack_option(self(), play, new_activate_attack_all_success),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(attack_success, PlayerPid).

ability_select_object_success() ->
	stack_pool:set_stack_option(self(), play, new_activate_been_attack_all_success),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(been_attack_success, PlayerPid).
	
% 506.12.	��Ǩ�ͺ��� Ability ��鹶١��ͧ������͹�㹡�÷ӧҹ������� ������͹����ú Ability ��鹨����ӧҹ
% �ҡ Ability �������ö�觼šѺ������·���˹� ���� ������·���˹�����������Ҿ������������� --
% ����Ѻ����͡������¢ͧ Ability� phase 506.11 ���� �ҡ������������������ Ability ����ö�觼� ���� ��˹���  Ability ��鹨����ӧҹ
% ������͹�㹡���Դ Ability �ѧ���١��ͧ�����������·��١��ͧ Ability ����� Seal ���������, Ability ����� Seal �١���������, Ability 
% ����� Seal ���� All ����� ���� Ability ����� Seal �١���� All����稨зӧҹ � Phase ��� --
verify_ability_when_attack_success() ->
	new_assign_atk:collect_ability_before_activate(),
	stack_pool:set_stack_option(self(), play, new_verify_attack_success_all_ability),
	mod_ability_activate:verify_ability_condition(attack_success).

activate_ability_when_attack_success() ->
	stack_pool:set_stack_option(self(), play, new_activate_attack_success_all_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	mod_ability_effect:check_any_ability_activate(attack_success, PlayerPid).

verify_ability_when_object_success() ->
	stack_pool:set_stack_option(self(), play, new_verify_been_attack_success_all_ability),
	mod_ability_activate:verify_ability_condition(been_attack_success).

activate_ability_when_object_success() ->
	stack_pool:set_stack_option(self(), play, new_activate_been_attack_success_all_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	mod_ability_effect:check_any_ability_activate(been_attack_success, PlayerPid).
	
% 506.15.	Seal �����ء��٭������Ҿ Seal ����������ѹ �ҡ��� Seal ��鹶١����¾�����ѹ
destroy_looser_seal(CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option(self(), play, attack_all_destroyed),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	DestroyList = combat:get_cards_destroy(),
	case lists:flatlength(DestroyList) of
		0 ->	OpponentPid = mnesia_play:get_opponent_pid(PlayerPid),
			gen_server:cast(self(), {update_change_zone, same_zone, OpponentPid, [16#88, 16#1e], [0, 0, 0]}),
			gen_server:cast(self(), {update_change_zone, same_zone, PlayerPid, [16#88, 16#1e], [0, 0, 0]}),
			delete_each_attack_round_data(CardOwner, CardOrder, CardID);
		_ ->	destroy:check_card_destroyed(PlayerPid, DestroyList, attack_all)
	end.
	
delete_each_attack_round_data(CardOwner, CardOrder, CardID) ->
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, attacker),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, attack_success),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, assign_attack_success),
	case stack_pool:get_last_stack(self(), attack_target_selected) of
		{ok, SealTarget} ->
			%DestroyList = combat:get_cards_destroy(),
			%SealRemain = SealTarget -- DestroyList,
			lists:foreach(
								fun({RPlayerPid, RCardOrder, RCardID}) ->
									card_utility:remove_card_status(RPlayerPid, RCardOrder, RCardID, attacked),
									card_utility:remove_card_status(RPlayerPid, RCardOrder, RCardID, been_attack_success)
								end, SealTarget);
		_ -> ''
	end,
	new_assign_atk:end_of_each_round_attack(CardOwner, CardOrder, CardID).
% ---------------------------- Function Utility ------------------------------------------------------------------------
remove_attacker_status(CardOwner, CardOrder, CardID) ->
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, attacker),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, assign_attack_success),
	case stack_pool:get_last_stack(self(), attack_target_selected) of
		{ok, SealsTarget} -> 	new_assign_atk:remove_attacked_status(SealsTarget);
		_ -> ""
	end.
