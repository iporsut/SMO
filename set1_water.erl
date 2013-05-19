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
-module(set1_water).
-export([water1_ability/0]).

water1_ability() ->
[
	%����� [S] ������ʹ���� Seal �ء��ʹ������� Sp ���¡��� [S] 价�� Df Line (�Ũҡ Ability ������Ѻ����繡�á�˹� Line)
	{card_ability, 
		s1_water_no46_a1, 302, 1,
			n,[],
				n, null, [],									
					y, [{action, into_arena}, {stack_check, self}],													
						y, null, [arena_zone], n, [{line, 1}, {speed, less_than_s}], 1,
							c, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, null, [arena_zone], n, [{line, 1}, {speed, less_than_s}],													
												y, {do_not_need_select, 0, [{action, to_df_line}]}, null									
	},
	%��з�� [S] ������ ��º��Ҿ�ѧ�ͧ [S] �Ѻ Df �ͧ Seal ��������Ѻ [S]
	{card_ability,
		s1_water_no47_a1, 303, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						n, null, [null], null, [], null,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{combat, {when_fight_attack, {power, df}}}, {combat, {when_fight_target, {df, power}}}]}, end_of_fighting,											
											n, null, [], null, [],													
												null, [] ,null									
	},
	%[Water] ���蹷ء��ʹ��������� At +
	{card_ability, 
		s1_water_no49_a1, 305, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, owner, [arena_zone], n, [{elem, 2}],													
												y, {do_not_need_select, 0, [{at, 1}]} , null
	},
	%Seal �ء㺽��µç��������� Df ���¡��� [S] At -1
	{card_ability, 
		s1_water_no50_a1, 306, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, opponent, [arena_zone], n, [{defend, less_than_s}],													
												y, {do_not_need_select, 0, [{at, -1}]}, null						
	},
	%����� [S] �١���մ��� Seal ����� Df ���¡��� [S] [S] At +2 ���͡�ҡ������չ��
	{card_ability,
		s1_water_no51_a1, 307, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, attacked}],													
						y, opponent, [arena_zone], null, [{action, attacker}, {defend, less_than_s}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,											
										y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [] ,null													
	},
	%��з�� [S] ������Ѻ Seal ���Դ Curse [S] At +2
	{card_ability, 
		s1_water_no51_a2, 307, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {curse, y}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,											
					               y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [] ,null													
	},
	%����� [S] �� Shrine �ҡʹ�� ��� Mp +1
	{card_ability,
		s1_water_no53_a1, 309, 1,
			n,[],
				n, null, [],									
					y, [{action, arena_to_shrine}, {action, into_shrine}, {stack_check, card_destroy}],													
						n, null, [], null, [], null,
							n, [],
			               y, y, {do_not_need_select, 0, [{mp, 1}]}, null,
									n, null, null, [],	null,											
					               n, null, [], null,											
											n, null, [null], null, [],
												null, [] ,null													
	},
	%����� [S] ������ʹ�� �������ö�ʴ� [Insect] ����������� [S] 1 㺨ҡ�ͧ���� Seal ������ǹӢ�����
	{card_ability,
		s1_water_no56_a1, 312, 1,
			n,[],
				n, null, [],									
					y, [{action, into_arena}, {stack_check, self}],													
						y, owner, [seal_deck], n, [{type, "Insect"}, {name, {n, "Aqualo"}}], 1,
							c, [],
			               n, null, [], null,
									n, null, null, [],	null,											
					               n, null, [], null,											
											y, owner, [seal_deck], n, [{type, "Insect"}, {name, {n, "Aqualo"}}],
												y, {owner_can_select_exact_target, 1, [{action, move_to_hand}]} ,null													
	},
	%��з�� [S] ������Ѻ Seal ���Դ Curse  [S] At +2 
	{card_ability, 
		s1_water_no58_a1, 314, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {curse, y}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,											
					               y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [] ,null													
	},
	%��з�� [S] ������Ѻ Seal ���Դ Freeze Curse [S] At +2
	{card_ability, 
		s1_water_no59_a1, 315, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {curse, freeze_curse}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,											
					               y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [] ,null													
	},
	%[S] ¡��ԡ Freeze Curse
	{card_ability, 
		s1_water_no59_a2, 315, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{cancel_curse, [freeze_curse]}]}, null,											
											n, null, [null], null, [],
												null, [] ,null									
	},
	%��Һ��ҷ���� Seal �Դ Freeze Curse [S] At +1 Df -1
	{card_ability, 
		p1_water_no116_a1, 372, 1,
			n, [],
				n, null, [],									
					y, [{action, on_arena}],
						n, null, [nul], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [],	null,										
										y, y, {do_not_need_select, 0, [{at, 1}, {df, -1}]}, null, 
											n, null, [null], null, [],
												n, [], null
	},
	%����� [S] ������ʹ�� Seal 1 ��ʹ������� Df ���¡��� [S] �Դ Freeze Curse ���� Subturn
	{card_ability, 
		p1_water_no117_a1, 373, 1,
			n, [],
				n, null, [],									
					y, [{action, into_arena}, {stack_check, self}],
						y, null, [arena_zone], y, [{defend, less_than_s}, {curse, {n, freeze_curse}}, {protect_curse, {n, freeze_curse}}], 1,
							c, [],
								n, null, [], null,
									n, null, null, [],	null,										
										n, null, [], null, 
											y, null, [arena_zone], y, [{defend, less_than_s}, {curse, {n, freeze_curse}}, {protect_curse, {n, freeze_curse}}],
												y, {owner_select_exact_target, 1, [{curse, freeze_curse}]}, 1
	},
	%����������� Subturn ��ͧ�ѹ�ͧ��� [Water] ���蹷ء㺽������ Df +1 ���� Subturn
	{card_ability, 
		p1_water_no117_a2, 373, 2,
			y, [{turn, df}, {pharse, checkup}],
				n, null, [],									
					y, [{zone, [arena_zone]}],
						y, null, [arena_zone], n, [{elem, 2}], 1,
							n, [],
								n, null, [], null,
									n, null, null, [], null,										
										n, null, [], null,
											y, owner, [arena_zone], n, [{elem, 2}],
												y, {do_not_need_select, 0, [{df, 1}]}, 1
	}
].