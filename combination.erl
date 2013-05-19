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
-module (combination).

-import (lists, [split/2, append/2, flatlength/1]).

-compile (export_all).

rejected_combine (PlayerPid, Reason) ->
	io:format ("Reject combine reason ~p~n", [Reason]),
	case Reason of
		no_combine_option -> gen_server:cast(self(), {rejected_combination, PlayerPid, 0});
		not_enough_sub -> gen_server:cast(self(), {rejected_combination, PlayerPid, 1});
		wrong_combine_option -> gen_server:cast(self(), {rejected_combination, PlayerPid, 2});
		combined -> gen_server:cast(self(), {rejected_combination, PlayerPid, 3});
		cursed_effect -> gen_server:cast(self(), {rejected_combination, PlayerPid, 4});
		card_inactive -> gen_server:cast(self(), {rejected_combination, PlayerPid, 5});
		no_support_set -> gen_server:cast(self(), {rejected_combination, PlayerPid, 6});
		cancel_combine -> gen_server:cast(self(), {rejected_combination, PlayerPid, 7});
		be_combine -> gen_server:cast(self(), {rejected_combination, PlayerPid, 8});
		cannot_combine_interfere -> gen_server:cast(self(), {rejected_combination, PlayerPid, 9});
		controller_not_allow -> gen_server:cast(self(), {rejected_combination, PlayerPid, 10});
		_ -> gen_server:cast(self(), {rejected_combination, PlayerPid, 99})
	end.

rejected_combine_return(PlayerPid, Reason) ->
	case Reason of
		no_combine_option -> gen_server:cast(self(), {rejected_combination, PlayerPid, 0});
		not_enough_sub -> gen_server:cast(self(), {rejected_combination, PlayerPid, 1});
		wrong_combine_option -> gen_server:cast(self(), {rejected_combination, PlayerPid, 2});
		combined -> gen_server:cast(self(), {rejected_combination, PlayerPid, 3});
		cursed_effect -> gen_server:cast(self(), {rejected_combination, PlayerPid, 4});
		card_inactive -> gen_server:cast(self(), {rejected_combination, PlayerPid, 5});
		no_support_set -> gen_server:cast(self(), {rejected_combination, PlayerPid, 6});
		cancel_combine -> gen_server:cast(self(), {rejected_combination, PlayerPid, 7});
		be_combine -> gen_server:cast(self(), {rejected_combination, PlayerPid, 8});
		cannot_combine_interfere -> gen_server:cast(self(), {rejected_combination, PlayerPid, 9});
		controller_not_allow -> gen_server:cast(self(), {rejected_combination, PlayerPid, 10});
		_ -> gen_server:cast(self(), {rejected_combination, PlayerPid, 99})
	end,
	next_command_to_client().
	
	
check_combined_status(CardOwner, CardOrder, CardID) ->
	case card_utility:check_card_status(CardOwner, CardOrder, CardID, combined, arena_zone) of
		{ok, have_status} -> {disallow, combined};
		{ok, have_no_status} -> check_be_combine_condition(CardOwner, CardOrder, CardID)
	end.

check_be_combine_condition(CardOwner, CardOrder, CardID) ->
	case card_utility:check_card_status(CardOwner, CardOrder, CardID, be_combine, arena_zone) of
		{ok, have_status} ->
			{disallow, be_combine};
		{ok, have_no_status} ->
			check_curse_condition_permit(CardOwner, CardOrder, CardID)
	end.

check_curse_condition_permit(CardOwner, CardOrder, CardID) ->
	CardFx = card_utility:get_all_card_effect (CardOwner, CardOrder, CardID),
	case curse:check_curse_status (CardFx, combine) of
		{ok, allow} -> {allow};
		{ok, disallow} -> {disallow, cursed_effect}
	end.

declare_combination(PlayerPid, CardOwner, CardOrder, CardID) ->
	% ��Ǩ�ͺ���Ǻ�������㺹��� ��Ҽ��Ǻ����繤����ǡѺ��Ңͧ�����������
	OppPid = mnesia_play:get_opponent_pid(CardOwner),
	{ControllerPid, _UncontPid, _} = attribute_check:check_controller({CardOwner, CardOrder, CardID}, OppPid, controller),
	% ��Ǩ�ͺ���Ǻ�������㺹��� ��Ҽ��Ǻ����繤����ǡѺ��Ңͧ����������� -
	case ControllerPid of
		PlayerPid -> check_combination_condition(PlayerPid, CardOwner, CardOrder, CardID);
		% controller_not_allow ->
			% case PlayerPid of
				% CardOwner ->
		_ -> rejected_combine(PlayerPid, controller_not_allow)
				% _ ->	check_combination_condition(PlayerPid, CardOwner, CardOrder, CardID)
			% end
	end.

