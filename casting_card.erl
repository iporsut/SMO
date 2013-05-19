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
-module (casting_card).

-include_lib ("stdlib/include/qlc.hrl").
-include ("play_record.hrl").

-import(server_lib, [send/2, controller/2]).
-import (mnesia_table, [do/1]).
-import (lists, [foreach/2, sum/1, append/2, min/1, flatlength/1]).

-compile (export_all).

reject_casting (PlayerPid, Reason) ->
	io:format("Reject casting card - ~p~n", [Reason]),
	mnesia_play:remove_player_status (PlayerPid, assign_cast),
	case Reason of
		card_not_on_hand ->
			gen_server:cast(self(), {reject_casting, PlayerPid, 0});
		not_enough_mp ->
			stack_pool:pop_stack_out(self()),
			gen_server:cast(self(), {reject_casting, PlayerPid, 1});
		% not_allow_mystic -> 
			% gen_server:cast(self(), {reject_casting, PlayerPid, 99});
		% play_card_out_of_step -> 
			% gen_server:cast(self(), {reject_casting, PlayerPid, 2});
		no_mystic_target ->
			stack_pool:pop_stack_out(self()),
			gen_server:cast(self(), {reject_casting, PlayerPid, 3});
		card_have_no_interfere -> 
			gen_server:cast(self(), {reject_casting, PlayerPid, 4});
		casting_condition_mismatch ->
			stack_pool:pop_stack_out(self()),
			gen_server:cast(self(), {reject_casting, PlayerPid, 3});
		_ ->
			gen_server:cast(self(), {reject_casting, PlayerPid, 99})
	end.

check_card_cast (PlayerPid, CardOwner, CardOrder, CardID) ->
	PlayStepBefore = stack_pool:get_last_stack(self(), play),
	% ��Ǩ�ͺ��ҡ������躹����������
	case card_utility:check_card_zone(CardOwner, CardOrder, CardID) of
		arena_zone ->	reject_casting (PlayerPid, card_not_on_hand);
		_ -> check_card_type(PlayerPid, CardOwner, CardOrder, CardID, PlayStepBefore)
	end.

check_card_type(PlayerPid, CardOwner, CardOrder, CardID, PlayStepBefore) ->
	case mnesia_odbc:is_seal_card(CardID) of
		is_seal ->
			case PlayStepBefore of
				{ok, sub_interfere} ->
					reject_casting(PlayerPid, cannot_cast_seal_interfere);
				_ ->	player_cast_seal(PlayerPid, CardOwner, CardOrder, CardID)
			end;
		is_not_seal ->
			case PlayStepBefore of
				{ok, sub_interfere} ->
					check_interfere_cast(PlayerPid, CardOwner, CardOrder, CardID, mystic_card);
				_ ->	player_cast_mystic (PlayerPid, CardOwner, CardOrder, CardID)
			end
	end.

check_interfere_cast(PlayerPid, CardOwner, CardOrder, CardID, CardType) ->
	{ok, Interfere} = mnesia_odbc:get_mystic_data (CardID, interfere),
	case Interfere of
		1 ->	case CardType of
				seal_card ->
					player_cast_seal(PlayerPid, CardOwner, CardOrder, CardID);
				mystic_card ->
					player_cast_mystic(PlayerPid, CardOwner, CardOrder, CardID)
			end;
		0 -> reject_casting(PlayerPid, card_have_no_interfere)
	end.

% ------------- SEAL CASTING ZONE --------------- %
% 610.2. Ability �����������ʹ�� �ͧ Seal ���зӧҹ ����ա�����͡��÷ӧҹ�ͧ Ability ������͡� Phase ��� ��Ш�����ա������¹�ŧ �͡�ҡ���� Effect �������ö���� --
player_cast_seal(PlayerPid, CardOwner, CardOrder, CardID) ->
	OpponentPid = mnesia_play:get_opponent_pid(PlayerPid),
	stack_pool:push_stack(self(), CardOwner, CardOrder, CardID, [{card_player, PlayerPid}, {opponent, OpponentPid}]),
	mnesia_play:set_player_data(PlayerPid, player_status, assign_cast),
	% stack_pool:set_stack_option(self(), play, check_come_into_play),
	%interfere_step:return_play(check_play_step).
	casting_seal_card(PlayerPid, CardOwner, CardOrder, CardID).

