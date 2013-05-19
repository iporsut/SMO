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
-module(set1_earth).
-export([earth1_ability/0]).

earth1_ability() ->
[	
	%[S] +At ����ӹǹ Seal ���Դ Curse �ʹ��
	{card_ability, 
		s1_earth_no019_a1, 275, 1,
			n, [],
				n, null, [],									
					y, [{zone, [arena_zone]}, {action, on_arena}], 											
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null, 
									n, null, null, [],	null,										
										y, y, {do_not_need_select, 0,[{at,{'+', {{target, null, [arena_zone], seal, y}, [{curse, y}]}}}]}, null, 
											n, null, [null], null, [],
												null, [] ,null				
	},
	%��з�� [S] ������Ѻ Seal ����� Sp ���¡��� [S] [S] At +2
	{card_ability, 
		s1_earth_no019_a2, 275, 2,
				n, [],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, fight}],											
							y, null, [arena_zone], n, [{action, fight}, {speed, less_than_s}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting, 										
												n, null, [null], null, [],
													null, [] ,null					
	},
	%��з�� [S] ������Ѻ Seal ����� Sp 1, 2, 3 [S] At +2 Df +1
	{card_ability, 
		s1_earth_no021_a1, 277, 1,
				n, [],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, fight}],											
							y, null, [arena_zone], n, [{action, fight}, {speed, "123"}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											y, y, {do_not_need_select, 0, [{at, 2}, {df, 1}]}, end_of_fighting,											
												n, null, [null], null, [],
													null, [] ,null
	},
	%��Һ��ҷ�� [S] ������ At Line ����ö���բ�����ѧ Seal ���µç������������ Df Line
	{card_ability, 
		s1_earth_no022_a1, 278, 1,
				n, [],
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
	%��Һ��ҷ�� [S] ������ Df Line ����ö���ըҡ Df ��
	{card_ability, 
		s1_earth_no022_a2, 278, 2,
				n, [],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],											
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {do_not_need_select, 0, [{attack, from_df}]}, null,																			
												n, null, [null], null, [],
													null, [] ,null
	},
	%����� [S] ��������� [S] At +2 Df +2 / 1 Turn
	{card_ability, 
		s1_earth_no023_a1, 279, 1,
				n, [],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, attack_success}], 																
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {do_not_need_select, 0, [{at, 2}, {df, 2}]}, 2,											
												n, null, [null], null, [],
													null, [] ,null
	},
	%����� [S] ���������� Subturn ��� ����ͨ� Subturn ���բͧ���Ǻ��� [S] �� [S] 价�� Df Line
	{card_ability, 
		s1_earth_no024_a1, 280, 1,
				n, [],
					y, controller, [{turn, at}, {pharse, eos}],									
						y, [{zone, [arena_zone]}, {action, attack_successful}, {line, null}], 																
							n, null, [null], null, [], null,							
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {do_not_need_select, 0, [{action, to_df_line}]}, null,											
												n, null, [null], null, [],
													null, [] ,null
	},
	%����� [S] ��������� [S] �Դ Stone Curse 3 Subturn 
	{card_ability, 
		s1_earth_no025_a1, 281, 1,
				n, [],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, attack_success}, {protect_curse, {n, stone_curse}}, {curse, {n, stone_curse}}], 
							n, null, [null], null, [], null,							
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {do_not_need_select, 0, [{curse, stone_curse}]}, 3,											
												n, null, [null], null, [],
													null, [] ,null
	},
	%����������� Subturn ��ͧ�ѹ�ͧ��� [S]  At +1 ���� Subturn
	{card_ability, 
		s1_earth_no026_a1, 282, 1,
				y, [{turn, df}, {pharse, checkup}],
					n, null, [],									
						y, [{zone, [arena_zone]}],											
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {do_not_need_select, 0, [{at, 1}]}, end_of_subturn,											
												n, null, [null], null, [],
													null, [] ,null
	},
	%����� Seal ���µç������ Skill [S] At +1 / 1 Turn
	{card_ability, 
		s1_earth_no027_a1, 283, 1,
				n, [],
					n, null, [],
						y, [{zone, [arena_zone]}],											
							y, opponent, [null], null, [{action, using_skill}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {do_not_need_select, 0, [{at, 1}]}, 2,											
												n, null, [null], null, [],
													null, [] ,null
	},
	%����������� Subturn ��ͧ�ѹ�ͧ��� [Earth] ���蹷ء㺽������ Df +1 ���� Subturn 
	{card_ability, 
		s1_earth_no028_a1, 284, 1,
				y, [{turn, df}, {pharse, checkup}],
					n, null, [],									
						y, [{zone, [arena_zone]}],
							y, owner, [arena_zone], n, [{elem, 1}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											n, null,[], null,											
												y, owner, [arena_zone], n, [{elem, 1}],
													y, {do_not_need_select, 0, [{df, 1}]}, end_of_subturn					
	},
	%����ͨ� Subturn ���բͧ��� �� [S] 价�� Df Line (At Line)
	{card_ability, 
		s1_earth_no030_a1a, 286, 1,
				y, [{turn, at}, {pharse, eos}],
					n, null, [],
						y, [{zone, [arena_zone]}, {line, 1}],																
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {do_not_need_select, 0, [{action, to_df_line}]}, null,									
												n, null, [null], null, [],
													null, [] ,null
	},
	%[S] ����ö���ըҡ Df Line ��
	{card_ability, 
		s1_earth_no109_a1, 365, 1,
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
	%����� [S] ������Ѻ [Water] [S] At +1 Df +1 / 1 Turn
	{card_ability, 
		s1_earth_no109_a2, 365, 2,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}, {action, fight}],											
								y, null, [arena_zone], n, [{action, fight}, {elem, 2}], 1,
			                  n, [],
										n, null, [], null,                        
											n, null, null, [], null,												
						                  y, y, {do_not_need_select, 0, [{at, 1}, {df, 1}]}, 2,											
													n, null, [null], null, [],
														null, [] ,null					
	},
	%����������� Subturn ��ͧ�ѹ�ͧ��� ���͡ [Earth] ���� 1 ��ʹ��������� Seal ��� Mp ������� +1 ���� Subturn
	{card_ability, 
		p1_earth_no112_a1, 368, 1,
			y, [{turn, df}, {pharse, checkup}],
				n, null, [],									
					y, [{zone,[arena_zone]}], 											
						y, owner, [arena_zone], n, [{elem, 1}], 1,
							c, [],
							%n, [],
								n, null, [], null,
									n, null, null, [],	null,										
										n, null, [], null, 
											y, owner, [arena_zone], n, [{elem, 1}],
												y, {owner_select_exact_target, 1, [{mc, 1}]}, 1									
	},
	%����� [S] �١���� ���Ǻ�������ö��º Df �ͧ [S] �Ѻ��Ҿ�ѧ�ͧ Seal ��������騹�͡�ҡ������չ��
	{card_ability, 
		p1_earth_no112_a2, 368, 2,
			n, [],
				n, null, [],									
					y, [{line, 1}, {action, attacked}], 											
						n, null, [null], null, [], null,
							n, [],
								n, null, [], null,
									n, null, null, [], null,										
										y, y, {controller_can_activate_ability, 1, [{action, can_compare_df_to_attacker_power}]}, null, 
											n, null, [null], null, [],
												n, [], null
	},
	%����� [S] �١���� [S] At +2 Df +1 Sp +1 ���͡�ҡ������չ��
	{card_ability, 
		s1_earth_no123_a1, 379, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}, {action, attacked}],											
								n, null, [null], null, [], null,
			                  n, [],
										n, null, [], null,                        
											n, null, null, [], null,												
						                  y, y, {do_not_need_select, 0, [{at, 2}, {df, 1}, {sp, 1}]}, end_of_fighting,											
													n, null, [null], null, [],
														null, [] ,null					
	}
].