check_combination_condition(PlayerPid, CardOwner, CardOrder, CardID) ->
	case stack_pool:get_last_stack (self(), play) of
		{ok, activate_skill_to_card} ->
			case card_utility:check_card_active(CardOwner, CardOrder, CardID) of
				active_seal -> check_seal_condition(PlayerPid, CardOwner, CardOrder, CardID);
				inactive_seal -> rejected_combine(PlayerPid, card_inactive)
			end;
		% {ok, return_to_check_skill_effect_affect} ->
			% case card_utility:check_card_active(CardOwner, CardOrder, CardID) of
				% active_seal -> check_seal_condition(PlayerPid, CardOwner, CardOrder, CardID);
				% inactive_seal -> rejected_combine(PlayerPid, card_inactive)
			% end;
		{ok, _} -> rejected_combine(PlayerPid, cannot_combine_interfere);
		_ ->	
			case card_utility:check_card_active(CardOwner, CardOrder, CardID) of
				active_seal -> check_seal_condition(PlayerPid, CardOwner, CardOrder, CardID);
				inactive_seal -> rejected_combine(PlayerPid, card_inactive)
			end
	end.

% 512.1. ��С�� Seal ���з� Combination �����¡����繡����� Seal �� Combination � Phase ��� --
check_seal_condition(PlayerPid, CardOwner, CardOrder, CardID) ->
	case check_combined_status(CardOwner, CardOrder, CardID) of
		{allow} ->
			card_utility:add_card_status(CardOwner, CardOrder, CardID, combination, arena_zone),
			stack_pool:push_stack(self(), CardOwner, CardOrder, CardID, [{play, select_combination_option}, {card_player, PlayerPid}]),
			check_combination_choise(CardOwner, CardOrder, CardID);
		{disallow, Reason} -> rejected_combine(PlayerPid, Reason)
	end.

