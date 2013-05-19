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
-module (target_attack).

-compile (export_all).

check_assign_attack_target(PlayerPid, CardOwner, CardOrder, CardID) ->
	OpponentPid = mnesia_play:get_opponent_pid (CardOwner),
	{ControllerPid, UncontrolPid, opponent} = attribute_check:check_controller({CardOwner, CardOrder, CardID}, OpponentPid, uncontrol),
	CardFx = card_utility:get_all_card_effect(CardOwner, CardOrder, CardID),
	% Seal �ء㺢ͧ��觵ç�������������� (��觹��ж١����)
	% Check ��Ҽ��������� ���Ѻ�� �ͧ�������������� � �Ź��� �������
	
	PossibleTarget = card_utility:get_all_card(UncontrolPid, seal_card, arena_zone),
	% Seal �ء㺢ͧ��觵ç�������������� ��������Ǻ����¼���������
	PossibleUncon = attacker_uncontrol(ControllerPid, UncontrolPid, PossibleTarget),
	% Seal �ء㺢ͧ��觼������
	OurSeal =card_utility:get_all_card(ControllerPid, seal_card, arena_zone),
	% Seal �ء㺢ͧ�����ҷ��ж١����
	OurOppControl = attacker_uncontrol(ControllerPid, UncontrolPid, OurSeal),	
	
	% Seal �ء㺷������ö������麹 At line �ͧ��觷�� ���������������Ǻ���
	AtLineTarget =
	case continuous_ability:check_player_got_effect(PlayerPid, player_effect, [{player_assign_atk, {disallow, to_at}}]) of
		have_effect -> AtLinePossible = [], [];
		have_no_effect ->
			case check_line_to_attack(CardFx) of
				at_line -> 
					AtLinePossible = get_card_on_line(PossibleTarget, 1),
					get_card_on_line(PossibleUncon, 1);
				to_ordinary_line -> 
					AtLinePossible = get_card_on_line(PossibleTarget, 1),
					get_card_on_line(PossibleUncon, 1);
				df_line -> 
					AtLinePossible = [],
					[]
			end
	end,
	
	% Seal �ء㺷������ö����Һ� Df line �ͧ��觷�� ���������������Ǻ���
	DfLineTarget = 
	case continuous_ability:check_player_got_effect(PlayerPid, player_effect, [{player_assign_atk, {disallow, to_df}}]) of
		have_effect -> [];
		have_no_effect -> get_card_on_line(PossibleUncon, 0)
	end,
	
	% Seal �ء㺢ͧ��觵ç�������������� (��觹��ж١����) ������Դ Dimension Curse
	OppGotDimension = get_card_on_line(PossibleTarget, null),
	% Seal �ء㺢ͧ�����ҷ�����躹 At Line
	OurOppConATLine = get_card_on_line(OurOppControl, 1),
	% Seal �ء㺢ͧ�����ҷ�����躹 Df Line
	_OurOppConDFLine = get_card_on_line(OurOppControl, 0),
	
	ToSupportFx = function_utility:is_contain([{attack, to_supporter}], CardFx),
	
	AttackTarget =
	case AtLineTarget of
		% ��ҷ�������������� �ó� ����� Seal ��� At Line ��觵ç���� ��� ����� Seal ���١��觵ç�����Ǻ����� At Line �������
		[] -> 
			case AtLinePossible of
				[] -> get_support_target(DfLineTarget, ToSupportFx) ++ get_support_target(OurOppConATLine, ToSupportFx);
				_ -> 
					CheckFxTarget = check_card_attack_effect(CardOwner, CardOrder, CardID, DfLineTarget, CardFx),
					
					get_support_target(OurOppConATLine, ToSupportFx) ++ get_support_target(CheckFxTarget, ToSupportFx)
			end;
		% ��ҷ�������������� �ó� �� Seal ��� At Line ��觵ç����
		_ ->	
			CheckFxTarget = 
			case continuous_ability:check_player_got_effect(PlayerPid, player_effect, [{player_assign_atk, {disallow, across_to_df}}]) of
				have_effect -> [];
				have_no_effect -> check_card_attack_effect(CardOwner, CardOrder, CardID, DfLineTarget, CardFx)
			end,
			
			get_support_target(AtLineTarget, ToSupportFx) ++
			get_support_target(OurOppConATLine, ToSupportFx) ++
			get_support_target(CheckFxTarget, ToSupportFx)
	end,
	io:format("attack target 1~p~n", [AttackTarget]),
	AtkTarget = AttackTarget -- [{CardOwner, CardOrder, CardID}],
	case AtkTarget of
		% �óշ���������Һ�ʹ��
		[] ->
			case PossibleTarget of
				% �óշ���������Һ�ʹ�� �������� Seal ������ʹ������
				[] -> 	check_attack_on_hand(UncontrolPid, ControllerPid);
				% �óշ���������Һ�ʹ�� ���� Seal ������ʹ��
				_ -> 
					case OppGotDimension of
						% �������� �� �� Seal ��ʹ�� ��� � Seal ����ҹ�� ������� Seal ����˹���Դ Dimension Curse �ʴ���� Seal ����ҹ�鹵Դ Charm Curse
						[] -> {no_target, can_not_attack_to_hand};								
						%��ʹ����觵ç������ Seal ���� �� �Դ Dimension Curse ��� At Line ���� Df Line
						_ -> 
							case length(OppGotDimension) < length(PossibleTarget) of
								% ���¤������ Seal ��ʹ�����ҡ���� Seal ���Դ Dimension �ʴ���� 㹨ӹǹ��� ��ͧ�� Seal ���Դ Charm �ͧ �����������
								true -> {no_target, can_not_attack_to_hand};
								_ -> check_attack_on_hand(UncontrolPid, ControllerPid)
							end
					end
			end;
		% �óշ������Һ�ʹ��
		_Target ->
			% smo_logger:fmsg("all Target Remain to Attack are ~p~n", [_Target]),
			% smo_logger:fmsg("all OurOppConATLine are ~p~n", [OurOppConATLine]),
			% smo_logger:fmsg("all _OurOppConDFLine are ~p~n", [_OurOppConDFLine]),
			case _Target of
				%����� ����繡��촢ͧ��ҷ����µç������Ǻ��� �� AT line �������
				% ����礵����� Card ���������� �� Seal �������Ңͧ���ǡѹ�Ѻ 
				OurOppConATLine -> 
					case check_all_owner(CardOwner, OurOppConATLine)  of
						check_target_zone -> {check_target_zone, OurOppConATLine};
						attack_to_target -> 
							case check_other_be_target_disallow({CardOwner, CardOrder, CardID}, OurOppConATLine, assign_atk) of
								[] -> {no_target, can_not_attack_to_hand};
								_RemainTarget -> {have_target, _RemainTarget}%{have_target, OurOppConATLine}
							end
					end;
				%���촢ͧ��ҷ����µç������Ǻ��� �� DF line �������
				_OurOppConDFLine -> 
					case check_all_owner(CardOwner, _OurOppConDFLine)  of
						check_target_zone -> {check_target_zone, _OurOppConDFLine};
						attack_to_target -> 
							case check_other_be_target_disallow({CardOwner, CardOrder, CardID}, _OurOppConDFLine, assign_atk) of
								[] -> {no_target, can_not_attack_to_hand};
								_RemainTarget -> {have_target, _RemainTarget}%{have_target, _OurOppConDFLine}
							end
					end;
				_ ->
					case check_other_be_target_disallow({CardOwner, CardOrder, CardID}, _Target, assign_atk) of
						[] -> {no_target, can_not_attack_to_hand};
						_RemainTarget -> %smo_logger:fmsg("remain target to attack ~p~n", [_RemainTarget]), 
							{have_target, _RemainTarget}
					end
			end
	end.
	
