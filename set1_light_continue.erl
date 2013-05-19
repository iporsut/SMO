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
-module(set1_light_continue).
-compile(export_all).

continue_condition() ->
	[
		%����� [S] �����ʹ�� �ú 3 Turn �� [S] ��ҡͧ����
		% {continue_condition,
			% s1_light_no001_a1, 257, 1,
					% n, [],
						% n, null, [],									
							% y, [{zone,[arena_zone]}], 											
								% n, null, [null], null, [], null,
									% n,
									% [{active_zone, [arena_zone]}]
		% },
		%[S] ¡��ԡ Curse �ͧ�����蹷ء��
		{continue_condition,
			s1_light_no001_a2, 257, 2,
					n, [],
						n, null, [],																		
							y,[{zone, [arena_zone]}],
								n, null, [null], null, [], null,
									n,
									[{active_zone, [arena_zone]}]
		},
		%[S] ¡��ԡ Mystic �ͧ���µç����
		{continue_condition,
			s1_light_no001_a3, 257, 3,
					n, [],
						n, null, [],									
							y,[{zone, [arena_zone]}],				
								n, null, [null], null, [], null,
									n,
									[{active_zone, [arena_zone]}]
		},
		%[S] ¡��ԡ Skill ��� Ability �ͧ [Dark]
		{continue_condition,
			s1_light_no002_a2, 258, 2,
				n,[],
					n, null, [],									
						y, [{zone,[arena_zone]}, {elem, {n, 5}}],
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%Seal �ء��ʹ���������¡��ԡ Mystic Card (At Line)
		{continue_condition,
			s1_light_no003_a1, 259, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {line,1}],
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ���� [Wind] �ʹ�� [S] Sp +1
		{continue_condition,
			s1_light_no007_a1, 263, 1,
				n,[],
					n, null, [],																	
						y, [{zone,[arena_zone]}],
							y, null, [arena_zone], y, [{elem, 3}], 1,
								n,
								[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ���� [Water] �ʹ�� [S] Mp -1
		{continue_condition,
			s1_light_no007_a2, 263, 2,
				n,[],
					n, null, [],																		
						y, [{zone,[arena_zone]}],											
							y, null, [arena_zone], y, [{elem, 2}], 1,
								n,
								[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �� N[Unicorn] �� Seal ��ͧ�����ҧ [S] ����ö�� Skill �ͧ Seal ��ͧ�����ҧ�����������ͧ�ç������͹䢡�������ҧ
		{continue_condition,
			s1_light_no009_a1, 265, 1,
			n, [],
				n, null, [],																		
					y, [{zone, [arena_zone]}, {combine, {naming, "Unicorn"}}], 											
						n, null, [null], null, [], null,
							n,
							[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ���� [Wind] �����ʹ��������� [S] Sp +1
		{continue_condition,
			s1_light_no011_a1, 267, 1,
				n,[],
					n, null, [],																				
						y, [{zone,[arena_zone]}],											
							y, owner, [arena_zone], y, [{elem, 3}], 1,
								n,
								[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ���� [Water] �����ʹ��������� [S] Mp ������� -1
		{continue_condition,
			s1_light_no011_a2, 267, 2,
				n,[],
					n, null, [],																				
						y, [{zone,[arena_zone]}],											
							y, owner, [arena_zone], y, [{elem, 2}], 1,
								n,
								[{active_zone, [arena_zone]}]
		},
		%[S] ��ͧ�ѹ������� (All)
		{continue_condition,
			s1_light_no014_a1, 270, 1,
				n,[],
					n, null, [],																				
						y, [{zone,[arena_zone]}],
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		}
	].
