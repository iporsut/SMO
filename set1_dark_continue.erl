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
-module(set1_dark_continue).
-compile(export_all).

continue_condition() ->
	[
		%[S] ����ö���բ�����ѧ Df Line �� ��� Seal ���١ [S] ������ Sp �ҡ���� [S]
		{continue_condition, 
		s1_dark_no76_a1, 332, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}],													
						n, null, [null], null, [], null,
							n,
							[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] ����� Shrine �������ö�� [S] ������ʹ���ҡ Shrine �� 
		{continue_condition, 
		s1_dark_no80_a2, 336, 2,
			n,[],
				n, null, [],									
					y, [{zone, [shrine_cards]}],													
						n, null, [null], null, [], null,
							n,
							[{active_zone, [shrine_cards]}]
		},
		%[S] ����ö���բ�����ѧ Df Line �� 
		{continue_condition, 
		s1_dark_no82_a1, 338, 1,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}],													
						n, null, [null], null, [], null,
							n,
							[{active_zone, [arena_zone]}]
		},
		%���Ǻ��� [S] �������ö��˹� Line ��� [S] ������ Df Line �� 
		{continue_condition, 
		s1_dark_no82_a2, 338, 2,
			n,[],
				n, null, [],									
					y, [{zone, [arena_zone]}],													
						n, null, [null], null, [], null,
							n,
							[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �Դ Mystic Card ������ [Tarot]: The Moon [S] At +2
		{continue_condition, 
		s1_dark_no87_a1, 343, 1,
			n, [],
				n, null, [],									
					y, [{zone, [arena_zone]}, {paste, {[{mystic_type, 1}, {mystic_subtype, "The Moon"}], 1}}],													
						n, null, [null], null, [], null,
							n,
							[{active_zone, [arena_zone]}]
		}
	].
