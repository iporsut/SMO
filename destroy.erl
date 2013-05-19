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

-module (destroy).

-export ([
						check_card_destroyed/3,
						do_card_destroyed/3,
						verify_destroy_ability/0,
						activate_destroy_effect/0,
						destroy_to_shrine/0
					]).

check_card_destroyed(PlayerPid, DestroyList, DestroyType) ->
	case DestroyType of
		sacrifice -> 
			case check_card_destroy_zone(DestroyList) of
				all_supported -> destroy_support_seal:support_to_destroy(PlayerPid, DestroyList);
				_CardZone -> do_card_destroyed(PlayerPid, DestroyList, DestroyType)
			end;
		_ -> do_card_destroyed(PlayerPid, DestroyList, DestroyType)
	end.

check_card_destroy_zone([]) -> all_supported;
check_card_destroy_zone([{CardOwner, CardOrder, CardID}|Destroy]) ->
	case card_utility:check_card_zone(CardOwner, CardOrder, CardID) of
		support_cards -> check_card_destroy_zone(Destroy);
		CardZone -> CardZone
	end.
	
% 701. ��鹵͹��ö١�����
do_card_destroyed(PlayerPid, DestroyList, DestroyType) ->
	stack_pool:push_stack(self(), 0, 0, 0, [{card_player, PlayerPid}, {destroy_list, DestroyList}, {destroy_type, DestroyType}]),
	lists:foreach(fun({CardOwner, CardOrder, CardID}) -> 
		CardZone = card_utility:check_card_zone(CardOwner, CardOrder, CardID),
		card_utility:add_card_status(CardOwner, CardOrder, CardID, destroyed, CardZone) end, DestroyList),
% 701.1. ����� Seal �١����¨ҡ��õ����� ���� ���� Effect ��ҧ� ��� Mystic Card ���١����´��� Effect
% ��ҧ� �����¡ Seal ���� Mystic Card ���١�������� ���촷��١����� ���촷��١������������ö
% ����������¢ͧ��÷���«���ա������������ö����¹��ѧ Zone ����¼Ţͧ Effect �� �͡�ҡ Shrine
% 701.2. Ability ����ͷ����, ����ͷ���������, ����Ͷ١����� ���/���� Ability ����Ͷ١���������� ����ա��
% ���͡��÷ӧҹ������͡� Phase ��� ��Ш�����ա������¹�ŧ �͡�ҡ���� Effect �������ö���� -
% 701.3. �ҡ��ͧ�ӡ�����͡������� ������͡�������� Phase ���-
% 701.4. ��Ǩ�ͺ��� Ability ����ö�觼šѺ������·���˹���������� �ҡ Ability �������ö�觼šѺ
% ������·���˹� ���� ������·���˹�����������Ҿ������������� ����Ѻ����͡
% �������� Phase 701.3. ���� �ҡ������������������ Ability ���� ����ö�觼� ���� ��˹� �� Ability ��鹨����ӧҹ
% 701.5. Ability ����ͷ����, ����ͷ���������, ����Ͷ١����� ���/���� Ability ����Ͷ١���������� �зӧҹ
% � Phase ��� ������͹�㹡���Դ �ѧ�١��ͧ
% 701.6. ���촷��١����¨��٭������Ҿ���촷��١������ Phase ��� -
% 701.7. �ӡ��촹����ѧ Shrine ¡����� Effect ����к�������������蹹��
	stack_pool:set_stack_option (self(), play, check_destroyed_ability),
	mod_ability_activate:check_any_ability_activate(destroyed, PlayerPid).
	
verify_destroy_ability() ->
	stack_pool:set_stack_option(self(), play, verify_destroyed_ability),
	mod_ability_activate:verify_ability_condition(destroyed).
	
activate_destroy_effect() ->
	stack_pool:set_stack_option(self(), play, activate_destroyed_effect),
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	mod_ability_effect:check_any_ability_activate(destroyed, PlayerPid).

destroy_to_shrine() ->
	{ok, PlayerPid} = stack_pool:get_last_stack(self(), card_player),
	{ok, DestroyList} = stack_pool:get_last_stack(self(), destroy_list),
	{ok, DestroyType} = stack_pool:get_last_stack(self(), destroy_type),
	lists:foreach(fun({CardOwner, CardOrder, CardID}) -> card_utility:remove_card_status(CardOwner, CardOrder, CardID, destroyed) end, DestroyList),
	stack_pool:pop_stack_out(self()),
	%SupportSeal = card_utility:get_support_seal(DestroyList),
	%shrine_zone:card_to_shrine(PlayerPid, DestroyList ++ SupportSeal, DestroyType).
	shrine_zone:card_to_shrine(PlayerPid, DestroyList, DestroyType).