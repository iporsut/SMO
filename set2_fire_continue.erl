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
-module(set2_fire_continue).
-compile(export_all).

continue_condition() ->
	[
		%[S] +At ����ӹǹ Seal �������� At Line �������
		{continue_condition,
			s2_fire_no31_a1, 543, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],											
								n, null, [null], null, [], null,
									e, 
										[{active_zone, [arena_zone]}]
		},
		%[S] -At ����ӹǹ Seal �������� At Line ���µç����
		{continue_condition,
			s2_fire_no31_a2, 543, 2,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],											
								n, null, [null], null, [], null,
									e,
										[{active_zone, [arena_zone]}]
		},								
		%��Һ��ҷ�� [S] �����ҧ�Ѻ [Dragon] [S] ����ö���բ�����ѧ Df Line ��
		{continue_condition,
			s2_fire_no33_a1, 545, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}, {combine, {type, "Dragon"}}],													
								n, null, [null], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		},		
		%[Fire] �ء��ʹ��������� At +1 Df -3 (Df Line)
		{continue_condition,
			s2_fire_no34_a1, 546, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}, {line, 0}],													
								n, null, [null], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		},
		{continue_condition,
			s2_fire_no35_a2, 547, 2,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [null], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		},
		{continue_condition,
			s2_fire_no38_a1, 550, 1,
					n,[],
						n, null, [],									
							y, [{growth, y}],													
								n, null, [null], null, [], null,
									n, 
										[{growth, y}]
		},
		%��Һ��ҷ���� [Fire] � Shrine ��� [S] At +1
		%{continue_condition,
		%	s2_fire_no39_a1, 551, 2, 
		%		n, [],
		%			n, null, [],									
		%				y,[{zone, [arena_zone]}], 											
		%					y, owner, [shrine_cards], n, [{elem, 4}], 1,
		%						n, 
		%							[{active_zone, [arena_zone]}]
		%},
		%��Һ��ҷ���� [Fire] � Shrine ��� [S] At +1
		{continue_condition,
			s2_fire_no39_a1, 551, 1, 
				n, [],
					n, null, [],									
						y,[{zone, [arena_zone]}], 											
							y, owner, [shrine_cards], n, [{elem, 4}], 1,
								n, 
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ���� [Knight] � Shrine ��� [S] At +2
		{continue_condition,
			s2_fire_no39_a2, 551, 2, 
				n, [],
					n, null, [],									
						y,[{zone, [arena_zone]}], 											
							y, owner, [shrine_cards], n, [{type, "Knight"}], 1,
								n, 
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ���� [Dragon] ����� 3 㺢����ʹ��������� [S] At +2
		{continue_condition,
			s2_fire_no40_a1, 552, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								y, owner, [arena_zone], y, [{type, "Dragon"}], 3,
									n, 
										[{active_zone, [arena_zone]}]
		},
		%Growth: [Dragon's Egg] �����蹽��µç�����������ö��� Seal ���բ�����ѧ Df Line �� (At line)
		{continue_condition,
			s2_fire_no42_a3, 554, 3,
					n,[],
						n, null, [],									
							y, [{growth, y}, {line, 1}],													
								n, null, [null], null, [], null,
									n, 
										[{growth, y}]
		},
		%[S] +At ����ӹǹ [S] ����� Shrine ���
		{continue_condition,
			s2_fire_no45_a1, 557, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [null], null, [], null,
									e, 
										[{active_zone, [arena_zone]}]
		},
		%�������������ö��� [S] ������
		{continue_condition,
			s2_fire_no46_a2, 558, 2,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [null], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		}
	].