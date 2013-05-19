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
-module(set3_dark).
-export([dark3_ability/0]).

dark3_ability() ->
	[
		%080 Nightmare Pegasus
		%[S] +At ��� Df ����ӹǹ Dark Dream Pegasus � Shrine (ok �١��ͧ)
		{card_ability,
			s3_dark_no080_a1, 848, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],													
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,
										n, null, null, [], null,													
											 y, y, {do_not_need_select, 0, [{at, {'+', {{target, null, [shrine_cards], seal, null}, [{name, "Dark Dream Pegasus"}]}}}, {df, {'+', {{target, null, [shrine_cards], seal, null}, [{name, "Dark Dream Pegasus"}]}}}]}, null,
												n, null, [null], null, [],
													null, [], null
		},
		%081 Perez, the Kobold Wizard 
		%��Һ��ҷ�� [S] �����ҧ [S] ����ö���բ�����ѧ Df Line �� (ok �١��ͧ)
		{card_ability, 
			s3_dark_no081_a1, 849, 1,
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
		%081 Perez, the Kobold Wizard 
		%����� [S] ������ Seal ��������Ѻ [S] �Դ Poison Curse 2 Turn (ok �١��ͧ)
		{card_ability, 
			s3_dark_no081_a2, 849, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, fight}],													
							y, null, [arena_zone], n, [{action, fight}, {protect_curse, {n, poison_curse}}, {curse, {n, poison_curse}}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, null, [], null,											
												y, null, [arena_zone], n, [{action, fight}, {protect_curse, {n, poison_curse}}, {curse, {n, poison_curse}}],
													y, {do_not_need_select, 0, [{curse, poison_curse}]}, 4									 
		},
		%082 Destiny Eater
		%����� [S] ���� �� Mystic Card 1 �� Shrine ���Ǻ��� �͡�ҡ�� (ok �١��ͧ)
		{card_ability, 
			s3_dark_no082_a2, 850, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, attacker}],													
							y, owner, [shrine_cards], null, [{card_type, mystic}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, null, [], null,											
												y, owner, [shrine_cards], null, [{card_type, mystic}],
													y, {owner_select_exact_target, 1, [{player_action, move_to_remove_zone}]}, null
		},
		%082 Destiny Eater
		%�������ö��� [S] �������Ҽ��Ǻ�������� Mystic Card � Shrine (ok �١��ͧ)
		{card_ability, 
			s3_dark_no082_a1, 850, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],													
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,
										n, null, null, [], null,												
											y, y, {do_not_need_select, 0, [{assign_atk, disallow}]}, null,
												n, null, [null], null, [],
													null, [] ,null									
		},
		%087 Ragdawn, Grace�s Beast
		%��Һ��ҷ���� Grace, the Valkyrie �����ʹ�� [S] ����ö���բ�����ѧ Df Line �� (ok �١��ͧ)
		{card_ability, 
			s3_dark_no087_a1, 855, 1,
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
		%088 Aramellon, the Dragon of the Tale
		%Growth: [Dragon] �ҵ� [Dark] + [Monster] [S] ����ö���� Seal ��ͧ�����ҧ� (ok �١��ͧ)
		{card_ability,
			s3_dark_no088_a1, 856, 1, 
				n,[],
					n, null, [],								
						y, [{growth, y}, {action, on_arena}],
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,
										n, null, null, [], null,							
											y, y, {do_not_need_select, 0, [{attack, to_supporter}]}, null,
												n, null, [null], null, [],
													null, [], null	
		},
		%089 Darkmist Unicorn	
		%��Һ��ҷ�� [S] ����� Shrine [Beast] �ء��ʹ��������� At +1 (����� [S] �ҡ���� 1 �� Shrine ��� ������͡ Ability ���ӧҹ����§ 1 ���ҹ��)  (ok �١��ͧ)
		{card_ability,
			s3_dark_no089_a1, 857, 1, 
				n,[],
					n, null, [],									
						y, [{zone, [shrine_cards]}, {action, in_shrine}],													
							n, null, [], null, [], null,							
								y, [],
									n, null, [], null,
										n, null, null, [], null,							
											n, null, [], null,
												y, owner, [arena_zone], null, [{type, "Beast"}],
													y, {do_not_need_select, 0, [{at, {'+', {1, {active_single_s, 1, owner}}}}]}, null
		},
		%090 Evil Centaur
		%����� [S] �� Shrine �ҡʹ�� ��ҵ�ͧ Sacrifice Seal 1 �
		{card_ability, 
			s3_dark_no090_a1, 858, 1, 
				n, [],
					n, null, [],									
						y, [{zone, [shrine_cards]}, {action, arena_to_shrine}, {action, into_shrine}], 											
							y, owner, [arena_zone], y, [{card_type, seal}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [], null,												
											n, null, [], null,						
												y, owner, [arena_zone], n, [{card_type, seal}],
													y, {owner_select_exact_target, 1, [{player_action, sacrifice}]}, null
		},
		% {card_ability, 
			% s3_dark_no090_a2, 858, 2, 
				% n, [],
					% n, null, [],									
						% y, [{zone, [shrine_cards]}, {action, arena_to_shrine}, {action, into_shrine}], 											
							% y, owner, [hand_cards], y, [{card_type, seal}], 1,
								% n, [],
									% n, null, [], null,
										% n, null, null, [], null,												
											% n, null, [], null,						
												% y, owner, [hand_cards], n, [{card_type, seal}],
													% y, {owner_can_select_exact_target, 1, [{action, discard}]}, null
		% },
		%091 Arachno
		%������������ Seal ��������� Sacrifice [S]  (ok �١��ͧ)
		{card_ability, 
			s3_dark_no091_a1, 859, 1, 
				n, [],
					n, null, [],									
						y, [{zone, [arena_zone]}],
							y, owner, [null], n, [{card_type, seal}, {action, on_arena}], 1,	
								n, [],
									n, null, [], null,
										n, null, null, [], null,												
											y, y, {do_not_need_select, 0, [{player_action, sacrifice}]}, 0,
												n, null, [null], null, [],
													null, [], null
		},
		%093 Zeabird	
		%����� [S] �� Shrine �ҡʹ�� �������ö�ʴ� [S] ���㺡���ҡ�ͧ������ǹӢ����� (���͡����� 1 �����)
		{card_ability, 
			s3_dark_no093_a1, 861, 1, 
				n, [],
					n, null, [],									
						y, [{zone, [shrine_cards]}, {action, arena_to_shrine}, {action, into_shrine}],
							y, owner, [seal_deck], n, [{name, "Zeabird"}], 1,	
								c, [],
									n, null, [], null,
										n, null, null, [], null,												
											 n, null, [], null,	
											 	y, owner, [seal_deck], n, [{name, "Zeabird"}],
													y, {owner_can_select_exact_target, {1, 4}, [{action, move_to_hand}]} , null	
		}		
	].
