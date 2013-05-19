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
-module(set1_dark).
-export([dark1_ability/0]).

dark1_ability() -> 
[
	%[S] ����ö���բ�����ѧ Df Line �� ��� Seal ���١ [S] ������ Sp �ҡ���� [S] 
	{card_ability, 
		s1_dark_no76_a1, 332, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{attack, {to_df, more, speed}}]}, null,											
											n, null, [null], null, [],													
												null, [], null
	},
	%��з�� [S] ������Ѻ Seal �������� Df Line [S] At +2
	{card_ability, 
		s1_dark_no76_a2, 332, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						y, null, [arena_zone], n, [{action, fight}, {line, 0}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting,											
											n, null, [null], null, [],													
												null, [], null										
	},
	% charging2
	{card_ability, 
		s1_dark_no77_a1, 333, 1,
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
	%����� [S] �� Shrine �ҡʹ�� �������ö�� Mystic Card 1 �� Shrine ��Ң����� 
	{card_ability, 
		s1_dark_no80_a1, 336, 1,
			n,[],
				n, null, [],									
					y, [{zone, [shrine_cards]}, {action, arena_to_shrine}, {action, into_shrine}, {stack_check, card_destroy}],													
						y, owner, [shrine_cards], null, [{card_type, mystic}], 1,
							c, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, owner, [shrine_cards], null, [{card_type, mystic}],
												y, {owner_can_select_exact_target, 1, [{action, move_to_hand}]} ,null										
	},
	%��Һ��ҷ�� [S] ����� Shrine �������ö�� [S] ������ʹ���ҡ Shrine �� 
	{card_ability, 
		s1_dark_no80_a2, 336, 2,
			n,[],
				n, null, [],									
					y, [{zone, [shrine_cards]}, {action, in_shrine}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{disallow, shrine_to_arena}]}, null,											
											n, null, [null], null, [],
												null, [] ,null										
	},
	%[S] ����ö���բ�����ѧ Df Line �� 
	{card_ability, 
		s1_dark_no82_a1, 338, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{attack, to_df}]}, null,											
											n, null, [null], null, [],
												null, [] ,null										
	},
	%���Ǻ��� [S] �������ö��˹� Line ��� [S] ������ Df Line �� 
	{card_ability, 
		s1_dark_no82_a2, 338, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{disallow, assign_line_to_df}]}, null,											
											n, null, [null], null, [],
												null, [] ,null										
	},
	%��з�� [S] ������ Seal ��������Ѻ [S] Sp -1 ���� Subturn
	{card_ability,  
		s1_dark_no83_a1, 339, 1,
			n, [],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, fight}],													
						n, null, [null], null, [], null,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, null, [], null,											
											y, null, [arena_zone], n, [{action, fight}],
												y, {do_not_need_select, 0, [{sp, -1}]} ,end_of_subturn										
	},
	% charging3
	{card_ability, 
		s1_dark_no86_a1, 342, 1,
			y, [{turn, at}, {pharse, checkup}],
				n, null, [],									
					y, [{zone, [arena_zone]}, {counter, {less_than, 3}}],													
						n, null, [null], null, [], null,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{counter, 1}]}, null,											
											n, null, [null], null, [],
												null, [] ,null										
	},
	%��Һ��ҷ�� [S] �Դ Mystic Card ������ [Tarot]: The Moon [S] At +2
	{card_ability, 
		s1_dark_no87_a1, 343, 1,
			n, [],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
			               n, null, [], null,
									n, null, null, [], null,												
					               y, y, {do_not_need_select, 0, [{at, 2}]}, null,											
											n, null, [null], null, [],
												null, [] ,null										
	},
	%����� [S] �١���� [S] �Դ Last Dance Curse At +2 / 1 Turn
	{card_ability,  
		s1_dark_no88_a1, 344, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, attacked}, {protect_curse, {n, last_dance_curse}}, {curse, {n, last_dance_curse}}],													
						n, null, [null], null, [], null,
							c, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{curse, {last_dance_curse, {at, 2}}}]}, 2,											
											n, null, [null], null, [],
												null, [] ,null										
	},
	%����� Seal �������� [S] At +1 / 1 Turn
	{card_ability,
		s1_dark_no89_a1, 345, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}],													
						y, null, [arena_zone], n, [{action, attacker}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               y, y, {do_not_need_select, 0, [{at, 1}]}, 2,											
											n, null, [null], null, [],
												null, [] ,null										
	},
	%����� [S] ������ʹ���ҡ�ͧ���� Seal 1 ��٭���� 1 Charge Counter ��� Seal 1 ����Ѻ 1 Charge Counter
	{card_ability,
		s1_dark_no90_a1a, 346, 1,
			n,[],
				n, null, [],									
					y, [{action, into_arena}, {action, deck_to_arena}, {stack_check, self}],													
						y, null, [arena_zone], y, [{counter, {more_than, 1}}], 1,
							n, [],
			               n, n, [], null,
									n, null, null, [],	null,												
					               n, n, [], null,											
											y, null, [arena_zone], y, [{counter, {more_than, 1}}],
												y, {owner_select_exact_target, 1, [{counter, -1}]} ,null										
	},
	%����� [S] ������ʹ���ҡ�ͧ���� Seal 1 ��٭���� 1 Charge Counter ��� Seal 1 ����Ѻ 1 Charge Counter
	{card_ability, 
		s1_dark_no90_a1b, 346, 1,
			n,[],
				n, null, [],									
					y, [{action, into_arena}, {action, deck_to_arena}, {stack_check, self}],													
						y, null, [arena_zone], y, [{counter, {more_than, 1}}], 1,
							n, [],
			               n, n, [], null,
									n, null, null, [],	null,												
					               n, n, [], null,											
											y, null, [arena_zone], y, [],
												y, {owner_select_exact_target, 1, [{counter, 1}]} ,null										
	},
	%����� [S] �� Shrine �ҡ�ͧ���� Seal 1 ��٭���� 1 Charge Counter ��� Seal 1 ����Ѻ 1 Charge Counter
	{card_ability, 
		s1_dark_no90_a1c, 346, 1,
			n,[],
				n, null, [],									
					y, [{zone, [shrine_cards]}, {action, into_shrine}, {action, deck_to_shrine}, {stack_check, card_destroy}],													
						y, null, [arena_zone], y, [], 1,
							c, [],
			               n, n, [], null,
									n, null, null, [],	null,												
					               n, n, [], null,											
											y, null, [arena_zone], y, [],
												y, {owner_select_exact_target, 1, [{counter, 1}]} ,null				
	},
	%����� [S] �� Shrine �ҡ�ͧ���� Seal 1 ��٭���� 1 Charge Counter ��� Seal 1 ����Ѻ 1 Charge Counter
	{card_ability, 
		s1_dark_no90_a1d, 346, 1,
			n,[],
				n, null, [],									
					y, [{zone, [shrine_cards]}, {action, into_shrine}, {action, deck_to_shrine}, {stack_check, card_destroy}],													
						y, null, [arena_zone], y, [], 1,
							c, [],
			               n, n, [], null,
									n, null, null, [],	null,												
					               n, n, [], null,											
											y, null, [arena_zone], y, [],
												y, {owner_select_exact_target, 1, [{counter, -1}]} ,null										
	},
	%����� [S] �� Shrine �ҡʹ�� Seal 1 ��ʹ�� At -1 / Subturn
	{card_ability, 
		p1_dark_no115_a1, 371, 1,
			n, [],
				n, null, [],									
					y, [{zone, [shrine_cards]}, {action, arena_to_shrine}, {action, into_shrine}, {stack_check, card_destroy}], 											
						y, null, [arena_zone], y, [{card_type, seal}], 1,
							c, [],
								n, null, [], null,
									n, null, null, [],	null,										
										n, null, [], null, 
											y, null, [arena_zone], n, [{card_type, seal}],
												y, {owner_select_exact_target, 1, [{at, -1}]}, 1
	},
	%����� [S] ������ʹ�� Seal 1 ��ʹ�� At -1 / Subturn
	{card_ability, 
		p1_dark_no115_a2, 371, 2,
			n, [],
				n, null, [],									
					y, [{action, into_arena}, {stack_check, self}],
						n, null, [], null, [], null,
							c, [],
								n, null, [], null,
									n, null, null, [],	null,										
										n, null, [], null, 
											y, null, [arena_zone], y, [{card_type, seal}],
												y, {owner_select_exact_target, 1, [{at, -1}]}, 1
	}
].