% 610.4. ��Ǩ�ͺ Cost ��������§�����¡��ԡ�������
casting_seal_card(PlayerPid, CardOwner, CardOrder, CardID) ->
	%{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	%smo_logger:fmsg("MP change of {~p, ~p, ~p} is ~p", [CardOwner, CardOrder, CardID, MpChange]),
	case can_cast(PlayerPid, CardOwner, CardOrder, CardID) of
		{accept_casting, MpRest} ->
			update_seal_casting_data (PlayerPid, MpRest, CardID);
		{reject_casting} ->
			reject_casting (PlayerPid, not_enough_mp)
	end.

% 610.5 ���� Cost �ͧ������·������ͧ���� ���촨��������Ҿ ���촷����ѧ���� �ж����ҡ��촹�������ʹ�� ����ҡ�� Seal ���� Active Seal
update_seal_casting_data(PlayerPid, MpRest, CardID) ->
	stack_pool:set_stack_option(self(), play, casting_card_to_arena), % Growth ��ͨҡ���
	{ok, {CardOwner, CardOrder, CardID, _}} = stack_pool:get_last_stack (self()),
	mnesia_play:update_mp (PlayerPid, MpRest),
	
	PreviousZone = card_utility:check_card_zone(CardOwner, CardOrder, CardID),
	%smo_logger:msg("------------------casting_card---------------call arena_zone:seal_to_arena"),
	
	arena_zone:seal_to_arena(CardOwner, CardOrder, CardID, [], PreviousZone),
	add_from_zone_status(CardOwner, CardOrder, CardID, PreviousZone),
	effect_activate:send_update_activate_effect (CardOwner, CardOrder, CardID, [], update),
	mnesia_play:set_game_data(self(), seal_checkup, have_seal),
	hand_zone:update_hand_data (),
	gen_server:cast(self(), {update_card_casting, PlayerPid, CardOrder, CardID, MpRest}).
	
add_from_zone_status(CardOwner, CardOrder, CardID, PreviousZone) ->
	case PreviousZone of
		hand_cards ->
			%card_utility:add_card_status (CardOwner, CardOrder, CardID, card_casting, hand_cards),
			%card_utility:add_card_status (CardOwner, CardOrder, CardID, hand_to_arena, hand_cards);
			card_utility:add_card_status (CardOwner, CardOrder, CardID, card_casting, arena_zone),
			card_utility:add_card_status (CardOwner, CardOrder, CardID, hand_to_arena, arena_zone);
		mystic_deck ->
			% card_utility:add_card_status (CardOwner, CardOrder, CardID, card_casting, mystic_deck),
			% card_utility:add_card_status (CardOwner, CardOrder, CardID, deck_to_arena, mystic_deck);
			card_utility:add_card_status (CardOwner, CardOrder, CardID, card_casting, arena_zone),
			card_utility:add_card_status (CardOwner, CardOrder, CardID, deck_to_arena, arena_zone);
		seal_deck ->
			% card_utility:add_card_status (CardOwner, CardOrder, CardID, card_casting, seal_deck),
			% card_utility:add_card_status (CardOwner, CardOrder, CardID, deck_to_arena, seal_deck);
			card_utility:add_card_status (CardOwner, CardOrder, CardID, card_casting, arena_zone),
			card_utility:add_card_status (CardOwner, CardOrder, CardID, deck_to_arena, arena_zone);
		remove_cards ->
			% card_utility:add_card_status (CardOwner, CardOrder, CardID, card_casting, remove_cards),
			% card_utility:add_card_status (CardOwner, CardOrder, CardID, remove_to_arena, remove_cards);
			card_utility:add_card_status (CardOwner, CardOrder, CardID, card_casting, arena_zone),
			card_utility:add_card_status (CardOwner, CardOrder, CardID, remove_to_arena, arena_zone);
		shrine_cards ->
			% card_utility:add_card_status (CardOwner, CardOrder, CardID, card_casting, shrine_cards),
			% card_utility:add_card_status (CardOwner, CardOrder, CardID, shrine_to_arena, shrine_cards)
			card_utility:add_card_status (CardOwner, CardOrder, CardID, card_casting, arena_zone),
			card_utility:add_card_status (CardOwner, CardOrder, CardID, shrine_to_arena, arena_zone)
	end.

% 610.6. Seal ����� Growth box ����������ö��С����Ҩзӡ�� Growth �������� Phase ��� --
%check_growth_ability () ->
%	{ok, {PlayerPid, CardOrder , CardID, _}} = stack_pool:get_last_stack(self()),
%	stack_pool:set_stack_option (self(), play, check_growth_ability),
%	case growth:get_growth_data(CardID) of
%		{ok, _} -> 
%			case growth:get_growth_option(PlayerPid, CardOrder, CardID) of
%				{can_growth, CompleteOption} ->
%					gen_server:cast(self(), {select_card_growth, PlayerPid});
%				{can_not_growth} ->
%					interfere_step:return_play(check_play_step)
%			end;
%		{error, _} -> interfere_step:return_play(check_play_step)
%	end.

%player_select_growth (PlayerPid, GrowthSelected) ->
%	stack_pool:set_stack_option (self(), growth_selected, GrowthSelected),
%	stack_pool:set_stack_option (self(), player_select_activation_ability, casting_card),
%		case GrowthSelected of
%			1 ->
%				{ _, Option} = growth:get_growth_option(PlayerPid, CardOrder, CardID),
%				CompleteOption = get_option_reply (Option),
%				gen_server:cast(self(), {update_select_growth, PlayerPid, CompleteOption, GrowthOption});
%			0 -> ""
%		end.
% cast_seal_change_zone() ->
	% stack_pool:set_stack_option(self(), play, cast_seal_change_zone),
	% continuous_ability:check_continuous_target().

% 610.7. �ҡ��ͧ�ӡ�����͡������� �ͧ Ability ������͡������¢ͧ Abiility � Phase ��� --
check_into_arena_ability() ->
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	stack_pool:set_stack_option (self(), play, check_into_arena_ability),
	mod_ability_activate:check_any_ability_activate(into_arena, PlayerPid).

% 610.8. ����� Seal ���ӡ�á�˹� Line
activate_select_line(CardOwner) ->
	gen_server:cast(self(), {act_select_line, CardOwner, casting_card}).

select_line(Data) ->
	case Data of
		[0] -> Line = 0;
		[1] -> Line = 1;
		_ -> Line = 1
	end,
	{ok, {CardOwner, CardOrder, CardID, _}} = stack_pool:get_last_stack (self()),
	stack_pool:set_stack_option (self(), assign_line, Line),
	card_utility:set_card_option_field(CardOwner, CardOrder, CardID, line, Line, arena_zone),	
	%card_utility:add_card_status (PlayerPid, CardOrder, CardID, already_assign_line_to_arena, arena_zone),
	stack_pool:set_stack_option(self(), play, casting_seal_select_line),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	gen_server:cast(self(), {update_select_line, PlayerPid, Line}).

interfere_casting_step() ->
	stack_pool:set_stack_option (self(), play, casting_seal),
	interfere_step:into_sub_interfere().
	
check_zone_post_interfere(CardOwner, CardOrder, CardID) ->
	CastZone = card_utility:check_card_zone(CardOwner, CardOrder, CardID),
	case CastZone of
		arena_zone -> cast_to_arena_10(CardOwner, CardOrder, CardID);
		_ -> 
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, card_casting, CastZone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, card_casting, CastZone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, deck_to_arena, CastZone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, hand_to_arena, CastZone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, remove_to_arena, CastZone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, shrine_to_arena, CastZone),
			{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
			reject_casting(PlayerPid, casting_condition_mismatch)
	end.

% 610.10.	��Ǩ�ͺ��ҡ�����¶١��ͧ������� ����� Seal ��Ǩ�ͺ Line ����˹� �ҡ Seal �������ö������ Line ����˹���ӡ�û�С�� Line � Step 610.8 ���� --
% ��� �ҡ Ability �������ö�觼šѺ������·���˹� ���� ������·���˹�����������Ҿ�������������  ����Ѻ������ phase 610.7 ���� ��
% �������ö��˹� Line � Phase 610.8 ������ �ҡ������������������ Ability ����ö�觼� ���� ��˹���  Ability ��鹨����ӧҹ
cast_to_arena_10(CardOwner, CardOrder, CardID) ->
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mnesia_play:set_player_data(PlayerPid, player_status, assign_cast),
	card_utility:add_card_status(CardOwner, CardOrder, CardID, card_on_arena_success, arena_zone),
	card_utility:add_card_status(CardOwner, CardOrder, CardID, cast_success, arena_zone),
	stack_pool:set_stack_option(self(), play, check_on_arena_success),
	mod_ability_activate:check_any_ability_activate(on_arena, PlayerPid).
	
check_cast_success_ability() ->
	stack_pool:set_stack_option(self(), play, check_cast_success_ability),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_activate:check_any_ability_activate(cast_success, PlayerPid).
	
verify_into_arena_ability() ->
	stack_pool:set_stack_option(self(), play, verify_into_arena_ability),
	mod_ability_activate:verify_ability_condition(into_arena).

verify_on_arena_ability() ->
	stack_pool:set_stack_option(self(), play, verify_on_arena_ability),
	mod_ability_activate:verify_ability_condition(on_arena).
	
verify_cast_success_ability() ->
	stack_pool:set_stack_option(self(), play, verify_cast_success_ability),
	mod_ability_activate:verify_ability_condition(cast_success).

cast_to_arena_10_growth_activate(CardOwner, CardOrder, CardID) ->
	case stack_pool:get_last_stack(self(), growth_selected) of
			{ok, 1} -> 
%				stack_pool:set_stack_option(self(), play, growth_activate),
				set_growth:check_support(CardOwner, CardOrder, CardID);
			_ ->	activate_into_arena_effect()
	end.

send_update_growth(CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option(self(), play, growth_activate),
	gen_server:cast(self(), {send_update_growth, CardOwner, CardOrder, CardID}),
	interfere_step:return_play(check_play_step).
	
check_growth_success_ability() ->
	stack_pool:set_stack_option(self(), play, check_growth_success_ability),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_activate:check_any_ability_activate(growth_into_arena, PlayerPid).
	
verify_growth_success_ability() ->
	stack_pool:set_stack_option(self(), play, verify_growth_success_ability),
	mod_ability_activate:verify_ability_condition(growth_into_arena).

%check_growth_into_arena() ->
%	stack_pool:set_stack_option(self(), play, activate_growth_into_arena),
%	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
%	mod_ability_activate:check_any_ability_activate(growth_into_arena, PlayerPid).

activate_growth_into_arena() ->
	stack_pool:set_stack_option(self(), play, activate_growth_into_arena),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(growth_into_arena, PlayerPid).

activate_into_arena_effect() ->
	stack_pool:set_stack_option(self(), play, activate_into_arena_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(into_arena, PlayerPid).
	
activate_on_arena_effect() ->
	stack_pool:set_stack_option(self(), play, activate_on_arena_effect),
	%stack_pool:set_stack_option(self(), play, activate_growth_success_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	mod_ability_effect:check_any_ability_activate(on_arena, PlayerPid).
	
activate_cast_success_effect() ->
%	stack_pool:set_stack_option(self(), play, activate_on_arena_effect),
	stack_pool:set_stack_option(self(), play, activate_cast_success_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	mod_ability_effect:check_any_ability_activate(cast_success, PlayerPid).
	
%activate_growth_success_effect() ->
%	stack_pool:set_stack_option(self(), play, activate_growth_success_effect),
%	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
%	mod_ability_effect:check_any_ability_activate(growth_success, PlayerPid).
	
activate_seal_on_arena_effect() ->
	stack_pool:set_stack_option (self(), play, activate_seal_on_arena_effect),
	continuous_ability:check_continuous_target().
	%interfere_step:return_play(check_play_step).
%	io:format ("Check all ability affect ~n"),
	% case ability_effect:check_all_ability_affect () of
		% 0 -> interfere_step:return_play (check_play_step);
		% _ -> card_utility:check_card_affect ()
	% end.

% 610.12.	���촷����ѧ���¨��٭������Ҿ���촷����ѧ����� Phase ��� --
cast_to_arena_11(CardOwner, CardOrder, CardID) ->
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, card_casting, arena_zone),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, card_on_arena_success, arena_zone),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, deck_to_arena, arena_zone),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, hand_to_arena, arena_zone),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, remove_to_arena, arena_zone),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, shrine_to_arena, arena_zone),
% 610.12.	������������
	%mnesia_play:set_player_data (CardOwner, player_status, assign_cast),
	card_utility:add_card_status(CardOwner, CardOrder, CardID, on_arena_success, arena_zone),
