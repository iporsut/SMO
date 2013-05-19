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
-module(set3_dark_continue).
-compile(export_all).

continue_condition() ->
	[
		%[S] +At ����ӹǹ Dark Dream Pegasus � Shrine
		{continue_condition, 
			s3_dark_no080_a1, 848, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								e, 
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �����ҧ [S] ����ö���բ�����ѧ Df Line �� (At Line)
		{continue_condition, 
			s3_dark_no081_a1, 849, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {combine, y}, {line, 1}],											
							n, null, [null], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		},
		%�������ö��� [S] �������Ҽ��Ǻ�������� Mystic Card � Shrine
		{continue_condition, 
			s3_dark_no082_a1, 850, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],											
							y, controller, [shrine_cards], null, [{card_type, mystic}], {equal_to, 0},
								n,
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ���� Grace, the Valkyrie �����ʹ�� [S] ����ö���բ�����ѧ Df Line �� 
		{continue_condition, 
			s3_dark_no087_a1, 855, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],											
							y, null, [arena_zone], null, [{card_type, seal}, {name, "Grace, the Valkyrie"}], 1,
								n,
									[{active_zone, [arena_zone]}]
		},
		%Growth: [Dragon] �ҵ� [Dark] + [Monster] ��Һ��ҷ�� [S] �����ҧ [S] ����ö���� Seal ��ͧ�����ҧ��
		% {continue_condition, 
			% s3_dark_no088_a1, 856, 1, 
				% n,[],
					% n, null, [],									
						% y, [{zone, [arena_zone]}, {combine, y}],											
							% n, null, [null], null, [], null,
								% n,
									% [{active_zone, [arena_zone]}]
		% },
		%��Һ��ҷ�� [S] ����� Shrine [Beast] �ء��ʹ��������� At +1
		%(����� [S] �ҡ���� 1 �� Shrine ��� ������͡ Ability ���ӧҹ����§ 1 ���ҹ��)	
		{continue_condition,
			s3_dark_no089_a1, 857, 1, 
				n,[],
					n, null, [],									
						y, [{zone, [shrine_cards]}],													
							n, null, [], null, [], null,
								n, 
									[{zone, [shrine_cards]}]
		}	
	].
