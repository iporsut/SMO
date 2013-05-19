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
-module(set3_wind_continue).
-compile(export_all).

continue_condition() ->
	[
		%��Һ��ҷ�� [S] �����ҧ [Beast] �������������ҧ�ء��ʹ��������� At +2 Df +2
		{continue_condition, 
			s3_wind_no068_a1, 836, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {combine, y}],													
							n, null, [null], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �����ҧ N[Unicorn] �����ʹ������ö�� Skill ��������ͧ�ç������͹䢡�������ҧ
		{continue_condition, 
			s3_wind_no069_a1, 837, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {combine, y}],													
							n, null, [null], null, [], null,
								n,
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �����ʹ�� [Beast] ���蹷ء��ʹ��������� Sp +1 
		{continue_condition,
			s3_wind_no071_a1, 839, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		},		
		%��Һ��ҷ���� Grace, the Valkyrie �����ʹ�� [S] At +1 Sp +1 
		{continue_condition,
			s3_wind_no072_a1, 840, 1,
				n,[],
					n, null, [],																	
						y, [{zone,[arena_zone]}],
							y, null, [arena_zone], y, [{card_type, seal}, {name, "Grace, the Valkyrie"}], 1,
								n,
									[{active_zone, [arena_zone]}]
		},
		%[S] ¡��ԡ Curse ��� Mystic Card
		{continue_condition, 
			s3_wind_no074_a1, 842, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [], null, [], null,
								n, 
									[{active_zone, [arena_zone]}]
		}
	].
