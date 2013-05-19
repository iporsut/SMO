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
-module(mystic_ability_set3).
-export([ability/0]).

ability() ->
	[
		% 094. Phenomenon World
		%����� [S] �� Skill ����稤ú 3 ���� Sacrifice [S]
		{mystic_ability,
			s3_no094_a1, 862, 1, n,
				n, [],
						n, null, [], null, null, [], null,
							null,
								null,
									n, null, {}, [], null,
									n, null, null, {}, [], null, 										
									y, immediately, {do_not_need_select, 0}, [{move, sacrifice}], {use_skill, 3},
									n, null, [], null, null, [],
										null, {}, [], null,
									n, null, [], null, null, [],
										null, {}, [], null							
		},
		% 095   Ch'in Shih Huangdi
		% �����蹽��µç���� Mp �٧�ش -1 ��� ���������٧�ش +1
		{mystic_ability,
			s3_no095_a1, 863, 1, n,
				n, [],
					n, null, [], null, null, [], null,
						null,
							null,
								n, null, {}, [], null,
								y, opponent, immediately, {do_not_need_select, 0}, [{mp_max, -1}, {card_on_hand, 1}], depend_on_s,	
								n, null, {}, [], null,
								n, null, [], null, null, [],
									null, {}, [], nul,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		% 096   Atimazo Sword
		% Seal ��� [S] �Դ - At ����ӹǹ Seal �����Ǻ��� Seal ��鹤Ǻ������� [interfere]
		{mystic_ability,
			s3_no096_a1, 864, 1, y,
				n, [],
					y, null, [arena_zone], seal, null, [], 1,
						null,
							y,
								n, null, {}, [], null,
								n, null, null, {}, [], null,	
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [],
									continuous, {player_select_exact_target, 1}, [{at, {'-', paste_seal_controller_count}}], depend_on_s,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		% 097   Evader of the Hell
		% �� Seal 1 �� Shrine �ͧ������ 1 ���͡�ҡ�� [interfere]
		{mystic_ability,
			s3_no097_a1, 865, 1, y,
				n, [],
				y, null, [shrine_cards], seal, null, [], 1,
					null,
						null,
							n, null, {}, [], null,
							n, null, null, {}, [], null, 										
							n, null, {}, [], null,
							n, null, [], null, null, [],
								null, {}, [], null,
							y, null, [shrine_cards], seal, null, [],
								immediately, {player_select_exact_target, 1}, [{action, move_to_remove_zone}], null
		},
		% 098   Whirl to Win
		% Seal ��� [S] �Դ ��Ѻ At �Ѻ Df (�ŷ������ At ����¹�ŧ�����¹�ŧ Df ��мŷ������ Df ����¹�ŧ�����¹�ŧ At) [interfere]
		{mystic_ability,
			s3_no098_a1, 866, 1, y,
				n, [],
				y, null, [arena_zone], seal, null, [{action, {n, card_casting}}], 1,
					null,
						null,
							n, null, {}, [], null,
							n, null, null, {}, [], null, 										
							n, null, {}, [], null,
							y, null, [arena_zone], seal, null, [{action, {n, card_casting}}],
								immediately, {player_select_exact_target, 1}, [{swap_power, {attack, defend}}], depend_on_s,
							n, null, [], null, null, [],
								null, {}, [], null
		},
		%099   Andromeda
		% Seal ��� [S] �Դ�٭���� Skill ���/���� Ability [interfere]
		{mystic_ability,
			s3_no099_a1, 867, 1, y,
				n, [],
				y, null, [arena_zone], seal, null, [{action, {n, card_casting}}], 1,
					null,
						null,
							n, null, {}, [], null,
							n, null, null, {}, [], null, 										
							n, null, {}, [], null,
							y, null, [arena_zone], seal, null, [{action, {n, card_casting}}],
								immediately, {player_select_exact_target, 1}, [{ability, {loss, [all]}}, {skill, {loss, [all]}}], depend_on_s,
							n, null, [], null, null, [],
								null, {}, [], null
		},
		% 100   Pege Lagoon
		%1. ����� [Unicorn] ���/���� [Pegasus] ������ҵ� Shrine �ҡʹ�� �������ö�ʴ� [Unicorn] ���/���� [Pegasus] ����ժ������ǡѺ [Unicorn] ���/���� [Pegasus] ��� 1 㺨ҡ�ͧ���� Seal ��Ң����� �ҡ�����Ѻ�ͧ���촹�� 
		{mystic_ability,
			s3_no100_a1, 868, 1, n,
				n, [],
				n, null, [], null, null, [], null,
					null,
						y,
							n, null, {}, [], null,
							n, null, null, {}, [], null, 										
							%y, immediately, {do_not_need_select, 0}, [{action, sacrifice}], null,
							y, immediately, {do_not_need_select, 0}, [], null,
							n, null, [], null, null, [],
								null, {}, [], nul,
							n, null, [], null, null, [],
								null, {}, [], null
								
		},
		% 101  Benediction
		% �� Seal 1 �� Shrine ��Ң�����
		% ¡���: [Evil] ���/���� [Machine]
		{mystic_ability,
			s3_no101_a1, 869, 1, n,
				n, [],
				y, owner, [shrine_cards], seal, null, [{type_or, {n, ["Machine","Evil"]}}], 1,
					null,
						null,
							n, null, {}, [], null,
							n, null, null, {}, [], null, 										
							n, null, {}, [], null,
							n, null, [], null, null, [],
								null, {}, [], null,
							y, owner, [shrine_cards], seal, null, [{type_or, {n, ["Machine","Evil"]}}],
								immediately, {player_select_exact_target, 1}, [{action, move_to_hand}], null
		},
		% 102   Chaotic World
		% ���͡�ҵ� 1 �ҵ� �ҡ��� Seal ��� [S] �Դ����¹�繸ҵط�����͡ [interfere]
		% ¡���: [Divine]
		{mystic_ability,
			s3_no102_a1, 870, 1, y,
				n, [],
				y, null, [arena_zone], seal, null, [{type, {n, "Divine"}}], 1,
					null,
						y,
							n, null, {}, [], null,
							n, null, null, {}, [], null, 										
							n, null, {}, [], null,
							y, null, [arena_zone], seal, null, [{type, {n, "Divine"}}],
								immediately, {player_select_exact_target, 1}, [{elem, {select, 1}}], depend_on_s,
							n, null, [], null, null, [],
								null, {}, [], null
		},
		
		% 103   Holy Sun 
		% ���͡ 1 ���ҧ 
			% - ��� Seal ��� Holy Sun �Դ��� [Light] Seal ��� At + 2
			% - ��� Seal ��� Holy Sun �Դ��� [Fire] Seal ��� �Դ At + 2
			% - ��� Seal ��� Holy Sun �Դ��� [Divine] Seal ��� �Դ At + 2 
			% ¡���: Seal ����� Lv 3 ���� ���/���� [Machine]
		{mystic_ability,
			s3_no103_a1, 871, 1, n,
				n, [],
					y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}], 1,
						null,
							y,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}],
									immediately, {player_select_exact_target, 1}, [{check_condition, {[{elem, 6}], {at, 2}}}], depend_on_s,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		{mystic_ability,
			s3_no103_a2, 871, 2, n,
				n, [],
					y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}], 1,
						null,
							y,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}],
									immediately, {player_select_exact_target, 1}, [{check_condition, {[{elem, 4}], {at, 2}}}], depend_on_s,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		{mystic_ability,
			s3_no103_a3, 871, 3, n,
				n, [],
					y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}], 1,
						null,
							y,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}],
									immediately, {player_select_exact_target, 1}, [{check_condition, {[{type, "Divine"}], {at, 2}}}], depend_on_s,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		% 104   Light Tear Whip
		% ��Һ��ҷ������蹽��µç�����Ǻ��� Seal �ҡ������Ңͧ Seal ��� [S] �Դ Seal ��� [S] �Դ At +1 [interfere]
		{mystic_ability,
			s3_no104_a1, 872, 1, y,
				n, [],
					y, null, [arena_zone], seal, null, [], 1,
						null,
							y,
								n, null, {}, [], null,
								n, null, null, {}, [], null,	
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [],
									continuous, {player_select_exact_target, 1}, [{check_environment, {[{arena_count, {controller, seal, less}}], {at, 1}}}], depend_on_s,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		% 105   Houdini
		% Seal ��� [S] �Դ �Դ Stone Curse [interfere]
		{mystic_ability,
			s3_no105_a1, 873, 1, y,
				n, [],
					y, null, [arena_zone], seal, null, [{action, {n, card_casting}}, {protect_curse, {n, stone_curse}}, {curse, {n, stone_curse}}], 1,
						null,
							null,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [{action, {n, card_casting}}, {protect_curse, {n, stone_curse}}, {curse, {n, stone_curse}}],
									immediately, {player_select_exact_target, 1}, [{curse, stone_curse}], depend_on_s,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		% 106  Inquisition
		% ����� Mystic Card ���� 1 ��ʹ��  [interfere]
		{mystic_ability,
			s3_no106_a1, 874, 1, y,
				n, [],
					y, null, [arena_zone], mystic, n, [], 1,
						null,
							null,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								n, null, [], null, null, [],
									null, {}, [], null,
								y, null, [arena_zone], mystic, n, [],
									immediately, {player_select_exact_target, 1}, [{action, destroy}], null
		},
		% 107   Beauty & the Beast
		% ���͡ 1 ���ҧ
			% - ��� Seal ��� [S] �Դ��� [Monster] Seal ��� At +2
			% - ��� Seal ��� [S] �Դ��� [Beast] Seal ��� At +2 
			% - ��� Seal ��� [S] �Դ��� [Dragon] Seal ��� At +1 
			% ¡���: Seal ����� Lv 3 ���� ���/���� [Machine]
		{mystic_ability,
			s3_no107_a1, 875, 1, n,
				n, [],
					y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}], 1,
						null,
							y,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}],
									immediately, {player_select_exact_target, 1}, [{check_condition, {[{type, "Monster"}], {at, 2}}}], depend_on_s,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		{mystic_ability,
			s3_no107_a2, 875, 2, n,
				n, [],
					y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}], 1,
						null,
							y,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}],
									immediately, {player_select_exact_target, 1}, [{check_condition, {[{type, "Beast"}], {at, 2}}}], depend_on_s,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		{mystic_ability,
			s3_no107_a3, 875, 3, n,
				n, [],
					y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}], 1,
						null,
							y,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [{action, {n , card_casting}}, {type, {n, "Machine"}}, {level, "12"}],
									immediately, {player_select_exact_target, 1}, [{check_condition, {[{type, "Dragon"}], {at, 1}}}], depend_on_s,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		% 108   Curse Gauntlet
		% ����� Seal ��� [S] �Դ����� Subturn ��� Seal ��� [S] �Դ At -2 Df -2 ���� Subturn [interfere]
		{mystic_ability,
			s3_no108_a1, 876, 1, y,
				n, [],
					y, null, [arena_zone], seal, null, [{action, {n, card_casting}}], 1,
						null,
							null,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [{action, {n, card_casting}}],
									immediately, {player_select_exact_target, 1}, [{when_attack, {at, -2}}, {when_attack, {df, -2}}], end_of_subturn,
								n, null, [], null, null, [],
									null, {}, [], null						
		},
		% 109 Hercules (Redesign)
		%Seal ��� [S] �Դ At +2 
		{mystic_ability,
			s2_no109_a1, 877, 1, y,
				n, [],
					y, null, [arena_zone], seal, null, [{action, {n, card_casting}}, {level, "12"}, {type, {n, "Machine"}}], 1,
						null,
							null,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								y, null, [arena_zone], seal, null, [{action, {n, card_casting}}, {level, "12"}, {type, {n, "Machine"}}],
									immediately, {player_select_exact_target, 1}, [{at, 2}], depend_on_s,
								n, null, [], null, null, [],
									null, {}, [], null							
		},
		% 110 Holy Prayer (Redesign)
		%���͡ 1 ���ҧ 
			%- �ѡ�� Curse �ء��Դ���Ѻ Seal 1 � 
		{mystic_ability,
			s1_no110_a1, 878, 1, y,
				n, [],
					y, null, [arena_zone], seal, null, [{curse, y}], 1,
						null,
							null,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								n, null, [], null, null, [],
									null, {}, [], null,
								y, null, [arena_zone], seal, null, [{curse, y}],
									immediately, {player_select_exact_target, 1}, [{heal_curse, [all]}], null							
		},
			%- ����� Mystic Card ��Դ [PS] 1 ��ʹ��
		{mystic_ability,
			s1_no110_a2, 878, 2, y,
				n, [],
					y, null, [arena_zone], mystic, null, [{paste_type, 1}], 1,
						null,
							null,
								n, null, {}, [], null,
								n, null, null, {}, [], null, 										
								n, null, {}, [], null,
								n, null, [], null, null, [],
									null, {}, [], null,
								y, null, [arena_zone], mystic, null, [{paste_type, 1}],
									immediately, {player_select_exact_target, 1}, [{action, destroy}], null
		}
	].