check_attack_target(_PlayerPid, CardOwner, CardOrder, CardID) ->
	OpponentPid = mnesia_play:get_opponent_pid (CardOwner),
	{ControllerPid, UncontrolPid, opponent} = attribute_check:check_controller({CardOwner, CardOrder, CardID}, OpponentPid, uncontrol),
	CardFx = card_utility:get_all_card_effect(CardOwner, CardOrder, CardID),
	% Seal �ء㺢ͧ��觵ç�������������� (��觹��ж١����)
	PossibleTarget = card_utility:get_all_card(UncontrolPid, seal_card, arena_zone),
	% Seal �ء㺢ͧ��觵ç�������������� ��������Ǻ����¼���������
	PossibleUncon = attacker_uncontrol(ControllerPid, UncontrolPid, PossibleTarget),
	% Seal �ء㺢ͧ��觼������
	OurSeal =card_utility:get_all_card(ControllerPid, seal_card, arena_zone),
	% Seal �ء㺢ͧ�����ҷ��ж١����
	OurOppControl = attacker_uncontrol(ControllerPid, UncontrolPid, OurSeal),	
	
	% Seal �ء㺷������ö������麹 At line �ͧ��觷�� ���������������Ǻ���
	AtLineTarget = 
	case check_line_to_attack(CardFx) of
		at_line -> 
			AtLinePossible = get_card_on_line(PossibleTarget, 1),
			get_card_on_line(PossibleUncon, 1);
		to_ordinary_line -> 
			AtLinePossible = get_card_on_line(PossibleTarget, 1),
			get_card_on_line(PossibleUncon, 1);
		df_line -> 
			AtLinePossible = [],
			[]
	end,
	% Seal �ء㺷������ö����Һ� Df line �ͧ��觷�� ���������������Ǻ���
	DfLineTarget = get_card_on_line(PossibleUncon, 0),
	
	% Seal �ء㺢ͧ��觵ç�������������� (��觹��ж١����) ������Դ Dimension Curse
	OppGotDimension = get_card_on_line(PossibleTarget, null),
	% Seal �ء㺢ͧ�����ҷ�����躹 At Line
	OurOppConATLine = get_card_on_line(OurOppControl, 1),
	% Seal �ء㺢ͧ�����ҷ�����躹 Df Line
	_OurOppConDFLine = get_card_on_line(OurOppControl, 0),
	
	ToSupportFx = function_utility:is_contain([{attack, to_supporter}], CardFx),
	
	AttackTarget =
	case AtLineTarget of
		% ��ҷ�������������� �ó� ����� Seal ��� At Line ��觵ç���� ��� ����� Seal ���١��觵ç�����Ǻ����� At Line �������
		[] -> 
			case AtLinePossible of
				[] -> get_support_target(DfLineTarget, ToSupportFx) ++ get_support_target(OurOppConATLine, ToSupportFx);
				_ -> 
					CheckFxTarget = check_card_attack_effect(CardOwner, CardOrder, CardID, DfLineTarget, CardFx),
					
					get_support_target(OurOppConATLine, ToSupportFx) ++ get_support_target(CheckFxTarget, ToSupportFx)
			end;
		% ��ҷ�������������� �ó� �� Seal ��� At Line ��觵ç����
		_ ->	
			CheckFxTarget = check_card_attack_effect(CardOwner, CardOrder, CardID, DfLineTarget, CardFx),
			
			get_support_target(AtLineTarget, ToSupportFx) ++
			get_support_target(OurOppConATLine, ToSupportFx) ++
			get_support_target(CheckFxTarget, ToSupportFx)
	end,
	io:format("attack target 1~p~n", [AttackTarget]),
	AtkTarget = AttackTarget -- [{CardOwner, CardOrder, CardID}],
	case AtkTarget of
		% �óշ���������Һ�ʹ��
		[] ->
			case PossibleTarget of
				% �óշ���������Һ�ʹ�� �������� Seal ������ʹ������
				[] -> 	check_attack_on_hand(UncontrolPid, ControllerPid);
				% �óշ���������Һ�ʹ�� ���� Seal ������ʹ��
				_ -> 
					case OppGotDimension of
						% �������� �� �� Seal ��ʹ�� ��� � Seal ����ҹ�� ������� Seal ����˹���Դ Dimension Curse �ʴ���� Seal ����ҹ�鹵Դ Charm Curse
						[] -> {no_target, can_not_attack_to_hand};								
						%��ʹ����觵ç������ Seal ���� �� �Դ Dimension Curse ��� At Line ���� Df Line
						_ -> 
							case length(OppGotDimension) < length(PossibleTarget) of
								% ���¤������ Seal ��ʹ�����ҡ���� Seal ���Դ Dimension �ʴ���� 㹨ӹǹ��� ��ͧ�� Seal ���Դ Charm �ͧ �����������
								true -> {no_target, can_not_attack_to_hand};
								_ -> check_attack_on_hand(UncontrolPid, ControllerPid)
							end
					end
			end;
		% �óշ������Һ�ʹ��
		_Target ->
			% smo_logger:fmsg("all Target Remain to Attack are ~p~n", [_Target]),
			% smo_logger:fmsg("all OurOppConATLine are ~p~n", [OurOppConATLine]),
			% smo_logger:fmsg("all _OurOppConDFLine are ~p~n", [_OurOppConDFLine]),
			case _Target of
				%����� ����繡��촢ͧ��ҷ����µç������Ǻ��� �� AT line �������
				% ����礵����� Card ���������� �� Seal �������Ңͧ���ǡѹ�Ѻ 
				OurOppConATLine -> 
					case check_all_owner(CardOwner, OurOppConATLine)  of
						check_target_zone -> {check_target_zone, OurOppConATLine};
						attack_to_target -> 
							case check_other_be_target_disallow({CardOwner, CardOrder, CardID}, OurOppConATLine, attack) of
								[] -> {no_target, can_not_attack_to_hand};
								_RemainTarget -> {have_target, _RemainTarget}%{have_target, OurOppConATLine}
							end
					end;
				%���촢ͧ��ҷ����µç������Ǻ��� �� DF line �������
				_OurOppConDFLine -> 
					case check_all_owner(CardOwner, _OurOppConDFLine)  of
						check_target_zone -> {check_target_zone, _OurOppConDFLine};
						attack_to_target -> 
							case check_other_be_target_disallow({CardOwner, CardOrder, CardID}, _OurOppConDFLine, attack) of
								[] -> {no_target, can_not_attack_to_hand};
								_RemainTarget -> {have_target, _RemainTarget}%{have_target, _OurOppConDFLine}
							end
					end;
				_ ->
					case check_other_be_target_disallow({CardOwner, CardOrder, CardID}, _Target, attack) of
						[] -> {no_target, can_not_attack_to_hand};
						_RemainTarget -> %smo_logger:fmsg("remain target to attack ~p~n", [_RemainTarget]), 
							{have_target, _RemainTarget}
					end
			end
	end.

