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
-module (line_change).

-compile (export_all).

reject_change_line (_, CardOrder, CardID, Reason) ->
	io:format("Reject change line -~p-~n", [Reason]),
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	stack_pool:pop_stack_out (self()),
	case Reason of
		no_card_on_arena ->
			gen_server:cast(self(), {reject_change_line, PlayerPid, CardOrder, CardID, 0});
		already_changed ->
			gen_server:cast(self(), {reject_change_line, PlayerPid, CardOrder, CardID, 1});
		seal_inactive ->
			gen_server:cast(self(), {reject_change_line, PlayerPid, CardOrder, CardID, 2});
		curse_condition ->
			gen_server:cast(self(), {reject_change_line, PlayerPid, CardOrder, CardID, 3});
		line_condition ->
			gen_server:cast(self(), {reject_change_line, PlayerPid, CardOrder, CardID, 4});
		wrong_line_change ->
			gen_server:cast(self(), {reject_change_line, PlayerPid, CardOrder, CardID, 5});
		curse_effect ->
			gen_server:cast(self(), {reject_change_line, PlayerPid, CardOrder, CardID, 6});
		disallow_assign_line ->
			gen_server:cast(self(), {reject_change_line, PlayerPid, CardOrder, CardID, 7});
		controller_not_allow ->
			gen_server:cast(self(), {reject_change_line, PlayerPid, CardOrder, CardID, 8});
		_ ->	
			gen_server:cast(self(), {reject_change_line, PlayerPid, CardOrder, CardID, 99})
	end.

%% 516. ��鹵͹��á�˹� Line �ҡ Line ˹����ѧ�ա Line ˹��
assign_change_line (PlayerPid, CardOwner, CardOrder, CardID, ChangeType) ->
	% ��Ǩ�ͺ���Ǻ�������㺹��� ��Ҽ��Ǻ����繤����ǡѺ��Ңͧ����������� -
	stack_pool:push_stack(self(), CardOwner, CardOrder, CardID, [{play, changing_line}, {card_player, PlayerPid}, {change_type, ChangeType}]),
	OppPid = mnesia_play:get_opponent_pid(CardOwner),
	{ControllerPid, _UncontPid, _} = attribute_check:check_controller({CardOwner, CardOrder, CardID}, OppPid, controller),
	case ControllerPid of
	 	PlayerPid -> line_change_check_condition(CardOwner, CardOrder, CardID, ChangeType);
		_ ->reject_change_line(CardOwner, CardOrder, CardID, controller_not_allow)
	end.
			
		% CardOwner -> % ��Ңͧ�Ѻ���Ǻ����繤����ǡѹ
			% case PlayerPid of
				% CardOwner -> % �����蹡Ѻ���Ǻ����繤����ǡѹ
					% line_change_check_condition (CardOwner, CardOrder, CardID, ChangeType);
				% _ ->	reject_change_line (CardOwner, CardOrder, CardID, controller_not_allow)
			% end;
		% _ -> % ��Ңͧ�Ѻ���Ǻ�������褹���ǡѹ
			% case PlayerPid of
				% CardOwner -> % �����蹡Ѻ���Ǻ�������褹���ǡѹ
					% reject_change_line (CardOwner, CardOrder, CardID, controller_not_allow);
				% _ ->	line_change_check_condition (CardOwner, CardOrder, CardID, ChangeType)
			% end
	%end.

line_change_check_condition (CardOwner, CardOrder, CardID, ChangeType) ->
	case check_seal_condition (CardOwner, CardOrder, CardID) of
		{ok, allow} ->
			case check_effect_stop (CardOwner, CardOrder, CardID, ChangeType) of
				{ok, allow} ->
					{ok, CardLine} = card_utility:get_card_option_field (CardOwner, CardOrder, CardID, line, arena_zone),
					check_change_type (CardOwner, CardOrder, CardID, ChangeType, CardLine);
				{ok, disallow, Reason} ->
					reject_change_line (CardOwner, CardOrder, CardID, Reason)
			end;
		{ok, disallow, Reason} ->
			reject_change_line (CardOwner, CardOrder, CardID, Reason)
	end.

