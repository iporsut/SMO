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
-module(set2_light_continue).
-compile(export_all).

continue_condition() ->
	[
		%[S] +At ����ӹǹ Seal �ʹ�����µç����
		{
			continue_condition, 
				s2_light_no001_a1, 513, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [null], null, [], null,
									e, 
										[{active_zone, [arena_zone]}]
		},
		%[S] ¡��ԡ Curse 
		{
			continue_condition, 
				s2_light_no002_a1, 514, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		},
		%[S] +At ��� N[Penguin] �����ʹ��
		{
			continue_condition, 
				s2_light_no003_a2, 515, 2,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [null], null, [], null,
									e, 
										[{active_zone, [arena_zone]}]
		},
		%[S] ¡��ԡ Curse ��� Mystic Card
		{
			continue_condition, 
				s2_light_no004_a1, 516, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		},
		%[S] -Mp ������յ���ӹǹ Mystic Card ���ͽ��µç����
		{
			continue_condition, 
				s2_light_no005_a1, 517, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],	
								n, null, [], null, [], null,
									e, 
										[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ����µç�����ա��������ҡ������� [S] At +2 
		{
			continue_condition, 
				s2_light_no005_a2, 517, 2,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}, {hand_count, {owner, all, less}}],													
								n, null, [null], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		},
		%Seal ����� Sp ���¡��� [S] �������ö���� [S] ��
		{
			continue_condition, 
				s2_light_no006_a1, 518, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [null], n, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		},
		%[S] +At ����ӹǹ Seal ��������ҧ�ʹ�����µç����
		{
			continue_condition, 
				s2_light_no009_a1, 521, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [null], null, [], null,
									e, 
										[{active_zone, [arena_zone]}]
		},
		%[S] ¡��ԡ Curse ��� Mystic Card
		{
			continue_condition, 
				s2_light_no012_a1, 524, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		},
		%�������������ö��� [S] ������
		{
			continue_condition, 
				s2_light_no012_a2, 524, 2,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		},
		%[S] ¡��ԡ Steal
		{
			continue_condition, 
				s2_light_no013_a1, 525, 1,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}],													
								n, null, [], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		},
		%Growth: [Dragon�s Egg] ���� [Light] [S] ¡��ԡ Curse
		{
			continue_condition, 
				s2_light_no013_a2, 525, 2,
					n,[],
						n, null, [],									
							y, [{zone, [arena_zone]}, {growth, y}],													
								n, null, [], null, [], null,
									n, 
										[{active_zone, [arena_zone]}]
		}
	].