get_support_target([], _) -> [];
get_support_target([{MainOwner, MainOrder, MainID}|Support], ToSupportFx) ->
	case ToSupportFx of
		[] -> [{MainOwner, MainOrder, MainID}|Support];
		_ -> %[{MainOwner, MainOrder, MainID}] ++ function_utility:card_match_condition(arena_zone:get_support_seals(MainOwner, MainOrder, MainID), [{card_type, seal}]) ++ get_support_target(Support, ToSupportFx)
			[{MainOwner, MainOrder, MainID}] ++ arena_zone:get_support_seals(MainOwner, MainOrder, MainID) ++ get_support_target(Support, ToSupportFx)
	end.

check_all_owner(_CardOwner, []) -> check_target_zone;
check_all_owner(CardOwner, [{CardOwner, _CardOrder, _CardID}|Tail]) -> check_all_owner(CardOwner, Tail);
check_all_owner(_CardOwner, [{_OtherCardOwner, _CardOrder, _CardID}|_Tail]) -> attack_to_target.
	
	
check_attack_on_hand(UncontrolPid, _ControllerPid) ->
	case mnesia_play:get_player_data(UncontrolPid, hand_cards) of
		{ok, []} -> {no_target, can_not_attack_to_hand};
		_ -> {no_target, attack_to_hand}
	end.