%% 516.1. ��С�� Seal ����ͧ������� Line �� Seal ����С�ȵ�ͧ����� Line � Line ˹�� ��Ǩ�ͺ
%% ���͹䢡�á�˹� Line ������͹����ú��� �� Seal �͡�ҡ��á�˹� Line �����¡����繡����� Seal ��˹� Line � Phase ���
check_seal_condition (CardOwner, CardOrder, CardID) ->
	case card_utility:check_card_status (CardOwner, CardOrder, CardID, assign_line, arena_zone) of
		{ok, have_status} -> {ok, disallow, already_changed};
		{ok, have_no_status} -> check_card_active (CardOwner, CardOrder, CardID);
		{error, Reason} -> {ok, disallow, Reason}
	end.

check_card_active(CardOwner, CardOrder, CardID) ->
	case card_utility:check_card_active(CardOwner, CardOrder, CardID) of
		active_seal -> {ok, allow};
		inactive_seal -> {ok, disallow, seal_inactive}
	end.

check_effect_stop (CardOwner, CardOrder, CardID, ChangeType) ->
	case arena_zone:get_all_effect (CardOwner, CardOrder, CardID) of
		{ok, AllEffect} ->
			%smo_logger:fmsg("Card all Effect are ~p~n", [AllEffect]),
			case curse:check_curse_status (AllEffect, assign_line) of
				{ok, allow} ->
					check_other_effect (AllEffect, ChangeType);
				{ok, disallow} ->
					{ok, disallow, curse_effect}
			end;
		{error, Reason} -> {ok, disallow, Reason}
	end.

check_other_effect ([], _) -> {ok, allow};
check_other_effect ([{_, Effect, _} | T], ChangeType) ->
	case check_disallow_assign_line (Effect, ChangeType) of
		{ok, allow} -> check_other_effect (T, ChangeType);
		{ok, disallow} -> {ok, disallow, disallow_assign_line}
	end.

check_disallow_assign_line ([], _) -> {ok, allow};
check_disallow_assign_line ([{disallow, assign_line} | _], _) -> {ok, disallow};
check_disallow_assign_line ([{disallow, assign_line_to_df} | _], 1) -> {ok, disallow};
check_disallow_assign_line ([{disallow, assign_line_to_at} | _], 0) -> {ok, disallow};
check_disallow_assign_line ([{change_line, disallow}| _], _) -> {ok, disallow};
check_disallow_assign_line ([_ | T], ChangeType) -> check_disallow_assign_line (T, ChangeType).

% 516.2. ��С�� Line ����ͧ������ Seal �������� �·�� Line ��鹵�ͧ����� Line ������ Seal ���
check_change_type (CardOwner, CardOrder, CardID, ChangeType, Line) ->
	io:format ("Change line type ~p From line ~p~n", [ChangeType, Line]),
	case ChangeType of
		Line -> io:format ("Change line type ~p From line ~p~n", [ChangeType, Line]),
			set_card_status (CardOwner, CardOrder, CardID, ChangeType);
		_ ->	reject_change_line (CardOwner, CardOrder, CardID, wrong_line_change)
	end.

% 516.3. ���¡ Seal ���١��С����� Seal �����ѧ��˹� Line Ability ���зӧҹ ����� Seal ��˹� Line����
% ��˹� Line ����� ����ա�����͡��÷ӧҹ�ͧ Ability �������͡�������������͡� Phase ���
set_card_status(CardOwner, CardOrder, CardID, ChangeType) ->
	card_utility:add_card_status(CardOwner, CardOrder, CardID, changing_line, arena_zone),
	card_utility:add_card_status(CardOwner, CardOrder, CardID, changed_line, arena_zone),
	io:format("set_card_status ~n"),
	stack_pool:set_stack_option(self(), play, update_seal_changing_line),
	gen_server:cast(self(), {update_seal_changing_line, CardOwner, CardOrder, CardID, ChangeType}).
% Ability ���������¹�Ź� ���͡��÷ӧҹ
check_changing_line_ability() ->
	stack_pool:set_stack_option(self(), play, check_changing_line_ability),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_activate:check_any_ability_activate(changing_line, PlayerPid).
% Ability ���������¹�Ź������ ���͡��÷ӧҹ
check_change_line_ability() ->
	stack_pool:set_stack_option(self(), play, check_change_line_ability),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_activate:check_any_ability_activate(change_line, PlayerPid).
	
%516.4.  Interfere Step
into_sub_interfere() ->
	stack_pool:set_stack_option(self(), play, get_into_change_line_sub_interfere),
	interfere_step:into_sub_interfere().

