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
-module(set3_wind).
-export([wind3_ability/0]).

wind3_ability() ->
	[
		%063 Sigmund 3rd, Knight of Swords
		%����� [S] ���� Seal ����� Sp ���¡��� [S] Seal ���١ [S] ���� Df �3 ���� Subturn (ok �١��ͧ)
		{card_ability, 
			s3_wind_no063_a1, 831, 1,
				n, [],
					n, null, [],									
						y, [{action, attacker}],											
							y, null, [arena_zone], n, [{action, attacked}, {speed, less_than_s}], 1,
								c, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, null, [], null,											
												y, null, [arena_zone], n, [{action, attacked}],													
													y, {do_not_need_select, 0, [{df, -3}]}, end_of_subturn									
		},
		%065 Red Claw Griffin 	
		%��Һ��ҷ�� [S] �����ҧ ����� N[Griffin], N[Pegasus] ���/���� N[Unicorn] �� Skill ������������ö���ǡ��� 1 � (At Line)(ok �١��ͧ)
		{card_ability, 
			s3_wind_no065_a1, 833, 1,
				n, [],
					n, null, [],									
						y, [{zone,[arena_zone]} ,{combine, y}, {line, 1}],
							y, null, [arena_zone, hand_cards, shrine_cards, seal_deck, remove_cards], n, [{naming_or , ["Griffin", "Pegasus", "Unicorn"]}, {action, use_skill_success}, {stack_check, using_skill}], 1,	
							 	n, [],
									y, y, {owner_can_activate_ability, 0, [{draw_card, 1}]}, null,
										n, null, null, [],	null,												
											n, null, [], null,											
												n, null, [null], null, [],
													null, [] ,null								
		},

		%067 Armored Guardian
		%Charging 2
		{card_ability, 
			s3_wind_no067_a1, 835, 1,
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
		%����� [S] �� Skill [S] At +1 / infinity Turn
		{card_ability, 
			s3_wind_no067_a2, 835, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, using_skill}],													
							n, null, [null], null, [], null,	
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											y, y, {do_not_need_select, 0, [{at, 1}]}, null,									
												n, null, [null], null, [],
													null, [] ,null											
		},
		%068   Thunderix 
		%��Һ��ҷ�� [S] �����ҧ [Beast] �������������ҧ�ء��ʹ��������� At +2 Df +2
		{card_ability, 
			s3_wind_no068_a1, 836, 1,
				n, [],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, on_arena}],											
							n, null, [], null, [], null,	
								y, [],
									n, null, [], null,
										n, null, null, [],	null,												
											n, null, [], null,											
												y, owner, [arena_zone], n, [{card_type, seal}, {type, "Beast"}, {combine, n}],
													y, {do_not_need_select, 0, [{at, 2}, {df, 2}, {ma, 1}, {skill, without_combine}]}, null								
		},
		%069 Metallic Unicorn
		%��Һ��ҷ�� [S] �����ҧ N[Unicorn] �����ʹ������ö�� Skill ��������ͧ�ç������͹䢡�������ҧ
		{card_ability, 
			s3_wind_no069_a1, 837, 1,
				n, [],
					n, null, [],									
						y, [{zone,[arena_zone]}, {action, on_arena}],											
							n, null, [], null, [], null,	
								y, [],
									n, null, [], null,
										n, null, null, [],	null,							
											n, null, [], null,												
												y, null, [arena_zone], n, [{card_type, seal}, {naming, "Unicorn"}, {protect_skill, n}],
													y, {do_not_need_select, 0, [{skill, without_combine}]}, null							
		},
		%071 Blue Wind Griffin 
		%��Һ��ҷ�� [S] �����ʹ�� [Beast] ���蹷ء��ʹ��������� Sp +1  (ok �١��ͧ)
		{card_ability, 
			s3_wind_no071_a1, 839, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],													
							n, null, [], null, [], null,							
								y, [],
									n, null, [], null,
										n, null, null, [],	null,							
											n, null, [], null,
												y, owner, [arena_zone], n, [{card_type, seal}, {type, "Beast"}],
													y, {do_not_need_select, 0, [{sp, 1}]}, null             
		},
		%072 Zephyr, Grace�s Beast 
		%��Һ��ҷ���� Grace, the Valkyrie �����ʹ�� [S] At +1 Sp +1  (ok �١��ͧ)
		{card_ability, 
			s3_wind_no072_a1, 840, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],													
							n, null, [], null, [], null,							
								y, [],
									n, null, [], null,
										n, null, null, [],	null,							
											y, y, {do_not_need_select, 0, [{at, 1}, {sp, 1}]}, null,											
												n, null, [null], null, [],													
													null, [], null	            
		},
		%074 Delta-D 
		%[S] ¡��ԡ Curse ��� Mystic Card   (ok �١��ͧ)
		{card_ability, 
			s3_wind_no074_a1, 842, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {action, on_arena}],													
							n, null, [], null, [], null,
								y, [],
									n, null, [], null,
										n, null, null, [], null,												
											y, y, {do_not_need_select, 0, [{cancel_curse, [all]}, {cancel_mystic, [all]}]}, null,											
												n, null, [null], null, [],
													null, [], null									
		},
		%075 Golden Unicorn
		%����� N[Unicorn] ������ʹ��������ҵ���� 2 㺢���� Subturn ��� ����ͨ� Subturn �������ö���ǡ��� 1 �  (ok �١��ͧ)
		{card_ability, 
			s3_wind_no075_a1, 843, 1,
				y, [{turn, at}, {pharse, eos}],
					n, null, [],								
						y, [{zone, [arena_zone]}],													
							y, owner, [arena_zone], y, [{naming, "Unicorn"}, {action, on_arena_success}], 2,
								n, [],
									y, y, {do_not_need_select, 0, [{draw_card, 1}]}, null,
										n, null, null, [], null,										
											n, null, [], null,											
												n, null, [null], null, [],													
													null, [], null										
		},
		%078 Sore Wing 
		%����� [S] ���� [S] Sp +1 ���͡�ҡ������չ��  (ok �١��ͧ)
		{card_ability,  
			s3_wind_no078_a1, 846, 1,
				n,[],
					n, null, [],									
						y, [{action, attacker}],													
							n, null, [null], null, [], null,
								n, [],
									n, null, [], null,
										n, null, null, [],	null,												
											 y, y, {do_not_need_select, 0, [{sp, 1}]}, end_of_fighting,											
											 	n, null, [null], null, [],													
													null, [], null									
		},
		%079 Red Bulge Rodent  
		%����ͨ� Subturn ���բͧ��� �������ö���� Mp 1 ��д١���㺺��ش 1 㺢ͧ�ͧ���촷ء�ͧ�ͧ���  (ok �١��ͧ)
		{card_ability, 
			s3_wind_no079_a1, 847, 1,
					y, [{turn, at}, {pharse, eos}],
						n, null, [],
							y, [{zone, [arena_zone]}],																
								y, owner, [seal_deck, mystic_deck], null, [], 1,
									n, [],
										n, null, [], null,
											n, null, null, [],	null,
												n, null, [], null,										
													y, owner, [seal_deck, mystic_deck], null, [],
														y, {owner_can_activate_ability, 0, [{action, {show, 1, [{card_type, all}], {owner_mp, -1}, []}}]}, null
		}
	].