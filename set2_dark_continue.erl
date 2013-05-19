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
-module(set2_dark_continue).
-compile(export_all).

continue_condition() ->	
	[
	%��Һ��ҷ�� [S] �Դ Stone Curse [S] At +2 Df +2 
		{continue_condition, 
			s2_dark_no079_a1, 591, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {curse, stone_curse}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},
	%��Һ��ҷ�� [S] �Դ Freeze Curse [S] Df +2 
		{continue_condition, 
			s2_dark_no079_a2, 591, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {curse, freeze_curse}],													
							n, null, [null], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		},
	%��Һ��ҷ�� [S] �Դ Charm Curse [S] At +2
		{continue_condition, 
			s2_dark_no079_a3, 591, 3,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {curse, charm_curse}],													
							n, null, [null], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		},
	%��Һ��ҷ�� [S] �Դ Poison Curse [S] At +3 
		{continue_condition, 
			s2_dark_no079_a4, 591, 4,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {curse, poison_curse}],													
							n, null, [null], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		},
	%��Һ��ҷ�� [S] �Դ Last Dance Curse [S] At +2 
		{continue_condition, 
			s2_dark_no079_a5, 591, 4,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {curse, last_dance_curse}],													
							n, null, [null], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		},
	%[S] ����ö���� Seal ��ͧ�����ҧ�� 
		{continue_condition, 
			s2_dark_no083_a1, 595, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		},
	%�������������ö��� [S] ������
		{continue_condition, 
			s2_dark_no091_a2, 603, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		}
	].