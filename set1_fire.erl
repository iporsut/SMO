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
-module(set1_fire).
-export([fire1_ability/0]).

fire1_ability() ->
[
	%����� [S] ���� [S] + At ����ӹǹ Seal � At Line ������Ҩ��� Subturn
	{card_ability, 
		s1_fire_no032_a1, 288, 1,
			n,[],
				n, null, [],									
					y, [{action, attacker}],											
						n, null, [null], null, [], null,
							c, [],
								n, null, [], null,
									n, null, null, [],	null,
										y, y, {do_not_need_select, 0, [{at, {'+', {{target, owner, [arena_zone], seal, y}, [{line, 1}]}}}]}, end_of_subturn,											
											n, null, [null], null, [],
												null, [] ,null
	},
	%Seal ����� Mp ������¹��¡��� [S] �ء��ʹ�����µç���� At �1 Df �1
	{card_ability, 
		s1_fire_no033_a2, 289, 2,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [],	null,
										n, null, [], null,											
											y, opponent, [arena_zone], null, [{card_type, seal}, {mpcast, less_than_s}],
												y, {do_not_need_select, 0, [{at, -1}, {df, -1}]}, null					
	},
	%[S] ����ö���բ�����ѧ Df Line �� ��� Seal ���١ [S] ������ Sp �ҡ���� [S]
	{card_ability, 
		s1_fire_no033_a1, 289, 1,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{attack, {to_df, more, speed}}]}, null,			
											n, null, [null], null, [],
												null, [] ,null
	},
	%����� [S] ���� Seal ����� Sp �ҡ���� [S] ���Ǻ��� [S] ����ö���͡��� [S] ��º��Ҿ�ѧ�ͧ [S] �Ѻ At ���� Df �ͧ Seal ���١ [S] ����
	{card_ability,
		s1_fire_no034_a1, 290, 1,
			n,[],
				n, null, [],									
					y, [{action, attacker}],											
						y, null, [arena_zone], n, [{speed, more_than_s}, {action, attacked}], 1,
							n, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {controller_can_activate_ability, 0, [{action, can_compare_to_at_or_df_of_attacked}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%����� [S] ���� ���Ǻ��� [S] ����ö���͡��� [S] ��º��Ҿ�ѧ�ͧ [S] �Ѻ At ���� Df �ͧ Seal ���١ [S]���� 
	{card_ability, 
		s1_fire_no036_a1, 292, 1,
			n, [],
				n, null, [],									
					y, [{action, attacker}], 											
						n, null, [null], null, [], null,
							n, [],
								n, null, [], null,
									n, null, null, [], null,										
										y, y, {controller_can_activate_ability, 0, [{action, can_compare_to_at_or_df_of_attacked}]}, null, 
											n, null, [null], null, [],
												n, [], null
	},
	%����� [S] ���� [S] At +2 ���� Subturn
	{card_ability, 
		s1_fire_no037_a1, 293, 1,
			n,[],
				n, null, [],									
					y, [{action, attacker}],											
						n, null, [null], null, [], null,
							c, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_subturn,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%��Һ��ҷ�� [S] �������� [S] -Mp ������µ���ӹǹ [Evil] � Shrine ���
	{card_ability, 
		s1_fire_no038_a1, 294, 1,
			n,[],
				n, null, [],									
					y, [{zone, [hand_cards]}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{mc, {'-', {{target, owner, [shrine_cards], seal, null}, [{type, "Evil"}]}}}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%����� [Fire] ������ҵ� Shrine �ҡʹ�� [S] At +2 ���� Subturn(Ability ���ӧҹ 1 ����� 1 Turn)
	{card_ability,
		s1_fire_no040_a1, 296, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {activate_ability, {1, 1}}], % 1 ���� � 2 Subturn
						%y, owner, [shrine_cards], n, [{action, into_shrine}, {action, arena_to_shrine}, {elem, 4}], 1,
						y, owner, [shrine_cards], n, [{action, into_shrine}, {action, arena_to_shrine}, {elem, 4}, {stack_check, card_destroy}], 1,
							c, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_subturn,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%��Һ��ҷ�� Seal �ʹ�����µç�����ҡ������� [S] At +3 
	{card_ability, 
		s1_fire_no042_a1, 298, 1,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{at, 3}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%��Һ��ҷ�� Seal �ʹ�����µç�������¡������ [S] At -3 
	{card_ability, 
		s1_fire_no042_a2, 298, 2,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{at, -3}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%[S] ����ö���ըҡ Df Line ��
	{card_ability, 
		s1_fire_no044_a1, 300, 1,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{attack, from_df}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%��Һ��ҷ�� [S] �����ҧ [S] ����ö���բ�����ѧ Df Line �� (At Line)
	{card_ability, 
		s1_fire_no044_a2, 300, 2,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{attack, to_df}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%[S] +At ����ӹǹ [S] �����ʹ��
	{card_ability, 
		s1_fire_no045_a1, 301, 1,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										%y, y, {do_not_need_select, 0, [{at, {'+', same_name_as_s_arena}}]}, null,
										y, y, {do_not_need_select, 0, [{at, {'+', {{target, null, [arena_zone], seal, n}, [{name, "Souless"}]}}}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%����� [S] ���� �������ö Sacrifice Seal 1 � ��� Seal 1 ��ʹ������� Sp �ҡ���� [S] �¡��������ҧ
	{card_ability, 
		p1_fire_no114_a1a, 370, 1,
			n, [],
				n, null, [],									
					y, [{zone,[arena_zone]}, {action, attacker}, {{null, [arena_zone], seal, n}, {[{combine, {card_type, is_seal}}, {speed, more_than_s}], 1}}],											
						y, controller, [arena_zone], n, [{card_type, seal}], 1,
							c, [],
								n, null, [], null,
									n, null, null, [],	null,										
										n, null, [], null, 
											y, owner, [arena_zone], n, [{card_type, seal}],
												y, {owner_can_select_exact_target, 1, [{player_action, sacrifice}]}, null
	},
	{card_ability, 
		p1_fire_no114_a1b, 370, 1,
			n, [],
				n, null, [],									
					y, [{zone,[arena_zone]}, {action, attacker}, {{null, [arena_zone], seal, n}, {[{combine, {card_type, is_seal}}, {speed, more_than_s}], 1}}], 											
						y, controller, [arena_zone], n, [{card_type, seal}], 1,
							c, [],
								n, null, [], null,
									n, null, null, [],	null,										
										n, null, [], null, 
											y, null, [arena_zone], n, [{card_type, seal}, {combine, {card_type, is_seal}}, {speed, more_than_s}],
												y, {owner_select_exact_target, 1,[{action, break_combine}]}, null
	},
	%����� [S] ������ʹ�� [Fire] ���� 1 ��ʹ��������� At +2 ���� Subturn
	{card_ability, 
		s1_fire_no120_a1, 376, 1,
			n,[],
				n, null, [],									
					y, [{action, into_arena}, {stack_check, self}],													
						%y, owner, [arena_zone], n, [{elem, 4}], 1,
						y, owner, [arena_zone], n, [{elem, 4}], 1,
							n, [],
			               n, null, [], null,
									n, null, null, [],	null,												
					               n, n, {}, null,											
											%y, owner, [arena_zone], n, [{elem, 4}],	
											y, owner, [arena_zone], n, [{elem, 4}],
												y, {owner_select_exact_target, 1, [{at, 2}]} , end_of_subturn
	},
	%[S] ¡��ԡ Skill �ͧ [Wind] ��� Death Curse
	{card_ability, 
		s1_fire_no120_a2, 376, 2,
				n,[],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, on_arena}],					
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,                        
										n, null, null, [], null,												
											%y, y, {do_not_need_select, 0, [{cancel_skill, [{elem, 3}]}, {cancel_curse, [death_curse]}]}, null,	
											y, y, {do_not_need_select, 0, [{cancel_skill, [{elem, 3}]}, {cancel_curse, [death_curse]}]}, null,	
												n, null, [null], null, [],
													null, [] ,null					
	}
].