get_cards_controller_arena (PlayerPid, Controller, WhoArena) ->
	OpponentPid = mnesia_play:get_opponent_pid (PlayerPid),
	Cards = 
	case WhoArena of
		player ->
			card_utility:get_all_card (PlayerPid, seal_card, arena_zone);
		opponent ->
			card_utility:get_all_card (OpponentPid, seal_card, arena_zone);
		all ->
			card_utility:get_all_card (seal_card, arena_zone)
	end,
	check_cards_controller (PlayerPid, Controller, Cards).
%------------------------------------------------------------------------------------------------------------------------------
%��������� Attack All ����Ңͧ�������ҧ���� ����ͧ�ٷ����Ǻ���
%-------------------------------------------------------------------------------------------------------------------------------
get_cards_target_arena_all(PlayerPid, CardOwner, CardOrder, CardID, AttackCase) ->
	OpponentPid = mnesia_play:get_opponent_pid(PlayerPid),
	Cards = card_utility:get_all_card(OpponentPid, seal_card, arena_zone),
	get_card_target_all(Cards, CardOwner, CardOrder, CardID, AttackCase).

get_card_target_all(C, CardOwner, CardOrder, CardID, AttackCase) ->
	get_card_target_all(C, [], CardOwner, CardOrder, CardID, AttackCase).
	