% 512.2. ��С�ȡ�÷� Combination ��Ҩз���ٻẺ� ��з�����վ�����
check_combination_choise(CardOwner, CardOrder, CardID) ->
	case material_search:get_combination_option(CardOwner, CardOrder, CardID) of
		{have_choise, CompleteCheck} ->
			check_send_select_option(CardOwner, CardOrder, CardID, CompleteCheck);
		{no_choise, Reason} ->
			{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
			card_utility:remove_card_status(CardOwner, CardOrder, CardID, combination, arena_zone),
			%stack_pool:pop_stack_out(self()),
			rejected_combine_return(PlayerPid, Reason)
	end.

% {1,2,[{elem, 1}]}, {2,4,[{elem, 1},{elem, 1}]}, {1,2,[{elem, 6}]}, {1,2,["Br"]}
check_send_select_option(CardOwner, CardOrder, CardID, CompleteCheck) ->
	case lists:flatlength(CompleteCheck) of
		1 ->	CompleteOption = get_option_reply(CompleteCheck),
			{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
			gen_server:cast(self(), {act_combine_option, PlayerPid, [16#88, 16#5a], [1] ++ CompleteOption, CompleteCheck});
			%gen_server:cast(self(), {act_combine_option, CardOwner, [16#88, 16#5a], [1] ++ CompleteOption, CompleteCheck});
		_ -> check_order_combine(CardOwner, CardOrder, CardID, CompleteCheck)
	end.

% ��Ǩ�ͺ��������ҧ���з��������ӴѺ��������ҧ����������ö���͡��������� --
check_order_combine(CardOwner, CardOrder, CardID, CompleteCheck) ->
	% MustCheck ��͵�ͧ���ҵ�Ǩ�ͺ ���ͧ�ҡ�繷�� Double Combine
	% CanReply ��ͷ�� Triple Combine ����Ѻ�͹����ѧ�����繵�ͧ��Ǩ�ͺ
	% SupportOption ��� ��ҷ���ͧ�ӡ�õ�Ǩ�ͺ��ҷ�ҹ������ӴѺ��������ҧ������� --
	{MustCheck, CanReply, SupportOption} = check_order_double_combine(CompleteCheck),
%	io:format("Must Check ~p~n", [MustCheck]),
	
	case flatlength(MustCheck) of
		0 ->	OptionPass = CanReply;
		1 ->	OptionPass = MustCheck ++ CanReply;
		_ ->	
			%{ok, Arena} = mnesia_play:get_player_data(PlayerPid, arena_zone),
			{ok, Arena} = mnesia_play:get_player_data(CardOwner, arena_zone),
			ArenaCheck = material_search:filter_can_support(card_utility:remove (Arena, CardOwner, CardOrder, CardID)),
			BeOption = check_must_select_option(MustCheck, SupportOption, ArenaCheck),
			OptionPass = BeOption ++ CanReply
	end,	
	CompleteSize = flatlength(OptionPass),
	CompleteOption = get_option_reply(OptionPass),
%	io:format("Option Pass ~p~n", [OptionPass]),
%	io:format("Complete Option ~p~n", [CompleteOption]),

	% ��Ңͧ���͡��������ҧ
	%gen_server:cast(self(), {act_combine_option, CardOwner, [16#88, 16#5a], [CompleteSize] ++ CompleteOption, CompleteCheck}).
	% ����������͡��������ҧ
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	gen_server:cast(self(), {act_combine_option, PlayerPid, [16#88, 16#5a], [CompleteSize] ++ CompleteOption, CompleteCheck}).

get_arena_check_data ([]) -> [];
get_arena_check_data ([{Card, _} | Arena]) -> [Card] ++ get_arena_check_data (Arena).

% [{1,2,[{elem, 6}]}, {1,2,["Br"]}]
% ��Ǩ�ͺ����շ�� Double Combine �������� ���Ǩе�ͧ���ӴѺ�����Ӥѭ������� --
check_order_double_combine ([]) -> {[], [], []};
check_order_double_combine ([{Order, 3, SupportList} | T]) ->
	{MustCheck, CanReply, SupportOption} = check_order_double_combine (T),
	{[{Order, 3, SupportList}] ++ MustCheck, CanReply, SupportList ++ SupportOption};
check_order_double_combine ([{Order, SupportSize, SupportList} | T]) ->
	{MustCheck, CanReply, SupportOption} = check_order_double_combine (T),
	{MustCheck, [{Order, SupportSize, SupportList}] ++ CanReply, SupportOption}.

% ����������§��������Ƿ�� �� ����ͧ��� �Ѻ �ҧ���͡��� �����Ѻ�������ö���͡ �ҧ���͡����� --
% ��ҷء� ����ö�繷ҧ���͡���������Ǩ�ͺ��� �ҧ���͡���������дѺ�٧�����������
check_same_card_option ([] , _) -> {priority_check};
check_same_card_option ([{CardOwner, CardOrder, CardID} | T], SupportOption) ->
	case check_one_card_many_support (CardOwner, CardOrder, CardID, SupportOption) of
		{only_one_option} ->
			{can_be_option};
		{can_be_more_option} ->
			check_same_card_option (T, SupportOption)
	end.

check_one_card_many_support (_, _, _, []) -> {only_one_option};
%chgty_support (CardOwner, CardOrder, CardID, [[Major, Minor] | T]) ->
check_one_card_many_support (CardOwner, CardOrder, CardID, [{Major, Minor} | T]) -> %test
	OptionPart = play_utility:check_option_part (Major),
	{ok, Field} = mnesia_odbc:get_seal_data (CardID, OptionPart),
	FieldID = Minor,
%	case OptionPart of
		%card_name -> FieldID = play_utility:get_parse_name ([Major, Minor]);
%		card_name -> FieldID = Minor;
		%_ -> <<FieldID:16>> = <<Major, Minor>>
%		_ -> FieldID = Minor
%	end,
	case check_match (FieldID, Field) of
		{found} -> {can_be_more_option};
		{not_found} -> check_one_card_many_support (CardOwner, CardOrder, CardID, T)
	end.	

check_match (_, []) -> {not_found};
check_match (FieldID, [FieldID|_]) -> {found};
check_match (FieldID, [_|T]) -> check_match (FieldID, T).

% {1,2,[{elem, 6}]}
check_must_select_option ([], _, _) -> [];
check_must_select_option ([{Order, SupportSize, CombinationOption} | T], SupportOption, ArenaCheck) ->
	[{_, SupportSeal}] = material_search:find_all_support (ArenaCheck, CombinationOption, []),
	% �ҷ�������ҧ������
	OtherSupportOption = lists:subtract(SupportOption, CombinationOption),
	case check_same_card_option (SupportSeal, OtherSupportOption) of
		{can_be_option} ->
			[{Order, SupportSize, CombinationOption}] ++ check_must_select_option (T, SupportOption, ArenaCheck);
		{priority_check} ->
			PriorityOption = check_priority_option ({Order, SupportSize, CombinationOption}, OtherSupportOption),
			PriorityOption ++ check_must_select_option (T, SupportOption, ArenaCheck)
	end.

% ��Ǩ�ͺ�ӴѺ�����Ӥѭ㹡�������ҧ�������ö���͡��������ҧ��������� --
check_priority_option ({Order, SupportSize, [SupportCheck]}, []) -> [{Order, SupportSize, [SupportCheck]}];
check_priority_option ({Order, SupportSize, [SupportCheck]}, [CompareSupport | T]) ->
%	io:format("Support Check ~p~n", [SupportCheck]),
%	io:format("Compare Support ~p~n", [CompareSupport]),
	case SupportCheck of
		{name, _} ->	[{Order, SupportSize, [SupportCheck]}]; % E ��� ���͡��� �������Ӥѭ���ѹ�Ѻ 1
		{Major, _} ->
			case compare_support_option (Major, CompareSupport) of
				{higher_priority} -> check_priority_option ({Order, SupportSize, [SupportCheck]}, T);
				{lower_priority} -> []
			end
	end.

%compare_support_option (Major, [MajorCheck, _]) ->
%	case Major of
%		69 -> {higher_priority};
%		66 -> case MajorCheck of % B ��� ��ǹ˹�觢ͧ���͡��� �����Ӥѭ�ӴѺ 2
%				69 -> {lower_priority};
%				_ -> {higher_priority}
%			 end;
%		67 -> case MajorCheck of % C ��� ��Ҿѹ���ͧ���� �����Ӥѭ�ӴѺ 3
%				69 -> {lower_priority};
%				66 -> {lower_priority};
%				_ -> {higher_priority}
%			 end;
%		65 -> case MajorCheck of % D ��� �ҵآͧ���� �դ����Ӥѭ�ӴѺ�ش�����
%				65 -> {higher_priority};
%				_ -> {lower_priority}
%			 end
%	end.

compare_support_option (Major, {MajorCheck, _}) ->
	case Major of
		name -> {higher_priority};
		naming -> case MajorCheck of % naming ��� ��ǹ˹�觢ͧ���͡��� �����Ӥѭ�ӴѺ 2
				name -> {lower_priority}; %name ��� ���ͧ͢���� �ѧ������ �ٷ 1
				_ -> {higher_priority}
			 end;
		type -> case MajorCheck of % type ��� ��Ҿѹ���ͧ���� �����Ӥѭ�ӴѺ 3
				name -> {lower_priority};
				naming -> {lower_priority};
				_ -> {higher_priority}
			 end;
		elem -> case MajorCheck of % elem ��� �ҵآͧ���� �դ����Ӥѭ�ӴѺ�ش�����
				elem -> {higher_priority};
				_ -> {lower_priority}
			 end
	end.

%get_option_reply ([]) -> [];
%get_option_reply ([{OptionNumber, SupportSize, SupportList} | T]) ->
%	[OptionNumber, SupportSize, SupportList] ++ get_option_reply (T).
	
get_option_reply ([]) -> [];
get_option_reply ([{OptionNumber, SupportSize, SupportList} | T]) ->
	case SupportList of
		[{Group, Data}] ->
			case Group of
				elem -> 
					Kind = 1,
					Value = <<Data:16>>;
				naming -> 
					Kind = 2,
					Value = check_card_type:get_naming (Data);
				type -> 
					Kind = 3,
					Value = check_card_type:get_type (Data);
				name ->
					Kind = 4,
					Value = check_card_type:get_name (Data)
			end,
			[OptionNumber, SupportSize, Kind, Value] ++ get_option_reply (T);

		[{Group, Data}|Tail] ->
			[OptionNumber, SupportSize] ++ get_option_other ([{Group, Data}|Tail])++ get_option_reply (T)
	end.
%�Ѵ���§����ó����Ẻ��蹹͡�ҡ double
get_option_other ([]) -> [];
get_option_other ([{Group, Data}|Tail]) ->
	case Group of
		elem -> 
			Kind = 1,
			Value = <<Data:16>>;
		naming -> 
			Kind = 2,
			Value = check_card_type:get_naming (Data);
		type -> 
			Kind = 3,
			Value = check_card_type:get_type (Data);
		name ->
			Kind = 4,
			Value = check_card_type:get_name (Data)
	end,
	[Kind, Value]++get_option_other (Tail).	
		
%% 512.3. ��С�� Seal ������ Support Seal ������㹡�÷� Combination ��е�Ǩ�ͺ���͹�㹡�÷� Combination
%% ������͹����ú��� �� Seal �͡�ҡ��û�С�ȷ� Combination
%% complete_option = {option_number, sub_request_size, sub_seal_list}
select_combination_option(PlayerPid, OptionChoose, CombineOption) ->
	% PlayerPid �� Pid �ͧ��������͡ ��������ҧ
	case search_option (OptionChoose, CombineOption) of
		{OptionNumber, CombinationOption} ->
			stack_pool:set_stack_option (self(), combine_option, {OptionNumber, CombinationOption}),
			case check_combine_option(PlayerPid, OptionNumber, CombinationOption) of
				{no_support_set} ->
					rejected_combine_return(PlayerPid, no_support_seal);
				{ok, CombineSendData, CombineCheckData} ->
					%CombineSendData [1,2,0,4,<<1,61>>,1,5,<<1,61>>]
					%CombineCheckData [1,{0,{{<0.30895.0>,4,317}}},{1,{{<0.30895.0>,5,317}}}]
%					io:format ("Reply combine set ~p~n", [CombineSendData]),
					gen_server:cast(self(), {act_combine_set_option, PlayerPid, [16#88, 16#5b], CombineSendData, CombineCheckData})
			end;
		ok ->
			%stack_pool:pop_stack_out (self()),
			rejected_combine_return(PlayerPid, wrong_combine_option)
	end.

check_combine_option (_PlayerPid, OptionNumber, CombinationOption) ->
	{ok, {CardOwner, CardOrder, CardID, _}} = stack_pool:get_last_stack (self()),
	material_search:get_set_support_list (CardOwner, CardOrder, CardID, OptionNumber, CombinationOption).

search_option ([OptionNumber], []) ->
	io:format("-combination- Option ~p not found~n", [OptionNumber]);
search_option ([OptionNumber], [{OptionNumber, _, SubSealList}|_]) ->
	{OptionNumber, SubSealList};
search_option ([OptionNumber], [_|T]) ->
	search_option ([OptionNumber], T).

%% 512.4. ��ҵ�ͧ���� Cost 㹡�÷� Combination ��Ǩ�ͺ Cost ��������§������ Seal �͡�ҡ��û�С�ȷ� Combination
%% 512.5. ���� Cost ����Ѻ��÷� Combination ������ ���¡ Main Seal ���١��С����� Seal �����ѧ�����ҧ Ability ���зӧҹ
%% ����� Seal �����ҧ���� �����ҧ����稶���ա�����͡��÷ӧҹ�ͧ Ability �������͡�������������͡� Phase ���
select_combination_set (CardOwner, CombineSelect, CombineCheck) ->
	{ok, {CardOwner, CardOrder, CardID, _}} = stack_pool:get_last_stack(self()),
	{CombineOption, CombineCheckList} = split(1, CombineCheck),
	{ok, PlayPid} = stack_pool:get_last_stack(self(), card_player),
	case get_combination_seal (CombineSelect, CombineCheckList) of
		{ok, CombineSet} ->
			io:format("CombineSet ~p~n", [CombineSet]),
			card_utility:add_card_status(CardOwner, CardOrder, CardID, being_combine, arena_zone),
			card_utility:add_card_status(CardOwner, CardOrder, CardID, combine_success, arena_zone),
			stack_pool:set_stack_option (self(), combine_support, {CombineOption, CombineSet}),
			{SealListSize, ReplySupportSeal} = get_reply_support (CombineSet, 0, []),
			
			stack_pool:set_stack_option(self(), play, update_support_seal),
			
			gen_server:cast(self(), {update_support_seal, [16#88, 16#5c],PlayPid, [SealListSize] ++ ReplySupportSeal});
		_ ->	io:format ("Combine set not found~n")
	end.
	
check_being_combine_ability() ->
	stack_pool:set_stack_option(self(), play, check_being_combine_ability),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_activate:check_any_ability_activate(being_combine, PlayerPid).
	
check_combine_success_ability() ->
	stack_pool:set_stack_option(self(), play, check_combine_success_ability),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_activate:check_any_ability_activate(combine_success, PlayerPid).
	
%% 512.6. Interfere Step
into_sub_interfere() ->
	stack_pool:set_stack_option(self(), play, get_into_combination_sub_interfere),
	interfere_step:into_sub_interfere().

get_combination_seal (_, []) -> {error, combine_set_not_found};
get_combination_seal ([CombineSelect], [{CombineSelect, CombineSet}|_]) -> {ok, tuple_to_list(CombineSet)};
get_combination_seal ([CombineSelect], [_|T]) -> get_combination_seal ([CombineSelect], T).

get_reply_support ([], SealListSize, RSS) -> {SealListSize, RSS};
get_reply_support ([{_, CardOrder, CardID} | T], SealListSize, RSS) ->
	get_reply_support (T, SealListSize+1, append(RSS, [CardOrder, <<CardID:16>>])).	

% 512.7. �ҡ Ability �������ö�觼šѺ������·���˹� ���� ������·���˹�����������Ҿ������������� --
% ����Ѻ����͡������¢ͧ Ability� phase 512.5 ���訹���Ҩ��������ö��������·�� Ability ����ö�觼� ���� ��˹��� --
being_combine_ability_verify() ->
	stack_pool:set_stack_option (self(), play, being_combine_ability_verify),
	mod_ability_activate:verify_ability_condition(being_combine).

combine_success_ability_verify() ->
	stack_pool:set_stack_option (self(), play, combine_success_ability_verify),
	mod_ability_activate:verify_ability_condition(combine_success).

% 512.8. ��Ǩ�ͺ���͹䢢ͧ��÷� Combination ������ú����Ѻ任�С�� Seal ��������Support ����� Phase 512.3 ������ͧ���� Cost ����
% ��� Ability � Phase 512.5 ���������ö���͡���ա ������͹��ѧ���ú�ա����Ѻ任�С�ȡ�� Combination � Phase 512.2 ������дѺ���ŧ��������ͧ���� Cost
% ��� Ability � Phase 512.5 ���������ö���͡���ա���Ŵ�дѺ�ҡ Double Combination ��� Seal �����ѧ�����ҧ�٭������Ҿ Seal �����ѧ�����ҧ���
% �� Seal �͡�ҡ��û�С�ȷ� Combination �ѹ�� --
check_main_seal_condition (CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option (self(), play, check_combine_main),
	case card_utility:check_card_zone (CardOwner, CardOrder, CardID) of
		arena_zone ->
			check_main_active_condition (CardOwner, CardOrder, CardID);
		_ ->	return_play_from_combination (CardOwner, CardOrder, CardID)
	end.

check_main_active_condition (CardOwner, CardOrder, CardID) ->
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	case card_utility:check_card_active (CardOwner, CardOrder, CardID) of
		active_seal ->
			case check_curse_condition (CardOwner, CardOrder, CardID) of
				{ok, allow} -> interfere_step:return_play (check_play_step);
				{ok, disallow} -> activate_reject_combine(CardOwner, CardOrder, CardID, cursed_effect)
					%rejected_combine_return(PlayerPid, card_inactive)
			end;
		inactive_seal -> activate_reject_combine(CardOwner, CardOrder, CardID, card_inactive)
			%remove_all_combination_status(CardOwner, CardOrder, CardID),
			%stack_pool:pop_stack_out (self()),
			%rejected_combine_return(PlayerPid, card_inactive)
	end.

check_curse_condition (CardOwner, CardOrder, CardID) ->
	CardFx = card_utility:get_all_card_effect (CardOwner, CardOrder, CardID),
	curse:check_curse_status(CardFx, combine).

check_support_seal_condition (CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option (self(), play, check_combine_support),
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	{ok, {_, CombineSet}} = stack_pool:get_last_stack (self(), combine_support),
	case check_support_seal (CombineSet) of
% 512.8. ��Ǩ�ͺ���͹䢢ͧ��÷� Combination ������ú����Ѻ任�С�� Seal ��������Support ���� -
% � Phase 512.3 ������ͧ���� Cost ���� ��� Ability � Phase 512.5 ���������ö���͡���ա
		support_not_ready ->
			{ok, {OptionNumber, CombinationOption}} = stack_pool:get_last_stack (self(), combine_option),			
			case check_combine_option(PlayerPid, OptionNumber, CombinationOption) of
% ������͹��ѧ���ú�ա����Ѻ任�С�ȡ�� Combination � Phase 512.2 ������дѺ���ŧ��������ͧ���� Cost ��� Ability � Phase 512.5 ���������ö���͡���ա
				{no_support_set} ->
					check_downgrade_combine(CardOwner, CardOrder, CardID, CombinationOption);
				{ok, CombineSendData, CombineCheckData} ->
					gen_server:cast(self(), {act_combine_set_option, PlayerPid, [16#88, 16#5b], CombineSendData, CombineCheckData})
			end;
		support_ready ->
			interfere_step:return_play (check_play_step)
	end.

check_downgrade_combine(CardOwner, CardOrder, CardID, CombinationOption) ->
	case lists:flatlength (CombinationOption) of
		2 ->	
			case material_search:get_combination_option (CardOwner, CardOrder, CardID) of
				{have_choise, CompleteOption} ->
					DoubleCombine = check_double_combine (CompleteOption),
					check_send_double_combine(CardOwner, CardOrder, CardID, DoubleCombine);
				{no_choise, Reason} ->
					activate_reject_combine(CardOwner, CardOrder, CardID, Reason)
			end;
% ���Ŵ�дѺ�ҡ Double Combination ��� Seal �����ѧ�����ҧ�٭������Ҿ Seal �����ѧ�����ҧ��й� Seal �͡�ҡ��û�С�ȷ� Combination �ѹ�� -
		1 ->	activate_reject_combine(CardOwner, CardOrder, CardID, no_combine_option)
	end.

check_double_combine ([]) -> [];
check_double_combine ([{CombinOption, 3, SupportList} | T]) -> [{CombinOption, 3, SupportList}] ++ check_double_combine (T);
check_double_combine ([_ | T]) -> check_double_combine (T).

check_send_double_combine (CardOwner, CardOrder, CardID, DoubleCombine) ->
	case lists:flatlength(DoubleCombine) of
		0 ->	activate_reject_combine (CardOwner, CardOrder, CardID, no_combine_option);
		1 ->	CompleteOption = get_option_reply (DoubleCombine),
			% ���������͡��������ҧ
			{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
			gen_server:cast(self(), {act_combine_option, PlayerPid, [16#88, 16#5a], [1] ++ CompleteOption, DoubleCombine});
			% ��Ңͧ���͡��������ҧ
			%gen_server:cast(self(), {act_combine_option, CardOwner, [16#88, 16#5a], [1] ++ CompleteOption, DoubleCombine});
		_ -> check_order_combine (CardOwner, CardOrder, CardID, DoubleCombine)
	end.

activate_reject_combine(CardOwner, CardOrder, CardID, Reason) ->
	{ok, PlayerPid} = stack_pool:get_last_stack (self(), card_player),
	card_utility:add_card_status(CardOwner, CardOrder, CardID, combined, arena_zone),
	remove_all_combination_status(CardOwner, CardOrder, CardID),
	%stack_pool:pop_stack_out (self()),
	rejected_combine_return(PlayerPid, Reason).

check_support_seal ([]) -> support_ready;
check_support_seal ([{CardOwner, CardOrder, CardID} | T]) ->
	case check_support (CardOwner, CardOrder, CardID) of
		support_ready ->
			check_support_seal (T);
		support_not_ready ->
			support_not_ready
	end.

% -- ��Ǩ�ͺ��� ����ͧ �ѧ�������Ҿ����繫���ͧ��������� --
check_support (CardOwner, CardOrder, CardID) ->
	case card_utility:check_card_active (CardOwner, CardOrder, CardID) of
		active_seal ->
			case ability_effect:check_card_effect (CardOwner, CardOrder, CardID, any_curse) of
				{ok, no_effect} ->
					check_supporter_effect(CardOwner, CardOrder, CardID);
					%check_support_ready (CardOwner, CardOrder, CardID);
				{ok, have_effect} ->
					support_not_ready
			end;
		inactive_seal -> support_not_ready
	end.
	
check_supporter_effect(CardOwner, CardOrder, CardID) ->
	CFx = card_utility:get_all_card_effect(CardOwner, CardOrder, CardID),
	case function_utility:is_contain([{supporter, disallow}], CFx) of
		[] -> check_support_ready(CardOwner, CardOrder, CardID);
		_ -> support_not_ready
	end.
	

check_support_ready (CardOwner, CardOrder, CardID) ->
	{ok, AllStatus} = card_utility:get_card_option_field(CardOwner, CardOrder, CardID, card_status),
	ForbidStatus = [changing_line, attacker, supported,  being_combine, breaking_combine, {supported, 1}],
	CheckForbidAction = AllStatus -- ForbidStatus,
		case length(CheckForbidAction) =/= length(AllStatus) of
			true -> support_not_ready;
			_ -> 
				check_mystic_pasted (CardOwner, CardOrder, CardID)
	end.
% check_support_attacker (CardOwner, CardOrder, CardID) ->
	% case card_utility:check_card_status (CardOwner, CardOrder, CardID, attacker, arena_zone) of
		% {ok, have_status} -> support_not_ready;
		% {ok, have_no_status} ->
			% check_support_ready (CardOwner, CardOrder, CardID)
	% end.

% check_support_ready (CardOwner, CardOrder, CardID) ->
	% case card_utility:check_card_status (CardOwner, CardOrder, CardID, supported, arena_zone) of
		% {ok, have_status} -> support_not_ready;
		% {ok, have_no_status} ->
			% check_support_be_combine (CardOwner, CardOrder, CardID)
	% end.
% 
% check_support_be_combine (CardOwner, CardOrder, CardID) ->
	% case card_utility:check_card_status (CardOwner, CardOrder, CardID, be_combine, arena_zone) of
		% {ok, have_status} -> support_not_ready;
		% {ok, have_no_status} ->
			% check_mystic_pasted (CardOwner, CardOrder, CardID)
	% end.

check_mystic_pasted (CardOwner, CardOrder, CardID) ->
	case card_utility:get_card_option_field (CardOwner, CardOrder, CardID, mystic, arena_zone) of
		{ok, []} -> support_ready;
		{ok, _} -> support_not_ready
	end.

% 512.9. ��� Combination ��������ó� �� Support Seal �������� Main Seal ��� Seal ��� Combination���稨�����Ҿ�� Seal ��������ҧ��
check_complete_combination(CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option (self(), play, play_check_complete_combination),
	{ok, {CombineOption, CombineSet}} = stack_pool:get_last_stack (self(), combine_support),
%	stack_pool:set_stack_option (self(), send_update_effect, no),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	case arena_zone:set_support_seal(CardOwner, CardOrder, CardID, CombineOption, CombineSet) of
		{completed} ->
			% ��� Combination ��������ó�
			card_utility:add_card_status(CardOwner, CardOrder, CardID, be_combine, arena_zone),
			card_utility:add_card_status(CardOwner, CardOrder, CardID, combined, arena_zone),
			{SealListSize, ReplySupportSeal} = get_reply_support (CombineSet, 0, []),
			%gen_server:cast(self(), {update_card_combination, [16#88, 16#5d], CardOwner, [CombineOption, CardOrder, <<CardID:16>>, SealListSize] ++ ReplySupportSeal});
			gen_server:cast(self(), {update_card_combination, [16#88, 16#5d], PlayerPid, [CombineOption, CardOrder, <<CardID:16>>, SealListSize] ++ ReplySupportSeal});
		{incomplete, Reason} ->
			[Option] = CombineOption,
			CombinationOption = mnesia_odbc:get_combination_support (CardID, Option),
			case material_search:get_set_support_list (CardOwner, Option, CombinationOption) of
				{ok, CombineCheckData, CombineCheckData} ->
					gen_server:cast(self(), {act_combine_set_option, PlayerPid, [16#88, 16#5b], CombineCheckData, CombineCheckData});
				{no_support_set} ->
					io:format("Check lower combine option reason is ~p~n", [Reason])
			end
	end.

% 512.10. ��Ǩ�ͺ��� Ability ��鹶١��ͧ������͹�㹡�÷ӧҹ������� ������͹����ú Ability ��鹨����ӧҹ ���� �ҡ�����������·�� Ability ����ö�觼�
% ���� ��˹��� Ability ��鹨����ӧҹ ������͹�㹡���Դ Ability �ѧ���١��ͧ�����������·��١��ͧ Ability ����� Seal �����ҧ ���� �����Seal �����ҧ����稨зӧҹ � Phase ��� --
activate_being_combine_effect() ->
	stack_pool:set_stack_option (self(), play, activate_being_combine_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(being_combine, PlayerPid).

activate_combine_success_effect() ->
	stack_pool:set_stack_option (self(), play, activate_combine_success_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(combine_success, PlayerPid).

update_ability_check(CardOwner, CardOrder, CardID) ->
%% 512.11. ����鹵͹��÷� Combination Seal �����ѧ�����ҧ�٭������Ҿ Seal �����ѧ�����ҧ��� �� Seal����С�� Combination �͡�ҡ��û�С�� Combination
	stack_pool:set_stack_option (self(), play, play_update_ability_check),
%	case stack_pool:get_last_stack (self(), target_effect_update_data) of
%		{ok, RemoveFxList} ->
%			send_remove_effect (RemoveFxList);
%		Any -> io:format ("Target effect update data return ~p~n", [Any])
%	end,
	card_utility:remove_card_status (CardOwner, CardOrder, CardID, being_combine, arena_zone),
	card_utility:remove_card_status (CardOwner, CardOrder, CardID, combination, arena_zone),
	card_utility:remove_card_status (CardOwner, CardOrder, CardID, combine_success, arena_zone),
	% case ability_effect:check_all_ability_affect() of
		% 0 -> interfere_step:return_play (check_play_step);
		% _ -> card_utility:check_card_affect()
	% end.
	continuous_ability:check_continuous_target().

return_play_from_combination (CardOwner, CardOrder, CardID) ->
	stack_pool:set_stack_option (self(), play, check_combine_main),
	case card_utility:check_card_zone (CardOwner, CardOrder, CardID) of
		arena_zone -> effect_activate:send_update_activate_effect (CardOwner, CardOrder, CardID, [], update);
		_ ->	card_not_on_arena
	end,
	stack_pool:pop_stack_out (self()),
	case stack_pool:get_last_stack (self(), play) of
		{ok, StackPlay} ->
			interfere_step:return_play(StackPlay);
		{error, _} ->
			gen_server:cast(self(), {act_next_command})
	end.

% send_remove_effect ([]) -> ok;
% send_remove_effect ([{CardOwner, CardOrder, CardID, Effect} | RemoveFxList]) ->
% %	io:format ("Effect remove from ~p~n", [{CardOwner, CardOrder, CardID}]),
	% case card_utility:check_card_zone (CardOwner, CardOrder, CardID) of
		% arena_zone ->
			% effect_activate:send_update_activate_effect (CardOwner, CardOrder, CardID, Effect, remove);
		% _ -> dont_remove_other_zone
	% end,
	% send_remove_effect (RemoveFxList).

remove_all_combination_status(CardOwner, CardOrder, CardID) ->
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, be_combine, arena_zone), %��� Combination ��������ó�
	%card_utility:remove_card_status (CardOwner, CardOrder, CardID, combined, arena_zone),
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, combination, arena_zone), % ��С�� Seal ���з� Combination 
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, combine_success, arena_zone), %���� Cost ����Ѻ��÷� Combination
	card_utility:remove_card_status(CardOwner, CardOrder, CardID, being_combine, arena_zone). %���� Cost ����Ѻ��÷� Combination
	
next_command_to_client() ->
	stack_pool:pop_stack_out (self()),
	case stack_pool:get_last_stack (self(), play) of
		{ok, StackPlay} -> interfere_step:return_play(StackPlay);
		{error, _} -> gen_server:cast(self(), {act_next_command})
	end.