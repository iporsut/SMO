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
-module(set1_wind).
-export([wind1_ability/0]).

wind1_ability() ->
[	
	%����� [S] ������ʹ�� [S] At +1 / 1 Turn
	{card_ability, 
		s1_wind_no61_a1, 317, 1,
			n,[],
				n, null, [],									
					y, [{action, into_arena}, {stack_check, self}],													
						n, null, [null], null, [], null,
							c, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, 1}]}, 2,											
											n, null, [null], null, [],													
												null, [], null									
	},
	%[S] [S] ����ö���բ�����ѧ Df Line �� ��� Seal ���١ [S] ������ Sp ���¡��� [S] 
	{card_ability, 
		s1_wind_no61_a2, 317, 2,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
							   n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{attack, {to_df, less, speed}}]}, null,											
											n, null, [null], null, [],													
												null, [], null									
	},
	%��з�� [S] ������Ѻ Seal �������� Df Line [S] At +2
	{card_ability, 
		s1_wind_no61_a3, 317, 3,
			n,[],
				n, null, [],									
					y, [{action, fight}],													
						y, null, [arena_zone], n, [{line, 0}, {action, fight}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting,											
											n, null, [null], null, [],													
												null, [], null									
	},
	%����� [S] ���� Seal ���١ [S] ���� Sp =0 ���͡�ҡ������չ��
	{card_ability,  
		s1_wind_no63_a1, 319, 1,
			n,[],
				n, null, [],									
					y, [{action, attacker}],													
						y, null, [arena_zone], n, [{action, attacked}], 1,
							c, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, null, [arena_zone], n, [{action, attacked}],													
												y, {do_not_need_select, 0, [{sp, {equal, 0}}]}, end_of_fighting									
	},
	%����� [S] ������ʹ���� Seal �ء��ʹ������� Sp ���¡��� [S] 价�� At Line (�Ũҡ Ability ������Ѻ����繡�á�˹� Line)
	{card_ability, 
		s1_wind_no63_a2, 319, 2,
			n,[],
				n, null, [],									
					y, [{action, into_arena}, {stack_check, self}],													
						y, null, [arena_zone], n, [{speed, less_than_s}, {can_move_to, 1}, {line, null}], 1,
							c, [],
								n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, null, [arena_zone], n, [{speed, less_than_s}, {can_move_to, 1}, {line, null}],													
												y, {do_not_need_select, 0, [{action, to_at_line}]}, null									
	},
	%�����蹷ء���������ö��˹� Line Seal ����� Df �ҡ���� [S] �������¹ Line �� (At Line)
	{card_ability, 
		s1_wind_no65_a1, 321, 1,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],													
						n, null, [null], n, [], null,
							y, [],
				            n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, null, [arena_zone], n, [{defend, more_than_s}],
											%y, null, [arena_zone], y, [],
												y, {do_not_need_select, 0, [{disallow, assign_line}]}, null									
	},
	%����� [S] �� Shrine �ҡʹ������� Seal 1 㺷���� At ���¡��� [S]
	{card_ability, 
		s1_wind_no70_a1, 326, 1,
			n,[],
				n, null, [],									
					y, [{action, arena_to_shrine}, {action, into_shrine}, {stack_check, card_destroy}],													
						y, null, [arena_zone], n, [{card_type, seal}, {attack, less_than_s}], 1,
							c, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, null, [arena_zone], n, [{card_type, seal}, {attack, less_than_s}],
												y, {owner_select_exact_target, 1, [{action, destroy}]}, null										
	},
	%��з�� [S] ������Ѻ Seal ����� At ��ҡѺ [S] [S] Sp +1
	{card_ability, 
		s1_wind_no71_a1d, 327, 1,
			n,[],
				n, null, [],									
					y, [{action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {attack, equal_to_s}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{sp, 1}]}, end_of_fighting,											
											n, null, [null], null, [],													
												null, [], null										
	},
	%����� [S] ������ʹ�� [S] Sp+1 / 1 Turn
	{card_ability, 
		s1_wind_no72_a1, 328, 1,
			n,[],
				n, null, [],									
					y, [{action, into_arena}, {stack_check, self}],													
						n, null, [null], null, [], null,
							c, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{sp, 1}]}, 2,											
											n, null, [null], null, [],													
												null, [], null										
	},
	%[S] +Sp ����ӹǹ Mystic Card ���ͼ��Ǻ���
	{card_ability, 
		s1_wind_no73_a1, 329, 1,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{sp, {'+', {{target, controller, [hand_cards], mystic, null}, []}}}]}, null,											
											n, null, [null], null, [],													
												null, [], null										
	},
	%��Һ��ҷ�� [S] �����ҧ Seal �ء��ʹ��������� Sp = 4
	{card_ability, 
		s1_wind_no74_a1, 330, 1,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, owner, [arena_zone], y, [{card_type, seal}],													
												y, {do_not_need_select, 0, [{sp, {equal, 4}}]}, null										
	},
	%��Һ��ҷ������� [S] �����ʹ������� 2 㺢��� �����蹽��µç�����ء�����������٧�ش -1 (����� [S] ����� 2 㺢����ʹ��������� ���͡ Ability ���ӧҹ����§ 1 ���ҹ��)
	{card_ability, 
		s1_wind_no75_a1, 331, 1,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									y, y, opponent, {do_not_need_select, 0, [{check, {player_target_effect, s1_wind_no75_a1, {less_than, 1}, {card_on_hand, -1}}}]},	null,												
					               n, null, [], null,											
											n, null, [null], null, [],													
												null, [], null										
	},
	%��Һ��ҷ�� [S] �� [Dragon] �� Seal ��ͧ�����ҧ [S] ����ö���բ�����ѧ Df Line ��
	{card_ability, 
		s1_wind_no111_a1, 367, 1,
			n, [],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],											
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,
										n, null, null, [], null,
											y, y, {do_not_need_select, 0, [{attack, to_df}]}, null,											
												n, null, [null], null, [],
													null, [] ,null
	},
	%��з�� [S] ������Ѻ Seal �������� Df Line [S] At +2 Df +2
	{card_ability, 
		s1_wind_no111_a2, 367, 2,
			n,[],
				n, null, [],									
					y, [{action, fight}],													
						y, null, [arena_zone], n, [{line, 0}, {action, fight}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, 2}, {df, 2}]}, end_of_fighting,											
											n, null, [null], null, [],													
												null, [], null									
	},
	%N[Charles] �ء��ʹ�� Sp +1
	{card_ability, 
		p1_wind_no118_a1, 374, 1,
			n, [],
				n, null, [],									
					y, [{action, on_arena}],
						n, null, [], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,										
										n, null, [], null,
											y, null, [arena_zone], y, [{card_type, seal}, {naming, "Charles"}],
												y, {do_not_need_select, 0, [{sp, 1}]}, null
	},	
	%����� [S] ������ʹ�� N[Charles] 1 ��ʹ�� At +1 / 1 Turn
	{card_ability, 
		p1_wind_no118_a2, 374, 2,
			n, [],
				n, null, [],									
					y, [{action, into_arena}, {stack_check, self}],
						y, null, [arena_zone], y, [{card_type, seal}, {naming, "Charles"}], 1,
							c, [],
								n, null, [], null,
									n, null, null, [], null,										
										n, null, [], null,
											y, null, [arena_zone], y, [{card_type, seal}, {naming, "Charles"}],
												y, {owner_select_exact_target, 1, [{at, 1}]}, 2
	}
].