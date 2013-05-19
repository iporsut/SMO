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
-module(set1_light).
-export([light1_ability/0]).

light1_ability() ->
[
	%����� [S] �����ʹ�� �ú 3 Turn �� [S] ��ҡͧ����
	{card_ability, 
		s1_light_no001_a1, 257, 1,
					n, [],
						n, null, [],									
							y, [{zone,[arena_zone]}, {action, on_arena}],											
								n, null, [null], null, [], null,
			                  n, [],
										n, null, [], null,
											n, null, null, [],	null,										
						                  y, y, {do_not_need_select, 0, [{move, to_deck}]}, 6, 
													n, null, [null], null, [],
														null, [] ,null
	},
	%[S] ¡��ԡ Curse �ͧ�����蹷ء��
	{card_ability, 
		s1_light_no001_a2, 257, 2,
					n, [],
						n, null, [],									
							y,[{zone, [arena_zone]}, {action, on_arena}], 											
								n, null, [null], null, [], null,
			                  y, [],
										n, null, [], null,                       
											n, null, null, [],	null,												
						                  y, y,{do_not_need_select, 0, [{cancel_curse, [all]}]}, null,											
													n, null, [null], null, [],
														null, [] ,null					
	},
	%[S] ¡��ԡ Mystic �ͧ���µç����
	{card_ability, 
		s1_light_no001_a3, 257, 3,
					n, [],
						n, null, [],									
							y,[{zone, [arena_zone]}, {action, on_arena}],				
								n, null, [null], null, [], null,
			                  y, [],
										n, null, [], null,                       
											n, null, null, [],	null,												
						                  y, y, {do_not_need_select, 0, [{cancel_mystic, [all_opponent]}]}, null,											
													n, null, [null], null, [],
														null, [] ,null					
	},
	%��� [S] ������Ѻ [Dark] [S] At +2  
	{card_ability, 
		s1_light_no002_a1, 258, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}, {action, fight}, {elem, {n, 5}}],											
								y, null, [arena_zone], n, [{action, fight}, {elem, 5}], 1,
			                  n, [],
										n, null, [], null,                        
											n, null, null, [], null,												
						                  y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting,											
													n, null, [null], null, [],
														null, [] ,null					
	},
	%[S] ¡��ԡ Skill ��� Ability �ͧ [Dark]
	{card_ability, 
		s1_light_no002_a2, 258, 2,
				n,[],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, on_arena}],
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,                        
										n, null, null, [], null,												
											y, y, {do_not_need_select, 0, [{cancel_skill, [{elem, 5}]}, {cancel_ability, [{elem, 5}]}]}, null,											
												n, null, [null], null, [],
														null, [] ,null					
	},
	%Seal �ء��ʹ���������¡��ԡ Mystic Card (At Line)
	{card_ability, 
		s1_light_no003_a1, 259, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,                        
										n, null, null, [], null,												
											n, null, [], null,											
												y, owner, [arena_zone], y, [{card_type, seal}],
													y, {do_not_need_select, 0, [{cancel_mystic, [all]}]}, null					
	},
	%��Һ��ҷ�� [S]  �����ҧ ����� [S] ��������� ���Ǻ��� [S] Mp +2
	{card_ability,  
		s1_light_no006_a1, 262, 1,
				n,[],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, attack_success}, {combine, y}],											
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,                        
										y, y, controller, {do_not_need_select, 0, [{mp, 2}]}, null,												
											n, null, [], null,											
												n, null, [null], null, [],
													null, [] ,null					
	},
	%��Һ��ҷ���� [Wind] �ʹ�� [S] Sp +1
	{card_ability, 
		s1_light_no007_a1, 263, 1,
				n,[],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, on_arena}],											
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,                        
										n, null, null, [], null,												
											y, y, {do_not_need_select, 0, [{sp, 1}]}, null,											
												n, null, [null], null, [],
													null, [] ,null					
	},
	%��Һ��ҷ���� [Water] �ʹ�� [S] Mp -1
	{card_ability, 
		s1_light_no007_a2, 263, 2,
				n,[],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, on_arena}],																					
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,                        
										n, null, null, [], null,												
											y, y, {do_not_need_select, 0, [{ma, -1}, {mc, -1}, {ms, -1}]}, null,
												n, null, [null], null, [],
													null, [] ,null					
	},
	%��Һ��ҷ�� [S] �� N[Unicorn] �� Seal ��ͧ�����ҧ [S] ����ö�� Skill �ͧ Seal ��ͧ�����ҧ�����������ͧ�ç������͹䢡�������ҧ
	{card_ability, 
		s1_light_no009_a1, 265, 1,
			n, [],
				n, null, [],
					y, [{zone, [arena_zone]}, {action, on_arena}], 		
						n, null, [null], null, [], null,
							y, [],
								n, null, [], null,                        
									n, null, null, [], null,										
										y, y, {do_not_need_select, 0, [{skill, use_supporter_skill}]}, null, 
											n, null, [null], null, [],
													null, [] ,null
	},
	%��Һ��ҷ���� [Wind] �����ʹ��������� [S] Sp +1
	{card_ability, 
		s1_light_no011_a1, 267, 1,
				n,[],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, on_arena}],																					
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,                        
										n, null, null, [], null,												
											y, y, {do_not_need_select, 0, [{sp, 1}]}, null,											
												n, null, [null], null, [],
													null, [] ,null					
	},
	%��Һ��ҷ���� [Water] �����ʹ��������� [S] Mp ������� -1
	{card_ability, 
		s1_light_no011_a2, 267, 2,
				n,[],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, on_arena}],																					
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,                        
										n, null, null, [], null,												
											y, y, {do_not_need_select, 0, [{ma, -1}]}, null,											
												n, null, [null], null, [],
													null, [] ,null					
	},
	%��Һ��ҷ�� [S] �����ҧ ��з�� [S] ������Ѻ [Dark] [S] At +2
	{card_ability, 
			s1_light_no012_a1, 268, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}, {action, fight}, {combine, y}],											
								y, null, [arena_zone], n, [{action, fight}, {elem, 5}], 1,
			                  n, [],
										n, null, [], null,                        
											n, null, null, [], null,												
						                  y, y, {do_not_need_select, 0, [{at, 2}]}, end_of_fighting,											
													n, null, [null], null, [],
														null, [] ,null					
	},
	%[S] ��ͧ�ѹ������� (All)
	{card_ability,
		s1_light_no014_a1, 270, 1,
				n,[],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, on_arena}],											
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,                        
										n, null, null, [], null,												
											y, y, {do_not_need_select, 0, [{protect_attack, [attack_all]}]}, null,											
												n, null, [null], null, [],
													null, [] ,null					
	},
	%����� [S] ������ʹ����������Ҩҡ������� �������ö�١��촷ء����ͼ����蹽��µç�����ء��
	{card_ability,  
		s1_light_no015_a1, 271, 1,
				n,[],
					n, null, [],									
						y, [{action, move_to_arena}],											
							n, null, [null], null, [], null,
								c, [],
									y, y,{owner_can_activate_ability, 0, [{player_action, {show_opponent_card, all}}]}, null,                        
										n, null, null, [], null,												
											n, null,[], null,											
												n, null, [null], null, [],
													null, [] ,null					
	},
	%��з�� [S] ������Ѻ Seal �����������ҧ [S] At +1
	{card_ability, 
		p1_light_no119_a1, 375, 1,
			n, [],
				n, null, [],									
					y, [{action, fight}],
						y, uncontrol, [arena_zone], n, [{combine, n}, {action, fight}], 1,
							n, [],
								n, null, [], null,
									n, null, null, [], null,										
										y, y, {do_not_need_select, 1, [{at, 1}, {sp, 1}]}, end_of_fighting,
											n, null, [null], null, [],
												n, [], null
	}
].

