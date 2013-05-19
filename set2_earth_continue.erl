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
-module(set2_earth_continue).
-compile(export_all).

continue_condition() ->
	[
		%[S] ¡��ԡ Freeze Curse
		{continue_condition,
			s2_earth_no19_a1, 531, 1, 
				n, [],
					n, null, [],									
						y,[{zone, [arena_zone]}], 											
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},				
		%��Һ��ҷ���� Seal �ʹ�����µç�������¡������ �������������ö��� Seal ���� [S] ��
		{continue_condition,
			s2_earth_no21_a1, 533, 1, 
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {arena_count, {opponent, seal, less}}],											
							n, null, [null], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		},
		%�������������ö��� [S] ������
		{continue_condition,
			s2_earth_no21_a2, 533, 2, 
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,							
								n, 
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� Angorion, the Earth Spirit �����ʹ�� [Earth] �ء��ʹ��������� Df +1
		{continue_condition,
			s2_earth_no22_a1, 534, 1, 
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							y, null, [arena_zone], null, [{card_type, seal}, {name, "Angorion, the Earth Spirit"}], 1,
								n, 
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �����ʹ�� Angorion, the Earth Spirit �ء��ʹ�� At +1 Sp +1 Mp ����� Skill �1 (Effect ����ѧ���觼������� [S] ����� Shrine)
		{continue_condition,
			s2_earth_no22_a2a, 534, 2, 
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] ����� Shrine Angorion, the Earth Spirit �ء��ʹ�� At +1 Sp +1 Mp ����� Skill �1 (Effect ����ѧ���觼������� [S] ����� Shrine)
		{continue_condition,
			s2_earth_no22_a2b, 534, 2, 
				n,[],
					n, null, [],									
						y, [{zone, [shrine_cards]}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [shrine_cards]}]
		},
		%Growth: [Dragon] �ҵ� [Earth] + [Monster] [S] At +1 Df +1 Sp -1
		{continue_condition,
			s2_earth_no24_a4, 536, 4, 
				n,[],
					n, null, [],									
						y, [{growth, y}],													
							n, null, [], n, [], null,
								n, 
									[{growth, y}]
		},
		%[S] ����ö���ըҡ Df Line ��
		{continue_condition,
			s2_earth_no25_a1, 537, 1, 
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},
		%Growth: [Dragon's Egg] [S] ����ö���ըҡ Df Line ��
		{continue_condition,
			s2_earth_no26_a3, 538, 3, 
				n,[],
					n, null, [],									
						y, [{growth, y}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},
		%Growth: [Dragon's Egg]%[S] ����ö���բ�����ѧ Df Line ��
		{continue_condition,
			s2_earth_no26_a4, 538, 4, 
				n,[],
					n, null, [],									
						y, [{growth, y}],													
							n, null, [null], null, [], null,
								n, 
									[{growth, y}]
		},
		%[S] ����ö���ըҡ Df Line ��
		{continue_condition,
			s2_earth_n28_a2, 540, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],												
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},
		%[S] ����ö���ըҡ Df Line ��
		{continue_condition,
			s2_earth_no29_a2, 541, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],												
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		}
	].