% 516.5. �ҡ Ability �������ö�觼šѺ������·���˹� ���� ������·���˹�����������Ҿ����
% ��������� ����Ѻ����͡������¢ͧ Ability� phase 516.3 ���訹���Ҩ������������·�� Ability ����ö�觼� ���� ��˹���
resume_changing_line(CardOwner, CardOrder, CardID) ->
	case card_utility:check_card_zone(CardOwner, CardOrder, CardID) of
		arena_zone ->
			%stack_pool:set_stack_option (self(), play, play_change_line_5),
			{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
			% ��Ǩ�ͺ���Ǻ�������㺹��� ��Ҽ��Ǻ����繤����ǡѺ��Ңͧ����������� -
			OppPid = mnesia_play:get_opponent_pid(CardOwner),
			{ControllerPid, _UncontPid, _} = attribute_check:check_controller({CardOwner, CardOrder, CardID}, OppPid, controller),
			case ControllerPid of
				PlayerPid ->
					verify_change_line(CardOwner, CardOrder, CardID);
				_ ->	
					card_utility:remove_card_status(CardOwner, CardOrder, CardID, changing_line, arena_zone),
					card_utility:remove_card_status(CardOwner, CardOrder, CardID, changed_line, arena_zone),
					reject_change_line(CardOwner, CardOrder, CardID, controller_not_allow)
			end;
				% controller_not_allow -> % ��Ңͧ�Ѻ���Ǻ�������褹���ǡѹ
					% case PlayerPid of
						% CardOwner -> % �����蹡Ѻ���Ǻ�������褹���ǡѹ
							% card_utility:remove_card_status(CardOwner, CardOrder, CardID, changing_line, arena_zone),
							% card_utility:remove_card_status(CardOwner, CardOrder, CardID, changed_line, arena_zone),
							% reject_change_line(CardOwner, CardOrder, CardID, controller_not_allow);
						% _ ->	%interfere_step:return_play (check_play_step)
							% verify_change_line(CardOwner, CardOrder, CardID)
					% end
			% end;
		_ -> reject_change_line(CardOwner, CardOrder, CardID, no_card_on_arena)
	end.
	
% 516.6. ��Ǩ�ͺ���͹䢡�á�˹� Line ������͹����ú��� Seal �����ѧ��˹� Line �٭������Ҿ Seal �����ѧ��˹� Line ��й� Seal �͡�ҡ��á�˹� Line
verify_change_line(CardOwner, CardOrder, CardID) ->
	%stack_pool:set_stack_option (self(), play, play_change_line_6),
	%card_utility:remove_card_status(CardOwner, CardOrder, CardID, changing_line, arena_zone),
	case check_seal_condition(CardOwner, CardOrder, CardID) of
		{ok, allow} ->
			{ok, ChangeType} = stack_pool:get_last_stack(self(), change_type),
			case check_effect_stop(CardOwner, CardOrder, CardID, ChangeType) of
				{ok, allow} ->
					{ok, Line} = card_utility:get_card_option_field(CardOwner, CardOrder, CardID, line, arena_zone),
					recheck_change_type(CardOwner, CardOrder, CardID, ChangeType, Line);
				{ok, disallow, Reason} ->
					card_utility:remove_card_status(CardOwner, CardOrder, CardID, changing_line, arena_zone),
					card_utility:remove_card_status(CardOwner, CardOrder, CardID, changed_line, arena_zone),
					reject_change_line(CardOwner, CardOrder, CardID, Reason)
			end;
		{ok, disallow, Reason} ->
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, changing_line, arena_zone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, changed_line, arena_zone),
			reject_change_line(CardOwner, CardOrder, CardID, Reason)
	end.
	
recheck_change_type(CardOwner, CardOrder, CardID, ChangeType, Line) ->
	io:format ("Change line type ~p From line ~p~n", [ChangeType, Line]),
	case ChangeType of
		Line -> 
			% 516.7. ��á�˹� Line ��������ó����� Seal ���ѧ Line ��赹�ͧ��˹���ШѴ�ҧ㹵��˹觷���ͧ���
			{ok, LineChange} = arena_zone:change_arena_line(CardOwner, CardOrder, CardID),
			stack_pool:set_stack_option(self(), play, update_changed_line),
			gen_server:cast(self(), {update_changed_line, CardOwner, CardOrder, CardID, LineChange});
		_ ->	
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, changing_line, arena_zone),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, changed_line, arena_zone),
			reject_change_line(CardOwner, CardOrder, CardID, wrong_line_change)
	end.
	
