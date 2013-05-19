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
-module(set3_water).
-export([water3_ability/0]).

water3_ability() ->
	[	
		%049 Silk Fur Unicorn 	
		%����ͼ��Ǻ��� ���� [Unicorn] ����� ����ö�� [Unicorn] 1 �������ʹ���ҡ��ͼ��Ǻ��� �ҡ��� [Unicorn] ��������ҹ�鹡����� Inactive Seal (ok, ��������)
		{card_ability, 
			s3_water_no049_a1, 817, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {{controller, [hand_cards], seal, n}, {[{naming, "Unicorn"}], 1}}],													
							y, controller, [arena_zone], y, [{naming, "Unicorn"}, {action, cast_success}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,		
												y, controller, [hand_cards], n, [{naming, "Unicorn"}],
													y, {controller_can_select_exact_target, 1, [{action, move_to_arena_inactive}]}, null									 
		},
		%050 Albino Gryphon 
		%[Beast] �ء�������� Mp ������� -1 (Ability �������ӧҹ����� [S] ����� 2 㺢����ʹ��)
		%(ok, ��������)
		{card_ability, 
			s3_water_no050_a1, 818, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],													
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,											
												y, owner, [hand_cards], y, [{card_type, seal}, {type,"Beast"}],
													y, {do_not_need_select, 0, [{mc, -1}]}, null										 
		},
		%051 Phoaviros
		%����� [S] �� Shrine �ҡ��� Seal 1 ��ʹ���� Sp ��������ҡ�˹� 1 Turn (ok, ��������)
		{card_ability, 
			s3_water_no051_a1, 819, 1,
				n,[],
					n, null, [],									
						y, [{zone, [shrine_cards]}, {action, hand_to_shrine}, {action, into_shrine}],													
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,                        
										n, null, null, [],	null,												
											n, n, [], null,											
												y, null, [arena_zone], n, [{card_type, seal}],
													y, {owner_select_exact_target, 1, [{power_change, {equal, {value, sp}}}]}, null									 
		},
		%052 Frimas Castor
		%����� [S] ������ʹ�� Seal 1 㺡����� Inactive Seal 㹵� Subturn ���յ��仢ͧ���Ǻ��� Seal ��� (ok, ��������)
		{card_ability, 
			s3_water_no052_a1, 820, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, into_arena}],													
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,											
												y, null, [arena_zone], n, [{card_type, seal}],												
													y, {owner_select_exact_target, 1, [{{check_up_step, 0}, {action, inactive_seal}}]}, null									 
		},
		%053 Ketos
		%��Һ��ҷ�� [S] �����ҧ ��� Seal ������Ң����ͨҡʹ��� Subturn ��� ����ͨ� Subturn �������ö�� [Monster] 1 �������ʹ���ҡ������ (At Line) (ok, ��������)
		{card_ability, 
			s3_water_no053_a1, 821, 1,
				n,[],
					n, null, [],								
						y, [{zone, [arena_zone]}, {combine, y}, {line, 1}, {check_flag, {n, seal_return_to_hand}}],
							y, owner, [hand_cards], n, [{card_type, seal}, {action, arena_to_hand}, {action, moving_to_hand}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {do_not_need_select, 0, [{add_flag, seal_return_to_hand}]}, null,											
												n, null, [null], null, [],													
													null, [], null
		},
		{card_ability, 
			s3_water_no053_a2, 821, 2,
				y, [{turn, at}, {pharse, eos}],
					n, null, [],								
						y, [{zone, [arena_zone]}, {combine, y}, {line, 1}, {check_flag, seal_return_to_hand}],
							y, owner, [hand_cards], n, [{card_type, seal}, {type, "Monster"}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,	
												y, owner, [hand_cards], n, [{card_type, seal}, {type, "Monster"}],
		 											y, {owner_can_select_exact_target, 1, [{action, move_to_arena}]}, null										 
		},
		{card_ability, 
			s3_water_no053_a3, 821, 3,
				y, [{turn, df}, {pharse, checkup}],
					n, null, [],								
						y, [{zone, [arena_zone]}, {check_flag, seal_return_to_hand}],
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {do_not_need_select, 0, [{clear_flag, seal_return_to_hand}]}, null,											
												n, null, [null], null, [],													
													null, [], null
		},
		{card_ability, 
			s3_water_no053_a4, 821, 4,
				y, [{turn, df}, {pharse, eos}],
					n, null, [],	
						y, [{zone, [arena_zone]}, {combine, y}, {line, 1}, {check_flag, seal_return_to_hand}],
							y, owner, [hand_cards], n, [{card_type, seal}, {type, "Monster"}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,	
												y, owner, [hand_cards], n, [{card_type, seal}, {type, "Monster"}],
		 											y, {owner_can_select_exact_target, 1, [{action, move_to_arena}]}, null										 
		},
		{card_ability, 
			s3_water_no053_a5, 821, 5,
				y, [{turn, at}, {pharse, checkup}],
					n, null, [],								
						y, [{zone, [arena_zone]}, {check_flag, seal_return_to_hand}],
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {do_not_need_select, 0, [{clear_flag, seal_return_to_hand}]}, null,											
												n, null, [null], null, [],													
													null, [], null
		},
		%055 Blue Sky Pegasus 
		%��Һ��ҷ�� [S] �����ʹ�� N[Pegasus] �ء����ͽ������ Mp ����� Skill -1 (Ability �������ӧҹ����� [S] ����� 2 㺢����ʹ��)
		{card_ability, 
			s3_water_no055_a1, 823, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],	
							n, null, [null], null, [], null,
								y, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,											
											 	y, owner, [hand_cards], n, [{card_type, seal}, {naming, "Pegasus"}],
													y, {do_not_need_select, 0, [{ms, -1}]}, null	
		},
		%056 Butterfly Stingray	
		%������ա��촵� Shrine ���µç���� �������ö��� Seal 1 ���� Mystic Card 1 �������� �ҡ��鹹� Mystic Card 1 �� Shrine ��ҡͧ���� (ok, ��������)
		{card_ability, 
			s3_water_no056_a1a, 824, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {{owner, [shrine_cards], mystic, n}, {[], 1}}, {{owner, [hand_cards], mystic, n}, {[], 1}}],
							y, opponent, [shrine_cards], n, [{action, into_shrine}, {action, arena_to_shrine}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,											
												y, owner, [hand_cards], n, [{card_type, seal}],
													y, {owner_can_select_exact_target, 1, [{action, discard}]}, null	
		},
		{card_ability, 
			s3_water_no056_a1b, 824, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {{owner, [shrine_cards], mystic, n}, {[], 1}}, {{owner, [hand_cards], seal, n}, {[], 1}}],	
							y, opponent, [shrine_cards], n, [{action, into_shrine}, {action, arena_to_shrine}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,											
												y, owner, [hand_cards], n, [{card_type, mystic}],
													y, {owner_select_exact_target, 1, [{action, discard}]}, null	
		},
		{card_ability, 
			s3_water_no056_a1c, 824, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {{owner, [shrine_cards], mystic, n}, {[], 1}}, {{owner, [hand_cards], seal, n}, {[], 1}}, {{owner, [hand_cards], mystic, n}, {[], 1}}],	
							y, opponent, [shrine_cards], n, [{action, into_shrine}, {action, arena_to_shrine}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,											
												y, owner, [shrine_cards], n, [{card_type, mystic}],
													y, {owner_select_exact_target, 1, [{action, move_to_deck}]}, null	
		},
		%057 Herapoht
		%����� [S] ������ ���Ǻ�������ö Sacrifice [Water] ���/���� [Divine] 1 � �ҡ��� Seal 1 ��ʹ���Դ Freeze Curse 1 Turn
		{card_ability, 
			s3_water_no057_a1a, 825, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, fight}],
							y, owner, [arena_zone], y, [{elem_or_type, [2, "Divine"]}], 1,
								{then_do, s3_water_no057_a1b}, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,											
												y, owner, [arena_zone], y, [{elem_or_type, [2, "Divine"]}],
													y, {owner_can_select_exact_target, 1, [{player_action, sacrifice}]}, null	
		},
		{card_ability, 
			s3_water_no057_a1b, 825, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, fight}],
							y, null, [arena_zone], y, [{card_type, seal}, {curse, {n, freeze_curse}}, {protect_curse, {n, freeze_curse}}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,											
											n, n, [], null,											
												y, null, [arena_zone], y, [{card_type, seal}, {curse, {n, freeze_curse}}, {protect_curse, {n, freeze_curse}}],
													y, {owner_select_exact_target, 1, [{curse, freeze_curse}]}, 2														
		},
		%����� [S] ������ ���Ǻ�������ö Sacrifice [Dark] ���/���� [Evil] 1 � �ҡ��� Seal 1 ��ʹ���Դ Poison Curse 1 Turn
		% {card_ability, 
			% s3_water_no057_a2a, 825, 2,
				% n,[],
					% n, null, [],									
						% y, [{zone, [arena_zone]}, {action, fight}],	
							% y, owner, [arena_zone], n, [{elem_or_type, [5, "Evil"]}], 1,
								% {then_do, s3_water_no057_a2b}, [],
									% n, null, [], null,
										% n, null, null, [],	null,												
											% n, n, [], null,											
												% y, owner, [arena_zone], n, [{elem_or_type, [5, "Evil"]}],
													% y, {owner_can_select_exact_target, 1, [{player_action, sacrifice}]}, null	
		% },
		% {card_ability, 
			% s3_water_no057_a2b, 825, 2,
				% n,[],
					% n, null, [],									
						% y, [{zone, [arena_zone]}],	
							% y, null, [arena_zone], y, [{card_type, seal}, {curse, {n, poison_curse}}, {protect_curse, {n, poison_curse}}], 1,
								% n, [],
									% n, null, [], null,
										% n, null, null, [],	null,												
											% n, n, [], null,											
												% y, null, [arena_zone], y, [{card_type, seal}, {curse, {n, poison_curse}}, {protect_curse, {n, poison_curse}}],
													% y, {owner_select_exact_target, 1, [{curse, poison_curse}]}, 2
			%},
		%058 Cat Crab
		%��Һ��ҷ���� [Earth] �����ʹ�� ���Ǻ��� [S] ����ö��� [S] ���մ��� Df �� (ok, ��������)
		{card_ability, 
			s3_water_no058_a1, 826, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, attacker}],	
							y, null, [arena_zone], n, [{elem, 1}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,
											y, y, {owner_can_activate_ability, 0, [{combat, {when_fight_attack, {df, power}}}]}, end_of_fighting,											
												n, null, [null], null, [],													
													null, [], null
		},
		%059 Coy Crab 
		%��Һ��ҷ���� [S] ����� 2 㺢����ʹ��������� Seal �ء��ʹ�����µç���� Sp = 0  (ok ��������)
		{card_ability, 
			s3_water_no059_a1, 827, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],	
							n, null, [null], null, [], null,
							%y, owner, [arena_zone], y, [{card_type, seal}, {name, "Coy Crab"}], 2,
								y, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, null, [], null,											
												y, opponent, [arena_zone], n, [{card_type, seal}],													
													y, {do_not_need_select, 0, [{sp, {equal, 0}}]}, null	
		},
		%061 Sharp Horn Goat	
		%����� [S] ������ʹ���ҡ��� �����蹷ء�����͡ Seal 1 ��ʹ�� Seal ����������ö�� Skill �� 2 Turn (ok ��������)
		{card_ability, 
			s3_water_no061_a1a, 829, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, into_arena}],	
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,											
												y, null, [arena_zone], y, [{card_type, seal}],
													y, {owner_select_exact_target, 1, [{skill, {cannot_use, [all]}}]}, 4	
		},
		{card_ability, 
			s3_water_no061_a1b, 829, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, into_arena}],	
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,		
												y, null, [arena_zone], y, [{card_type, seal}],	
													y, {opponent_select_exact_target, 1, [{skill, {cannot_use, [all]}}]}, 4	
		},
		%062 Aqua Otter
		%����� [Monster] ���/���� [Water] �����ͨҡʹ��������� �������ö�� [S] ������ʹ���ҡ��� ( ok ��������)
		{card_ability, 
			s3_water_no062_a1, 830, 1,
				n,[],
					n, null, [],								
						y, [{zone, [hand_cards]}],													
							y, owner, [hand_cards], n, [{elem_or_type, [2, "Monster"]}, {action, arena_to_hand}], 1,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, n, [], null,											
												y, owner, [hand_cards], y, [{name, "Aqua Otter"}],
													y, {owner_can_select_exact_target, 1, [{action, move_to_arena}]}, null										 
		}	
].