get_card_target_all([{{TCardOwner, TCardOrder, TCardID}, _} | Tail], CardList, CardOwner, CardOrder, CardID, AttackCase) ->
	TCardFx = card_utility:get_all_card_effect(TCardOwner, TCardOrder, TCardID),
	%smo_logger:fmsg("target effect are ~p~n", [TCardFx]),
	%Interest = [{attack_to_s, {disallow, sp_less_than_s}}, {attack_to_s, {disallow, seal_not_combine}}, {attack_to_s, {disallow, all}}, {protect_attack, [all]}],
	%FxRemain = function_utility:is_contain(Interest, TCardFx),
	%smo_logger:fmsg("remain effect to check are ~p~n", [FxRemain]),
	case check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, TCardFx, AttackCase) of
		true -> get_card_target_all(Tail, [{TCardOwner, TCardOrder, TCardID}] ++ CardList, CardOwner, CardOrder, CardID, AttackCase);
		_ -> get_card_target_all(Tail, CardList, CardOwner, CardOrder, CardID, AttackCase)
	end;
get_card_target_all([], CardList, _, _, _, _) -> CardList.
%-------------------------------------------------------------------------------------------------------------------------------
attacker_uncontrol(_, _, []) -> []; 
attacker_uncontrol(AtkPid, UnattackerPid, [{{CardOwner, CardOrder, CardID}, _} | Cards]) ->
	CardOpp = 
	case CardOwner of
		AtkPid -> UnattackerPid;
		_ -> AtkPid
	end,
	{ControllerPid, _, _} = attribute_check:check_controller({CardOwner, CardOrder, CardID}, CardOpp, controller),
	case ControllerPid of
		UnattackerPid -> [{CardOwner, CardOrder, CardID}] ++attacker_uncontrol(AtkPid, UnattackerPid, Cards);
		_ -> attacker_uncontrol(AtkPid, UnattackerPid, Cards)
	end.	
	
those_seal_we_control(_, _, []) -> []; 
those_seal_we_control(AttackerPid, UnAtkPid, [{{CardOwner, CardOrder, CardID}, _} | Cards]) ->
	{ControllerPid, _, _} = attribute_check:check_controller({CardOwner, CardOrder, CardID}, UnAtkPid, controller),
	case ControllerPid of
		AttackerPid -> those_seal_we_control(AttackerPid, UnAtkPid, Cards);
		_ -> [{CardOwner, CardOrder, CardID}] ++those_seal_we_control(AttackerPid, UnAtkPid, Cards)
	end.

% ��Ǩ�ͺ��� ���Ǻ����ͧ����㺹���繤����ǡѺ����ͧ���������� -
check_cards_controller(_, _, []) -> [];
check_cards_controller(PlayerPid, Controller, [{{CardOwner, CardOrder, CardID}, _} | Cards]) ->
	%PossibleTarget = check_cards_controller (PlayerPid, Controller, Cards),
	OppPid = mnesia_play:get_opponent_pid(CardOwner),
	{ControllerPid, _UncontPid, _} = attribute_check:check_controller({CardOwner, CardOrder, CardID}, OppPid, controller),
	% ��Ǩ�ͺ���Ǻ�������㺹��� ��Ҽ��Ǻ����繤����ǡѺ��Ңͧ����������� -
	case ControllerPid of
		PlayerPid -> player;
		_ -> opponent
	end,
	% case card_utility:check_card_controller(CardOwner, CardOrder, CardID) of
		% controller_allow -> % ���Ǻ�������Ңͧ����
			% case PlayerPid of
				% CardOwner -> % �����蹡Ѻ���Ǻ����繤����ǡѹ
					% CardController = player;
				% _ ->	CardController = opponent
			% end;
		% controller_not_allow -> % ���Ǻ������������Ңͧ����
			% case PlayerPid of
				% CardOwner -> % �����蹡Ѻ���Ǻ����繤��Ф�
					% CardController = opponent;
				% _ ->	CardController = player
			% end
	% end,
	case ControllerPid of
		Controller -> [{CardOwner, CardOrder, CardID}] ++ check_cards_controller(PlayerPid, Controller, Cards);
		_ ->	check_cards_controller(PlayerPid, Controller, Cards)
	end.
	
