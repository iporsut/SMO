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
-module (curse).

-export ([check_curse_status/2]).

check_curse_status ([], _) -> {ok, allow};
check_curse_status ([{_, Effect, _} | T], Condition) ->
%	io:format("Effect is ~p~n", [Effect]),
	case check_effect_cause (Effect, Condition) of
		{ok, allow} -> check_curse_status (T, Condition);
		{ok, disallow} -> {ok, disallow}
	end.

check_effect_cause ([], _) -> {ok, allow};
check_effect_cause ([{Condition, disallow} | _], Condition) -> {ok, disallow};
check_effect_cause ([{curse, Curse} | T], Condition) ->
%	io:format ("Curse condition ~p ~p ~n", [Curse, Condition]),
	case get_curse_condition (Curse, Condition) of
		allow -> check_effect_cause (T, Condition);
		disallow -> {ok, disallow}
	end;
check_effect_cause ([_ | T], Condition) -> check_effect_cause (T, Condition). 

%% Summoner Curse = {stone_curse, freeze_curse, charm_curse, poison_curse, death_curse, last_dance_curse, dimension_curse}
get_curse_condition (Curse, Condition) ->
	case Curse of
		stone_curse -> check_stone_condition (Condition);
		freeze_curse -> check_freeze_condition (Condition);
		{charm_curse, _} -> check_charm_condition (Condition);
		poison_curse -> allow;
		death_curse -> allow;
		{last_dance_curse, _} -> allow;
		dimension_curse -> check_dimension_condition (Condition);
		_ ->	allow
	end.

%% 709.3. Stone Curse
%% 709.3.1. Seal ���Դ Stone Curse ���������ö�١��觡����
%% 709.3.2. Seal ���Դ Stone Curse �������ö����, �� Skill, Combination, Break Combination ��� ��˹� Line �¼�����
%% 709.3.3. Seal ���Դ Stone Curse �ѧ������������¢ͧ�������, Mystic Card, Skill ���� Ability�������
%% 709.3.4. �ҡ Seal ���Դ Stone Curse �١���շ�� At Line Seal ����ѧ���ӡ���ǹ��Ѻ��
%% 709.3.5. Ability �ͧ Seal ���Դ Stone Curse �ѧ���ӧҹ�������
check_stone_condition (Condition) ->
	case Condition of
		assign_atk -> disallow;
		attacker -> disallow;
		use_skill -> disallow;
		combine -> disallow;
		break_combine -> disallow;
		assign_line -> disallow;
		_ -> allow
	end.

check_freeze_condition (Condition) ->
	case Condition of
		assign_atk -> disallow;
		assign_line -> disallow;
		_ -> allow
	end.

check_charm_condition (Condition) ->
	case Condition of
		combine -> disallow;
		break_combine -> disallow;
		_ -> allow
	end.

%% 709.9. Dimension Curse
%% 709.9.1. Seal ���Դ Dimension Curse �������� Line �� ���ѧ�������ʹ�� ������� Effect ���㴡�˹����Դ仨ҡ���
%% 709.9.2. Seal ���Դ Dimension Curse �������ö�١��觡����
%% 709.9.3. Seal ���Դ Dimension Curse �������ö����, �� Skill, Combination, Break Combination ��� ��˹� Line �¼�����
%% 709.9.4. Seal ���Դ Dimension Curse ��赡��������¢ͧ������� ��Ш�����Ѻ����������¨ҡ�������
%% 709.9.5. Seal ���Դ Dimension Curse �ѧ������������¢ͧ Mystic Card, Skill ���� Ability �������
%% 709.9.6. Ability �ͧ Seal ���Դ Dimension Curse �ѧ���ӧҹ�������
%% 709.9.7. ����� Seal ��¨ҡ Dimension Curse �ҡ Seal ����������� Line � � �����Ǻ��� Seal ��� ��˹� Line ���Ѻ Seal 㺹��
%% ��� Seal �������� Line � � ��͹��������ͧ�ӡ�á�˹� Line ����
check_dimension_condition (Condition) ->
	case Condition of
		assign_atk -> disallow;
		use_skill -> disallow;
		combine -> disallow;
		break_combine -> disallow;
		assign_line -> disallow;
		attack_target -> disallow;
		_ -> allow
	end.