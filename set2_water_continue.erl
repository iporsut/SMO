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
-module(set2_water_continue).
-compile(export_all).

continue_condition() ->
	[
	%�������������ö��� Seal �������������ҧ���� [S] ��
		{continue_condition, 
			s2_water_no52_a1, 564, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},
	%[Dragon] �ҵ� [Water] �ء��ʹ�� Mp ����� Skill -1(����� [S] ����� 2 㺢����ʹ�����͡��� Ability ���ӧҹ����§ 1 ���ҹ��)
		{continue_condition, 
			s2_water_no54_a1, 566, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},
	%�������������ö��� [S] ������
		{continue_condition, 
			s2_water_no54_a2, 566, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},				
	%[S] ����ö���բ�����ѧ Df Line �� ��� Seal ���١ [S] ������ Df ���¡��� [S]
		{continue_condition, 
			s2_water_no55_a1, 567, 1,			
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},
	%Seal �ء㺷������� Df Line ��ͧ�ѹ������� (All) ��� Skill (All) (At Line)
		{continue_condition, 
			s2_water_no56_a1, 568, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {line, 1}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},
	%[S] ¡��ԡ Skill �ͧ [Insect]
		{continue_condition, 
			s2_water_no61_a2, 573, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		}
	].