% �ҡ��촷��������Ź����˹�
get_card_on_line ([], _) -> [];
get_card_on_line([{CardOwner, CardOrder, CardID}| Cards], null) ->
	CardFx = card_utility:get_all_card_effect(CardOwner, CardOrder, CardID),
	Dimension = function_utility:is_contain([{curse, dimension_curse}], CardFx),
	case Dimension of
		[] -> get_card_on_line(Cards, null);
		_Dimension -> 
			[{CardOwner, CardOrder, CardID}] ++ get_card_on_line(Cards, null)
	end;
	
get_card_on_line([{CardOwner, CardOrder, CardID}| Cards], LineCheck) ->
	CardLine = card_utility:get_card_option_field(CardOwner, CardOrder, CardID, line, arena_zone),
	case CardLine of
		{ok, LineCheck} ->
			CardFx = card_utility:get_all_card_effect(CardOwner, CardOrder, CardID),
			Disallow = function_utility:is_contain([{curse, dimension_curse}], CardFx),
			case Disallow of
				[] ->
					[{CardOwner, CardOrder, CardID}] ++ get_card_on_line(Cards, LineCheck);
				_Dimension ->
					get_card_on_line(Cards, LineCheck)
			end;
		_ ->	get_card_on_line(Cards, LineCheck)
	end;
	
get_card_on_line([{{CardOwner, CardOrder, CardID}, _} | Cards], null) ->
	CardFx = card_utility:get_all_card_effect(CardOwner, CardOrder, CardID),
	Dimension = function_utility:is_contain([{curse, dimension_curse}], CardFx),
	case Dimension of
		[] -> get_card_on_line(Cards, null);
		_Dimension ->	
			[{CardOwner, CardOrder, CardID}] ++ get_card_on_line(Cards, null)
	end;	
	
get_card_on_line ([{{CardOwner, CardOrder, CardID}, _} | Cards], LineCheck) ->
	CardLine = card_utility:get_card_option_field(CardOwner, CardOrder, CardID, line, arena_zone),
	case CardLine of
		{ok, LineCheck} ->
			CardFx = card_utility:get_all_card_effect(CardOwner, CardOrder, CardID),
			Disallow = function_utility:is_contain([{curse, dimension_curse}], CardFx),
			case Disallow of
				[] ->
					[{CardOwner, CardOrder, CardID}] ++ get_card_on_line(Cards, LineCheck);
				_Dimension ->
					get_card_on_line (Cards, LineCheck)					
			end;
		_ ->	get_card_on_line (Cards, LineCheck)
	end.

check_card_attack_effect (_, _, _, _, []) -> [];
check_card_attack_effect (CardOwner, CardOrder, CardID, DefendLineTarget, [{_, Fx, _} | CardFx]) ->
	MoreTarget = get_attack_target_by_effect (CardOwner, CardOrder, CardID, DefendLineTarget, Fx),
	MoreTarget ++ check_card_attack_effect (CardOwner, CardOrder, CardID, DefendLineTarget -- MoreTarget, CardFx).

get_attack_target_by_effect (_CardOwner, _CardOrder, _CardID, _DefendLineTarget, []) -> [];
get_attack_target_by_effect (CardOwner, CardOrder, CardID, DefendLineTarget, [FxCheck | Fx]) ->
	case FxCheck of
		{attack, to_df} ->
			DefendLineTarget;
		{attack, {to_df, CompareType, Power}} ->
		%{attack, to_df_more_sp} ->
			%{ok, MainSpeed} = arena_zone:get_card_power (CardOwner, CardOrder, CardID, speed),
			{ok, MainPower} = arena_zone:get_card_power(CardOwner, CardOrder, CardID, Power),
			%TargetMoreSp = get_match_condition_target (DefendLineTarget, more, MainSpeed),
			TargetMatch = get_match_condition_target(DefendLineTarget, CompareType, MainPower, Power),
			%AddOnTarget = get_attack_target_by_effect(CardOwner, CardOrder, CardID, DefendLineTarget -- TargetMoreSp, Fx),
			AddOnTarget = get_attack_target_by_effect(CardOwner, CardOrder, CardID, DefendLineTarget -- TargetMatch, Fx),
			TargetMatch ++ AddOnTarget;
		% {attack, to_df_less_sp} ->
			% {ok, MainSpeed} = arena_zone:get_card_power (CardOwner, CardOrder, CardID, speed),
			% TargetLessSp = get_match_condition_target (DefendLineTarget, less, MainSpeed),
			% AddOnTarget = get_attack_target_by_effect (CardOwner, CardOrder, CardID, DefendLineTarget -- TargetLessSp, Fx),
			% TargetLessSp ++ AddOnTarget;
		% {attack, to_df_less_df} ->
			% {ok, MainDefend} = arena_zone:get_card_power (CardOwner, CardOrder, CardID, defend),
			% TargetLessDf = get_match_condition_target(DefendLineTarget, less, MainDefend),
			% AddOnTarget = get_attack_target_by_effect (CardOwner, CardOrder, CardID, DefendLineTarget -- TargetLessSp, Fx),
			% TargetLessSp ++ AddOnTarget;
		_ ->	[]
	end.
	