changing_line_ability_verify() ->
	stack_pool:set_stack_option(self(), play, changing_line_ability_verify),
	mod_ability_activate:verify_ability_condition(changing_line).
	
change_line_ability_verify() ->
	stack_pool:set_stack_option(self(), play, change_line_ability_verify),
	mod_ability_activate:verify_ability_condition(change_line).
			
% 516.8. ��Ǩ�ͺ��� Ability ��鹶١��ͧ������͹�㹡�÷ӧҹ������� ������͹����ú Ability ��鹨����ӧҹ
% ���� �ҡ�����������·�� Ability ����ö�觼� ���� ��˹��� Ability ��鹨����ӧҹ ������͹�㹡���Դ Ability �ѧ���١��ͧ
% �����������·��١��ͧ Ability ����� Seal ��˹� Line ��������� Seal ��˹� Line ����稨зӧҹ � Phase ��� --		
activate_changing_line_effect() ->
	stack_pool:set_stack_option (self(), play, activate_changing_line_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(changing_line, PlayerPid).
	
activate_change_line_effect() ->
	stack_pool:set_stack_option(self(), play, activate_change_line_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(change_line, PlayerPid).

% 516.9. ����鹵͹��á�˹� Line Seal �����ѧ��˹� Line �٭������Ҿ Seal �����ѧ��˹� Line
% ��й� Seal ����С�ȡ�˹� Line �͡�ҡ��û�С�ȡ�˹� Line
activate_as_on_line_effect() ->
	stack_pool:set_stack_option(self(), play, activate_as_on_line_effect),
	% case ability_effect:check_all_ability_affect () of
		% 0 -> interfere_step:return_play(check_play_step);
		% _ -> 	card_utility:check_card_affect()
	% end.
	continuous_ability:check_continuous_target().

																													
																													% assign_line_9 () ->
																														% stack_pool:set_stack_option (self(), play, play_assign_line_9),
																														% case ability_effect:check_all_ability_affect () of
																															% 0 -> interfere_step:return_play (check_play_step);
																															% _ -> card_utility:check_card_affect()
																														% end.

assign_line_9_1 (CardOwner, CardOrder, CardID) ->
	stack_pool:pop_stack(self()),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, changing_line, arena_zone),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, changed_line, arena_zone),
	card_utility:add_card_status(CardOwner, CardOrder, CardID, assign_line, arena_zone),
	gen_server:cast(self(), {act_next_command}).

check_target_ability () -> todo.

%change_line ([]) -> interfere_step:return_play (check_play_step);
change_line(CardChange) ->
	lists:foreach(
								fun({CardOwner, CardOrder, CardID}) -> 
									case card_utility:get_card_option_field (CardOwner, CardOrder, CardID, line, arena_zone) of
										{ok, 1} ->	update_move_to_line (CardOwner, CardOrder, CardID, 0);
										{ok, 0} -> update_move_to_line (CardOwner, CardOrder, CardID, 1);
										Any -> io:format ("Can not change line : ~p~n", [Any])
									end
								end, CardChange),
	interfere_step:return_play(check_play_step).

%move_to_line([], _) -> 
move_to_line(ChangeLine, LineMove) ->
	lists:foreach(fun({CardOwner, CardOrder, CardID}) -> update_move_to_line(CardOwner, CardOrder, CardID, LineMove) end, ChangeLine),
	interfere_step:return_play(check_play_step).
	
move_to_line(CardToChange) ->
	lists:foreach(fun({CardOwner, CardOrder, CardID}) ->
		{ok, Result} = card_utility:get_card_option_field(CardOwner, CardOrder, CardID, line, arena_zone),
		ToLine =
		case Result of
			0 -> 1;
			1 -> 0
		end,
		update_move_to_line(CardOwner, CardOrder, CardID, ToLine) end, CardToChange),
	interfere_step:return_play(check_play_step).

update_move_to_line(CardOwner, CardOrder, CardID, LineMove) ->
	CardFx = card_utility:get_all_card_effect(CardOwner, CardOrder, CardID, arena_zone),
	case function_utility:is_contain([{change_line, disallow}], CardFx) of
		[] ->
			arena_zone:assign_to_line (CardOwner, CardOrder, CardID, LineMove),
			gen_server:cast(self(), {move_card_to_line, CardOwner, CardOrder, CardID, LineMove});
		_ -> do_noting
	end.
	