% 610.12.1.	�� Seal �����ѧ Line ����˹�
% 610.12.2.	��� Growth �зӧҹ
	stack_pool:set_stack_option(self(), play, cast_successful),
	interfere_step:return_play(check_play_step).
																											
cast_successful(CardOwner, CardOrder, CardID) ->
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	%card_utility:remove_card_status (CardOwner, CardOrder, CardID, already_assign_line_to_arena, arena_zone),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, cast_success, arena_zone),
	card_utility:add_card_status(CardOwner, CardOrder, CardID, cast_successful, arena_zone),
	effect_activate:send_update_activate_effect(CardOwner, CardOrder, CardID, [], update),
	mnesia_play:remove_player_status(PlayerPid, assign_cast),
	activate_check_next_command().
% --------------- MYSTIC ZONE ------------------
% 610.2. Ability Mystic Card ���зӧҹ ����ա�����͡��÷ӧҹ�ͧ Ability ������͡� Phase ��� ��Ш�����ա������¹�ŧ �͡�ҡ���� Effect �������ö���� --
player_cast_mystic(PlayerPid, CardOwner, CardOrder, CardID) ->
	OpponentPid = mnesia_play:get_opponent_pid(PlayerPid),
	stack_pool:push_stack(self(), CardOwner, CardOrder, CardID, [{card_player, PlayerPid}, {opponent, OpponentPid}, {play, casting_mystic}]),
	mnesia_play:set_player_data(PlayerPid, player_status, assign_cast),
	%stack_pool:set_stack_option(self(), play, casting_mystic),
	case new_mystic_check:check_mystic_ability(CardID) of
		{do_not_need_to_select, [AbilityNumber]} ->
			selected_mystic_ability(AbilityNumber);
		{need_to_select_one, _} ->
			gen_server:cast(self(), {act_select_mystic_ability, {casting, PlayerPid}, [16#88, 16#50], [<<CardID:16>>]});
		R ->	io:format("Other check mystic ability return : ~p~n", [R]),
			reject_casting(PlayerPid, no_mystic_target)			
	end.

selected_mystic_ability(AbilitySelect) ->
	stack_pool:set_stack_option(self(), mystic_ability_number, AbilitySelect),
	interfere_step:return_play(check_play_step).

%��Ǩ�ͺ Condition �ͧ����Դ Effect �ͧ Mystic ��ǧ��� 2
do_then_ability_id(CardOwner, CardOrder, CardID, MAbilityID) ->
	CardZone = arena_zone,
	OpponentPid = mnesia_play:get_opponent_pid(CardOwner),
	case new_mystic_check:check_remain_id_condition({CardZone, {CardOwner, CardOrder, CardID}}, MAbilityID, OpponentPid) of
		% Condition �ͧ����Դ Effect �١��ͧ �������͡ ������¢ͧ Mystic ��ǧ��� 2
		{ok, can_cast} -> select_then_mystic_target(CardOwner, CardOrder, CardID, MAbilityID);
		% Condition �ͧ����Դ Effect ���١��ͧ �����Դ Effect ����Ҩ��ͧ�ӵ�� �ͧ effect ��ǧ�á
		_ -> activate_mystic_to_target(CardOwner, CardOrder, CardID)
	end.
	
% ��Ǩ�ͺ Condition �ͧ�������
check_mystic_casting_condition(CardOwner, CardOrder, CardID) ->
	{ok, AbilityNumber} = stack_pool:get_last_stack(self(), mystic_ability_number),
	OpponentPid = mnesia_play:get_opponent_pid(CardOwner),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	case new_mystic_check:check_casting_condition({hand_cards, {CardOwner, CardOrder, CardID}}, AbilityNumber, OpponentPid) of
		{ok, can_cast} -> check_casting_cost(PlayerPid, CardOwner, CardOrder, CardID);
		_ -> reject_casting(PlayerPid, casting_condition_mismatch)
	end.
%��Ѻ �Ѻ������͡�������
% 610.4 ��Ǩ�ͺ Cost ��������§�����¡��ԡ�������
check_casting_cost(PlayerPid, CardOwner, CardOrder, CardID) ->
	case can_cast(PlayerPid, CardOwner, CardOrder, CardID) of
		{accept_casting, MpRest} ->
			update_mystic_casting_data(PlayerPid, CardOwner, CardOrder, CardID, MpRest);
		{reject_casting} ->
			reject_casting(PlayerPid, not_enough_mp)
	end.

% 610.5 ���� Cost �ͧ������·������ͧ���� ���촨��������Ҿ ���촷����ѧ���� �ж����ҡ��촹�������ʹ��
update_mystic_casting_data(PlayerPid, CardOwner, CardOrder, CardID, MpRest) ->
	% �ӡ���Ѿഷ ��� mp
	% �ӡ���纤�������ö�ͧ��ʵԡ �����Դ���
	%mystic_effect:keep_mystic_ability(PlayerPid, CardOrder, CardID),
	stack_pool:set_stack_option (self(), play, update_mystic_casting_data),
	mnesia_play:update_mp(PlayerPid, MpRest),
	
	%smo_logger:msg("------------------casting_card---------------call arena_zone:mytic_to_arena"),
	PreviousZone = card_utility:check_card_zone(CardOwner, CardOrder, CardID),
	arena_zone:mystic_to_arena(CardOwner, CardOrder, CardID, [{card_status, casting}], PreviousZone),
	add_from_zone_status(CardOwner, CardOrder, CardID, PreviousZone),
	{ok, AbilityNumber} = stack_pool:get_last_stack (self(), mystic_ability_number),
	{ok, Mp} = mnesia_play:get_player_data(PlayerPid, mp_rest),
	HandSize = hand_zone:check_card_size(CardOwner),
	hand_zone:update_hand_data(),
	gen_server:cast(self(), {update_casting_mystic, CardOwner, [16#88, 16#51], [CardOrder, <<CardID:16>>, HandSize, Mp, AbilityNumber, 0]}).

% 610.3. �ҡ�� Mystic Card ����ͧ�ӡ�����͡������� ��Ǩ�ͺ�����������·������ö���͡��������� �ҡ��������¡��ԡ�������
select_mystic_target(CardOwner, CardOrder, CardID) ->
	{ok, AbilityNumber} = stack_pool:get_last_stack(self(), mystic_ability_number),
	OpponentPid = mnesia_play:get_opponent_pid(CardOwner),
	% [{TargetType, MAbilityID, {SelectType, SelectAmount, Target}}|_]  = IDHaveFx
	stack_pool:set_stack_option(self(), play, select_mystic_target),
	IDHaveFx = new_mystic_check:check_mystic_ability_target({arena_zone, {CardOwner, CardOrder, CardID}}, AbilityNumber, OpponentPid),
	stack_pool:set_stack_option(self(), all_potential_mystic_ability, IDHaveFx),
	new_mystic_check:select_mystic_target().
	
select_then_mystic_target(CardOwner, CardOrder, CardID, MAbilityID) ->
	OpponentPid = mnesia_play:get_opponent_pid(CardOwner),
	% [{TargetType, MAbilityID, {SelectType, SelectAmount, Target}}|_]  = IDHaveFx
	stack_pool:set_stack_option(self(), play, select_then_mystic_target),
	CardZone = card_utility:check_card_zone(CardOwner, CardOrder, CardID),
	IDHaveFx = new_mystic_check:check_then_ability_target({CardZone, {CardOwner, CardOrder, CardID}}, MAbilityID, OpponentPid),
	stack_pool:set_stack_option(self(), all_potential_mystic_ability, IDHaveFx),
	new_mystic_check:select_mystic_target().
	
% 610.9. Interfere Step
interfere_casting_mystic_card() ->
	stack_pool:set_stack_option(self(), play, interfere_casting_mystic),
	interfere_step:into_sub_interfere().
	
verify_mystic_then_condition(CardOwner, CardOrder, CardID) ->
	CardZone = card_utility:check_card_zone(CardOwner, CardOrder, CardID),
	{ok, MAbilityID} = stack_pool:get_last_stack(self(), then_mystic_ability_id),
	OpponentPid = mnesia_play:get_opponent_pid(CardOwner),
	case new_mystic_check:check_remain_id_condition({CardZone, {CardOwner, CardOrder, CardID}}, MAbilityID, OpponentPid) of
		{ok, can_cast} -> verify_mystic_target(CardOwner, CardOrder, CardID);
		_ -> activate_mystic_to_target(CardOwner, CardOrder, CardID)
	end.
	
verify_mystic_casting_condition(CardOwner, CardOrder, CardID) ->
	case card_utility:check_card_zone(CardOwner, CardOrder, CardID) of
		arena_zone ->
			{ok, AbilityNumber} = stack_pool:get_last_stack(self(), mystic_ability_number),
			OpponentPid = mnesia_play:get_opponent_pid(CardOwner),
			case new_mystic_check:check_casting_condition({hand_cards, {CardOwner, CardOrder, CardID}}, AbilityNumber, OpponentPid) of
				{ok, can_cast} -> verify_mystic_target(CardOwner, CardOrder, CardID);
				_ -> reject_casting(CardOwner, casting_condition_mismatch)
			end;
		_ ->	activate_check_next_command()
	end.

verify_mystic_target(CardOwner, CardOrder, CardID) ->
	%stack_pool:set_stack_option(self(), play, verify_mystic_target),
	%{ok, AbilityNumber} = stack_pool:get_last_stack(self(), mystic_ability_number),
	stack_pool:set_stack_option(self(), play, verify_cast_mystic_target),
	new_mystic_check:verify_mystic_target(CardOwner, CardOrder, CardID).
	
% reselect_mystic_target(CardOwner, CardOrder, CardID) ->
	% case stack_pool:get_last_stack(self(), need_reselect_target) of
		% {ok, IdNeed} -> 
			% stack_pool:set_stack_option(self(), reselect, reselect),
			% stack_pool:set_stack_option(self(), all_potential_mystic_ability, IdNeed),
			% select_mystic_target(CardOwner, CardOrder, CardID);
		% _ -> casting_mystic_resume2(CardOwner, CardOrder, CardID)
	% end.

% 610.11. ���촷����ѧ���¨��٭������Ҿ���촷����ѧ����� Phase ��� --
casting_mystic_resume2(CardOwner, CardOrder, CardID) ->
	%io:format("Mystic Casting is {~p,~p,~p} ~n", [CardOwner, CardOrder, CardID]),
	stack_pool:set_stack_option (self(), play, casting_mystic_card_to_target),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, card_casting, arena_zone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, card_casting, arena_zone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, deck_to_arena, arena_zone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, hand_to_arena, arena_zone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, remove_to_arena, arena_zone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, shrine_to_arena, arena_zone),
% 610.12. ������������
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	mnesia_play:remove_player_status(PlayerPid, assign_cast),
	card_utility:add_card_status (CardOwner, CardOrder, CardID, cast_successful, arena_zone),
% 610.12.4. �ҡ�� Mystic Card PS, PA, PM ����仵Դ���������·���˹���� ��Ш�����Ҿ�ء���ҧ����˹���� � Phase ��� --
	%io:format("Paste Case ~p~n", [new_mystic_check:check_paste_mystic_to_target(CardOwner, CardOrder, CardID)]),
	case new_mystic_check:check_paste_mystic_to_target(CardOwner, CardOrder, CardID) of
		{ok, mystic_pasted, TPid, TOrder, Tid} ->
			DurationMystic = card_utility:get_card_option_field(CardOwner, CardOrder, CardID, duration, arena_zone),
			case DurationMystic of
				{ok, 0} ->	no_paste;
				{ok, _} ->	
					card_utility:set_card_option_field(CardOwner, CardOrder, CardID, paste_to, [{TPid, TOrder, Tid}]),
					card_utility:set_card_option_field(TPid, TOrder, Tid, mystic, [{CardOwner, CardOrder, CardID}]);
				_Other -> 
					card_utility:set_card_option_field(CardOwner, CardOrder, CardID, paste_to, [{TPid, TOrder, Tid}]),
					card_utility:set_card_option_field(TPid, TOrder, Tid, mystic, [{CardOwner, CardOrder, CardID}])
			end,
			gen_server:cast(self(), {update_cast_mystic_success, [16#88, 16#54, 0], CardOwner, CardOrder, CardID, TPid, TOrder, Tid});
		% �óշ�� Ability ����Դ�šѺ�������������ʵԡŧ shrine
		{ok, cancel_mystic, TPid, TOrder, Tid} ->
			stack_pool:set_stack_option(self(), card_cancel_mystic, move_to_shrine),
			gen_server:cast(self(), {update_cast_mystic_success, [16#88, 16#54, 0], CardOwner, CardOrder, CardID, TPid, TOrder, Tid});
		{ok, paste_on_arena} ->
			gen_server:cast(self(), {update_cast_mystic_success, [16#88, 16#54, 1], CardOwner, CardOrder, CardID, 0, 0, 0});
		{ok, activate_effect_and_move_to_shrine} ->
			gen_server:cast(self(), {update_cast_mystic_success, [16#88, 16#54, 3], CardOwner, CardOrder, CardID, 0, 0, 0});
			%gen_server:cast(self(), {update_cast_mystic_success, [16#88, 16#54, 0], CardOwner, CardOrder, CardID, TPid, TOrder, Tid});
		{ok,no_target_then_move_to_shrine} ->
			gen_server:cast(self(), {update_cast_mystic_success, [16#88, 16#54, 3], CardOwner, CardOrder, CardID, 0, 0, 0})
	end.
	
mystic_change_zone() ->
	stack_pool:set_stack_option(self(), play, play_activate_mystic_change_zone),
	continuous_ability:check_continuous_target().	

% 610.12.5. Ability �ͧ Mystic Card �����������稨зӧҹ
activate_mystic_to_target(CardOwner, CardOrder, CardID) ->
	%mystic_effect:update_ability_continues (),
	MAbility = stack_pool:get_last_stack (self(), result_target),
%	io:format ("Mystic ability effect ~p~n", [MAbility]),
	case MAbility of
		{ok, []} ->
			%stack_pool:remove_stack_option (self(), target_selected),
			check_cancel_mystic_effect(CardOwner, CardOrder, CardID);
		{ok, [MAbilityTuple| MAbilityRest]} ->
			stack_pool:set_stack_option(self(), result_target, MAbilityRest),
			%stack_pool:add_stack_option_field(self(), mystic_ability_activated, [MAbilityTuple]),
			stack_pool:set_stack_option(self(), play, play_activate_mystic_casting_effect),
			mystic_effect:set_activate_mystic_to_target(CardOwner, CardOrder, CardID, MAbilityTuple);
		_ -> 
			stack_pool:set_stack_option(self(), card_cancel_mystic, move_to_shrine),
			check_cancel_mystic_effect(CardOwner, CardOrder, CardID) 
	end.
	
check_cancel_mystic_effect(CardOwner, CardOrder, CardID) ->
	case stack_pool:get_last_stack(self(), card_cancel_mystic) of
		{ok, move_to_shrine} -> 	
			%smo_logger:msg("----------------------move mystic to shrine----------------------"),
			stack_pool:set_stack_option(self(), play, move_cancel_mystic_to_shrine),
			{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
			shrine_zone:card_to_shrine(PlayerPid, [{CardOwner, CardOrder, CardID}]);
		_ -> check_send_fx_and_duration_mystic(CardOwner, CardOrder, CardID)
	end.	
	
% update_casting_mystic_success (PlayerPid, CardOrder, CardID) ->
	% stack_pool:set_stack_option (self(), play, cast_mystic_complete),
	% MysticTarget = stack_pool:get_last_stack (self(), pasted_target_mystic),
% %	io:format ("Mystic target ~p~n", [MysticTarget]),
	% case MysticTarget of
		% {ok, [{TPid, TOrder, Tid} | _]} ->
			% send_update_cast_mystic_success (PlayerPid, CardOrder, CardID, TPid, TOrder, Tid);
		% _ ->	send_update_cast_mystic_success (PlayerPid, CardOrder, CardID, 0, 0, 0)
	% end.

% send_update_cast_mystic_success (PlayerPid, CardOrder, CardID, TPid, TOrder, Tid) ->
	% CanPaste = stack_pool:get_last_stack (self(), can_pasted),
% %	io:format ("Mystic paste ~p~n", [CanPaste]),
	% case CanPaste of
		% {ok, yes} ->
			% gen_server:cast(self(), {update_cast_mystic_success, [16#88, 16#54, 0], PlayerPid, CardOrder, CardID, TPid, TOrder, Tid});
		% {ok, no} ->
			% gen_server:cast(self(), {update_cast_mystic_success, [16#88, 16#54, 0], PlayerPid, CardOrder, CardID, TPid, TOrder, Tid});
		% {ok, on_arena} ->
			% gen_server:cast(self(), {update_cast_mystic_success, [16#88, 16#54, 1], PlayerPid, CardOrder, CardID, 0, 0, 0});
		% {ok, non_pasted} ->
			% gen_server:cast(self(), {update_cast_mystic_success, [16#88, 16#54, 3], PlayerPid, CardOrder, CardID, 0, 0, 0})
	% end.

% 610.13. ����鹵͹��û�С������ �ӡ��촷���С�������͡�ҡ��û�С������ �ҡ�� Mystic Card ��Դ 0 Turn ���� Mystic Card ���ŧ Shrine � Phase ��� --
check_send_fx_and_duration_mystic(CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option(self(), play, play_check_send_fx_and_duration_mystic),
	DurationMystic = card_utility:get_card_option_field(CardOwner, CardOrder, CardID, duration, arena_zone),
	case DurationMystic of
		{ok, 0} ->	
			{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
			shrine_zone:card_to_shrine(PlayerPid, [{CardOwner, CardOrder, CardID}]);
		{ok, _} ->	activate_check_next_command();
		_Other -> activate_check_next_command()
	end.

activate_check_next_command() ->
	stack_pool:set_stack_option (self(), play, play_activate_check_next_command),
	continuous_ability:check_continuous_target().

next_command_to_client() ->
	hand_zone:update_hand_data(),
	stack_pool:pop_stack_out (self()),
	case stack_pool:get_last_stack(self(), play) of
		{ok, StackPlay} -> interfere_step:return_play(StackPlay);
		{error, _} -> gen_server:cast(self(), {act_next_command})
	end.
% ------------------------------- Misc Zone ------------------------------------ %
can_cast (PlayerPid, CardOwner, CardOrder, CardID) ->
	case get(paying_cost) of
		no -> 
			{ok, PlayerMp} = mnesia_play:get_player_data(PlayerPid, mp_rest),
			erase(paying_cost),
			{accept_casting, PlayerMp};
		_ ->
			CastZone= card_utility:check_card_zone(CardOwner, CardOrder, CardID),
			Cost = game_info:card_mpcast({CastZone, {CardOwner, CardOrder, CardID}}),
			%smo_logger:fmsg("Card {~p, ~p} Casting Mp is ~p", [PlayerPid, CardID, MpChange]),
			{ok, PlayerMp} = mnesia_play:get_player_data(PlayerPid, mp_rest),
			case stack_pool:get_last_stack (self(), continue_ability) of
				{ok, true} ->
					{accept_casting, PlayerMp};
				_ ->	
					CastingCost = 
					if
						Cost > 0 -> Cost;
						true -> 0
					end,
					if
						PlayerMp < CastingCost -> {reject_casting};
						true -> {accept_casting, PlayerMp - CastingCost}
					end
			end
	end.
	
% seal_casting_without_paying_cost (PlayerPid, CardOwner, CardOrder, CardID) ->
	% PlayStepBefore = stack_pool:get_last_stack (self(), play),
	% OpponentPid = mnesia_play:get_opponent_pid(PlayerPid),
	% stack_pool:push_stack (self(), CardOwner, CardOrder, CardID, [{play, casting_seal}, {card_player, PlayerPid}, {opponent, OpponentPid}]),
	% mnesia_play:set_player_data (PlayerPid, player_status, assign_cast),
	% stack_pool:set_stack_option (self(), play, casting_card_to_arena), % Growth ��ͨҡ���
% 
	% PreviousZone = card_utility:check_card_zone(CardOwner, CardOrder, CardID),
	% %smo_logger:msg("------------------casting_card---------------call arena_zone:seal_to_arena"),
	% 
	% arena_zone:seal_to_arena(CardOwner, CardOrder, CardID, [], PreviousZone),
	% add_from_zone_status(CardOwner, CardOrder, CardID, PreviousZone),
	% effect_activate:send_update_activate_effect (CardOwner, CardOrder, CardID, [], update),
	% mnesia_play:set_game_data(self(), seal_checkup, have_seal),
	% hand_zone:update_hand_data (),
	% {ok, MpRest} = mnesia_play:get_player_data(CardOwner, mp_rest),
	% gen_server:cast(self(), {update_card_casting, CardOwner, CardOrder, CardID, MpRest}).