check_line_to_attack([]) -> to_ordinary_line;
check_line_to_attack([{_, Fx, _} | CardFx]) ->
	case check_line(Fx) of
		no_assing_line_target -> check_line_to_attack(CardFx);
		to_df -> df_line;
		to_at -> at_line
	end.

check_line([]) -> no_assing_line_target;
check_line([FxCheck|Fx]) ->
	case FxCheck of
		{attack, only_to_df} ->  to_df;
		{attack, only_to_at} ->  to_at;
		_ -> check_line(Fx)
	end.
	
	

get_match_condition_target ([], _, _, _) -> [];
get_match_condition_target ([{CardOwner, CardOrder, CardID} | Target], CompareType, MainPower, Power) ->
	{ok, TargetPower} = arena_zone:get_card_power (CardOwner, CardOrder, CardID, Power),
	case CompareType of
		more ->
			if
				TargetPower > MainPower ->
					[{CardOwner, CardOrder, CardID}] ++ get_match_condition_target(Target, CompareType, MainPower, Power);
				true ->
					get_match_condition_target(Target, CompareType, MainPower, Power)
			end;
		less ->
			if
				TargetPower < MainPower ->
					[{CardOwner, CardOrder, CardID}] ++ get_match_condition_target(Target, CompareType, MainPower, Power);
				true ->
					get_match_condition_target(Target, CompareType, MainPower, Power)
			end
	end.
%---------------- Check ��ҡ�����բͧ��� ���� All
check_target_attack_all(PlayerPid, CardOwner, CardOrder, CardID, AttackCase) ->
	%PossibleTarget = get_cards_controller_arena (PlayerPid, opponent, all),
	% AttackCase ���� Case �ͧ��� ������� �Ѻ ������� (��͡�����¡ Check �ա������ѧ��ҹ Interfere ������������)
	PossibleTarget = get_cards_target_arena_all(PlayerPid, CardOwner, CardOrder, CardID, AttackCase),
	ExcludeTarget = get_card_on_line(PossibleTarget, null),
	PosTarget = PossibleTarget -- ExcludeTarget, 
	check_attack_all_target(PosTarget, CardOwner, CardOrder, CardID).

check_attack_all_target([], _, _, _) -> [];
check_attack_all_target([{TPid, TOrder, TID} | Cards], CardOwner, CardOrder, CardID) ->
	case ability_effect:check_card_effect(TPid, TOrder, TID, protect_attack_all) of
		{ok, have_effect} ->
			check_attack_all_target(Cards, CardOwner, CardOrder, CardID);
		{ok, no_effect} ->
			[{TPid, TOrder, TID}] ++ check_attack_all_target(Cards, CardOwner, CardOrder, CardID)
	end.
% check ��� Seal ��˹����������ö����Ңͧ��������� ���� AttackCase �繵���к���� �����Ңͧ���������� ���͡������ ����ҹ Interfere �����
check_other_be_target_disallow({_CardOwner, _CardOrder, _CardID}, [], _) -> [];
check_other_be_target_disallow({CardOwner, CardOrder, CardID}, [{TCardOwner, TCardOrder, TCardID}|Target], AttackCase) ->
	CardZone  = card_utility:check_card_zone(CardOwner, CardOrder, CardID),
	TCardFx = 
	case CardZone of
		support_cards -> [];
		arena_zone -> card_utility:get_all_card_effect(TCardOwner, TCardOrder, TCardID)
	end,
	case check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, TCardFx, AttackCase) of
		true -> [{TCardOwner, TCardOrder, TCardID}]++check_other_be_target_disallow({CardOwner, CardOrder, CardID}, Target, AttackCase);
		_ -> check_other_be_target_disallow({CardOwner, CardOrder, CardID}, Target, AttackCase)
	end.
	
