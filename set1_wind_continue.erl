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
-module(set1_wind_continue).
-compile(export_all).

continue_condition() ->
	[
		%[S] [S] ����ö���բ�����ѧ Df Line �� ��� Seal ���١ [S] ������ Sp ���¡��� [S]
		{
			continue_condition, 
			s1_wind_no61_a2, 317, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],											
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%�����蹷ء���������ö��˹� Line Seal ����� Df �ҡ���� [S] �������¹ Line �� (At Line)
		{
			continue_condition, 
			s1_wind_no65_a1, 321, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {line, 1}],													
							n, null, [null], n, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%[S] +Sp ����ӹǹ Mystic Card ���ͼ��Ǻ���
		{
			continue_condition, 
			s1_wind_no73_a1, 329, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								e,
								[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �����ҧ Seal �ء��ʹ��������� Sp = 4
		{
			continue_condition, 
			s1_wind_no74_a1, 330, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {combine, y}],													
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ������� [S] �����ʹ������� 2 㺢��� �����蹽��µç�����ء�����������٧�ش -1 (����� [S] ����� 2 㺢����ʹ��������� ���͡ Ability ���ӧҹ����§ 1 ���ҹ��)
		{
			continue_condition, 
			s1_wind_no75_a1, 331, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							y, owner, [arena_zone], y, [{card_type, seal}, {name, "Night Flower Fairy"}], 2,
								n,
								[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �� [Dragon] �� Seal ��ͧ�����ҧ [S] ����ö���բ�����ѧ Df Line ��
		{
			continue_condition, 
			s1_wind_no111_a1, 367, 1,
				n, [],
					n, null, [],									
						y, [{zone, [arena_zone]}, {combine, {type, "Dragon"}}],											
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		}	,
		%N[Charles] �ء��ʹ�� Sp +1
		{
			continue_condition,
			p1_wind_no118_a1, 374, 1,
				n, [],
					n, null, [],									
						y, [{zone, [arena_zone]}],
							n, null, [null], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		}
	].
