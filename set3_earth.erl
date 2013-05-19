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
-module(set3_earth).
-export([earth3_ability/0]).

earth3_ability() ->
[
	%*20 ����������� Subturn ��ͧ�ѹ�ͧ��� [S] + At ��� Df �ͧ [S] ���� Subturn
	{card_ability, 
		s3_earth_no020_a1, 788, 1,
			y, [{turn, df}, {pharse, checkup}],
				n, null, [],									
					y, [{zone, [arena_zone]}],											
						n, null, [null], null, [], null,
							n, [],
								n, null, [], null,
									n, null, null, [],	null,
										y, y, {do_not_need_select, 0, [{at, {'+', s_current_df}}]}, end_of_subturn,											
											n, null, [null], null, [],
												null, [] ,null
	},
	%*23 ����� [S] �١���� [S] +At ����ӹǹ Seal �������Ҿѹ�������͹�Ѻ Seal ������ս��¼��Ǻ��� Seal ������� 1 Turn
	{card_ability,  
		s3_earth_no023_a1, 791, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, attacked}],													
						n, null, [null], null, [], null,
							n, [],
								n, null, [], null,
									n, null, null, [],	null,												
										y, y, {do_not_need_select, 0, [{at, {'+', {seal_card, type, attacking_type, zone, arena_zone, owner, {controller, attacker}}}}]}, 2,											
											n, null, [null], null, [],
												null, [] ,null										
	},
	%*23 [S] +At ����ӹǹ [Be] � Shrine ���µç����
	{card_ability,
		s3_earth_no023_a2, 791, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{at, {'+', {seal_card, type, ["Beast"], zone, shrine_cards, owner, opponent}}}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%*25 ��Һ��ҷ���� Grace, the Valkyrie �����ʹ�� [S] At +1 Df +1 ���¡��ԡ Curse
	{card_ability, 
		s3_earth_no025_a1, 793, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{at, 1}, {df, 1}, {cancel_curse, [all]}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%*26 ����� [S] ������ʹ���ҡ��� [S] ��ͧ�ѹ������� 1 Turn (Ability �������ӧҹ�������� [Uni] ���蹵���� 2 㺢����ʹ���������)
	{card_ability, 
		s3_earth_no026_a1, 794, 1,
			n,[],
				n, null, [],									
					y, [{action, into_arena}, {action, hand_to_arena}, {stack_check, self}],													
						y, owner, [arena_zone], n, [{naming, "Unicorn"}], 2,
							n, [],
								n, null, [], null,
									n, null, null, [],	null,												
										y, y, {do_not_need_select, 0, [{protect_attack, [all]}]}, 2,											
											n, null, [null], null, [],
												null, [] ,null									
	},
	%*27 ����� [S] ������ʹ�� [Be] ���/���� [Mo] 1 㺵Դ Charm Curse 2 Turn
	{card_ability, 
		s3_earth_no027_a1, 795, 1,
			n,[],
				n, null, [],									
					y, [{action, into_arena}, {stack_check, self}],											
						y, null, [arena_zone], y, [{card_type, seal}, {type_or, ["Beast","Monster"]}, {protect_curse, {n, charm_curse}}, {curse, {n, charm_curse}}], 1 ,
							n, [],
								n, null, [], null,
									n, null, null, [],	null,
										n, null, [], null,											
											y, null, [arena_zone], y, [{card_type, seal}, {type_or, ["Beast","Monster"]}, {protect_curse, {n, charm_curse}}, {curse, {n, charm_curse}}],
												y, {owner_select_exact_target, 1, [{curse, charm_curse}]}, 4					
	},
	%*27 �����蹷ء���������ö��� [Be] ���� [S] ��
	{card_ability, 
		s3_earth_no027_a2, 795, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,												
										y, y, {do_not_need_select, 0, [{assign_attack_to_s, {disallow, {type, ["Beast"]}}}]}, null,
											n, null, [null], null, [],
												null, [] ,null									
	},
	%*28 ����������� Subturn ��ͧ�ѹ�ͧ��� [S] At +2 ���� Subturn 
	{card_ability, 
		s3_earth_no028_a1, 796, 1,
			y, [{turn, df}, {pharse, checkup}],
				n, null, [],									
					y, [{zone, [arena_zone]}],											
						n, null, [null], null, [], null,
							n, [],
								n, null, [], null,
									n, null, null, [],	null,
										y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_subturn,											
											n, null, [null], null, [],
												null, [] ,null
	},
	%*29 [S] ¡��ԡ Curse
	{card_ability, 
		s3_earth_no029_a1, 797, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [],	null,												
										y, y, {do_not_need_select, 0, [{cancel_curse, [all]}]}, null,											
											n, null, [null], null, [],
												null, [], null									
	},
	%*30 ��з�� [S] ������Ѻ Seal ����� Mp ������¹��¡��� [S] [S] Df +2
	{card_ability, 
		s3_earth_no030_a1, 798, 1,
			n, [],
				n, null, [],									
					y, [{zone,[arena_zone]}, {action, fight}],											
						y, null, [arena_zone], n, [{action, fight}, {mpcast, less_than_s}], 1,
							n, [],
								n, null, [], null,
									n, null, null, [],	null,												
										y, y, {do_not_need_select, 0, [{df, 2}]}, end_of_fighting, 										
											n, null, [null], null, [],
												null, [] ,null					
	},
	%*31 [S] + At ����ӹǹ [S] �����ʹ��
	{card_ability, 
		s3_earth_no031_a1, 799, 1,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],							
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{at, {'+', {{target, null, [arena_zone], seal, n}, [{name, "Ground Tiger"}]}}}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	},
	%*31 [S]  ����ö���ըҡ Df Line ��
	{card_ability, 
		s3_earth_no031_a2, 799, 2,
				n, [],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],											
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,
										n, null, null, [], null,
											y, y, {do_not_need_select, 0, [{attack, from_df}]}, null,																			
												n, null, [null], null, [],
													null, [] ,null					
	},
	%*32 [Be] �����ʹ��������� Df +1
	{card_ability, 
		s3_earth_no032_a1, 800, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}],													
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,										
										n, null, [], null,
											y, owner, [arena_zone], n, [{card_type, seal}, {type, "Beast"}],
												y, {do_not_need_select, 0, [{df, 1}]}, null								
	},
	%*34 ��Һ��ҷ����µç������ Seal �ʹ���ҡ������� [S] Df +3
	{card_ability, 
		s3_earth_no034_a1, 802, 1,
			n,[],
				n, null, [],									
					y, [{action, on_arena}],											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,
									n, null, null, [], null,
										y, y, {do_not_need_select, 0, [{df, 3}]}, null,										
											n, null, [null], null, [],
												null, [] ,null
	}
].