check_remain_disallow(_, _, [], _) -> true;
check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, [{_, CardFx, _} | RemainFx], AttackCase) ->
	case CardFx of
		% �ó� attack_to_s �������������駡������������� ������� ����ͧ check AttackCase 
		[{attack_to_s, {disallow, Condition}}] -> 
			case Condition of
				% ��� Seal ��������� Speed �ҡ���� Target ��� Target �������
				sp_less_than_s ->
					AttackerSp = game_info:card_sp({arena_zone, {CardOwner, CardOrder, CardID}}),
					case attribute_check:sp_check({arena_zone, {TCardOwner, TCardOrder, TCardID}}, AttackerSp, less_than_s) of
						% �ó� Target Speed �ҡ���� �� Return true ��� S ����������
						true -> cannot_be_target;
						_Res -> check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, RemainFx, AttackCase)
					end;
				seal_not_combine ->
					case attribute_check:combine_check({arena_zone, {CardOwner, CardOrder, CardID}}, y) of
						% �ó� Seal ������������ҧ���� S �������
						true -> check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, RemainFx, AttackCase);
						_Res -> _Res
					end;
				all -> cannot_be_target;
				{RequireType, Value} ->
					case RequireType of
						naming ->	{ok, InterestData} = mnesia_odbc:get_seal_data(CardID, card_naming);
						type ->		{ok, InterestData} = mnesia_odbc:get_seal_data(CardID, card_type);
						elem ->		{ok, InterestData} = mnesia_odbc:get_seal_data(CardID, card_element);
						_ ->	InterestData = []
					end,
					case Value -- InterestData of
						[] -> cannot_be_target;
						_ -> check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, RemainFx, AttackCase)
					end;
				_ -> false
			end;
		% �ó� assign_attack_to_s ������������੾�С��������� ��ҹ�� ���ҡ��ѧ�ҡ Interfere ���Ѻ Effect assign_attack_to_s ��
		% ����ѧ����ö������������ �֧���ͧ check AttackCase
		[{assign_attack_to_s, {disallow, Condition}}] ->
			case AttackCase of
				assign_atk ->
					case card_utility:check_card_status(CardOwner, CardOrder, CardID, assign_attack_success, arena_zone) of
						{ok, have_no_status} ->
							case Condition of
								% ��� Seal ��������� Speed �ҡ���� Target ��� Target �������
								sp_less_than_s ->
									AttackerSp = game_info:card_sp({arena_zone, {CardOwner, CardOrder, CardID}}),
									case attribute_check:sp_check({arena_zone, {TCardOwner, TCardOrder, TCardID}}, AttackerSp, less_than_s) of
										% �ó� Target Speed �ҡ���� �� Return true ��� S ����������
										true -> cannot_be_target;
										_Res -> check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, RemainFx, AttackCase)
									end;
								seal_not_combine ->
									case attribute_check:combine_check({arena_zone, {CardOwner, CardOrder, CardID}}, y) of
										% �ó� Seal ������������ҧ���� S �������
										true -> check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, RemainFx, AttackCase);
										_Res -> _Res
									end;
								all -> cannot_be_target;
								{RequireType, Value} ->
									case RequireType of
										naming ->	{ok, InterestData} = mnesia_odbc:get_seal_data(CardID, card_naming);
										type ->		{ok, InterestData} = mnesia_odbc:get_seal_data(CardID, card_type);
										elem ->		{ok, InterestData} = mnesia_odbc:get_seal_data(CardID, card_element);
										_ ->	InterestData = []
									end,
									case Value -- InterestData of
										[] -> cannot_be_target;
										_ -> check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, RemainFx, AttackCase)
									end;
								_ -> false
							end;
						{ok, have_status} -> check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, RemainFx, AttackCase)
					end;
				attack -> check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, RemainFx, AttackCase)
			end;
		[{protect_attack, [all]}] ->	cannot_be_target;
		_ -> check_remain_disallow({CardOwner, CardOrder, CardID}, {TCardOwner, TCardOrder, TCardID}, RemainFx, AttackCase)
	end.