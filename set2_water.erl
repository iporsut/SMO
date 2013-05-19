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
-module(set2_water).
-export([water2_ability/0]).

water2_ability() ->
[
	%��з�� [S] ������Ѻ [Earth] [S] At �3
	{card_ability, 
		s2_water_no47_a1, 559, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {elem, 1}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, -3}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [], null									 
	},
	%����� [S] ��������� Seal ����� Df ���¡��� [S] �Դ Freeze Curse 1� Turn
	{card_ability, 
		s2_water_no48_a1, 560, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, attack_success}],													
						y, null, [arena_zone], n, [{defend, less_than_s}, {protect_curse, {n, freeze_curse}}, {curse, {n, freeze_curse}}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, null, [arena_zone], n, [{defend, less_than_s}, {protect_curse, {n, freeze_curse}}, {curse, {n, freeze_curse}}],
												y, {do_not_need_select, 0, [{curse, freeze_curse}]}, 2									 
	},
	%��з�� [S] ������Ѻ [Fire] [S] At +2 
	{card_ability, 
		s2_water_no48_a2, 560, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {elem, 4}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [], null									 
	},
	%Charging 2
	{card_ability, 
		s2_water_no49_a1, 561, 1,
			y,[{turn, at}, {pharse, checkup}],
				n, null, [],									
					y, [{zone, [arena_zone]}, {counter, {less_than, 2}}],													
						n, null, [null], null, [], null,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{counter, 1}]}, null,											
											n, null, [null], null, [],
												null, [] ,null										
	},
	%Charging 2
	{card_ability, 
		s2_water_no51_a1, 563, 1,
			y, [{turn, at}, {pharse, checkup}],
				n, null, [],									
					y, [{zone, [arena_zone]}, {counter, {less_than, 2}}],													
						n, null, [null], null, [], null,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{counter, 1}]}, null,											
											n, null, [null], null, [],
												null, [], null									 
	},
	%�������������ö��� Seal �������������ҧ���� [S] ��
	{card_ability, 
		s2_water_no52_a1, 564, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], 1,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{assign_attack_to_s, {disallow, seal_not_combine}}]}, null,											
											n, null, [null], null, [],
												n, [], null									 
	},
	%��з�� [S] ������Ѻ [Earth] [S] At -2
	{card_ability, 
		s2_water_no52_a2, 564, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],
						y, null, [arena_zone], n, [{action, fight}, {elem, 1}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, -2}]}, end_of_fighting,
											n, null, [null], null, [],
												null, [], null									 
	},
	%��з�� [S] ������Ѻ [Earth] [S] At -2
	{card_ability, 
		s2_water_no53_a1, 565, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {elem, 1}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, -2}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [], null									 
	},
	%[Dragon] �ҵ� [Water] �ء��ʹ�� Mp ����� Skill -1(����� [S] ����� 2 㺢����ʹ�����͡��� Ability ���ӧҹ����§ 1 ���ҹ��)
	{card_ability, 
		s2_water_no54_a1, 566, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, null, [arena_zone], null, [{type,"Dragon"}, {elem, 2}],
												y, {do_not_need_select, 0, [{check, {card_target_effect, s2_water_no54_a1, {less_than, 1}, {ms, -1}}}]}, null									 
	},
	%�������������ö��� [S] ������
	{card_ability, 
		s2_water_no54_a2, 566, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [], null,												
					               y, y, {do_not_need_select, 0, [{assign_atk, disallow}]}, null,
											n, null, [null], null, [],
												null, [] ,null									
	},
	%[S] ����ö���բ�����ѧ Df Line �� ��� Seal ���١ [S] ������ Df ���¡��� [S]
	{card_ability, 
		s2_water_no55_a1, 567, 1,			
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{attack, {to_df, less, defend}}]}, null,											
											n, null, [null], null, [],													
												null, [], null									
	},
	%����� [S] ���� Seal �������� Df Line [S] At -1 ���� Subturn
	{card_ability, 
		s2_water_no55_a2, 567, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, attacker}],													
						y, null, [arena_zone], n, [{action, attacked}, {line, 0}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, -1}]}, end_of_subturn,											
											n, null, [null], null, [],
												null, [], null									 
	},
	%Seal �ء㺷������� Df Line ��ͧ�ѹ������� (All) ��� Skill (All) (At Line)
	{card_ability, 
		s2_water_no56_a1, 568, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, null, [arena_zone], n, [{card_type, seal}, {line, 0}],
												y, {do_not_need_select, 0, [{protect_attack, [attack_all]}, {protect_skill, [skill_all]}]}, null									 
	},
	%��з�� [S] ������Ѻ [Fire] [S] At +1
	{card_ability, 
		s2_water_no57_a1, 569, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {elem, 4}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, 1}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [], null									 
	},
	%��з�� [S] ������Ѻ [Tamer] [S] At -2
	{card_ability, 
		s2_water_no57_a2, 569, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {type, "Tamer"}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, -2}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [], null									 
	},
	%��з�� [S] ������Ѻ Seal ���Դ Curse [S] At+1
	{card_ability, 
		s2_water_no60_a1, 572, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {curse, y}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, 1}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [] ,null									
	},
	%��з�� [S] ������Ѻ [Insect] [S] At +2
	{card_ability, 
		s2_water_no61_a1, 573, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {type, "Insect"}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting,											
											n, null, [null], null, [],
												null, [], null									 
	},
	%[S] ¡��ԡ Skill �ͧ [Insect]
	{card_ability, 
		s2_water_no61_a2, 573, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{cancel_skill, [{type, "Insect"}]}]}, null,											
											n, null, [null], null, [],
												null, [], null										 
	}	
].