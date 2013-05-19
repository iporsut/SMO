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
-module(set3_water_continue).
-compile(export_all).

continue_condition() ->
	[	
		%[Beast] �ء�������� Mp ������� -1 (Ability �������ӧҹ����� [S] ����� 2 㺢����ʹ��)
		{continue_condition, 
			s3_water_no050_a1, 818, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							y, null, [arena_zone], y, [{card_type, seal}, {name, "Albino Gryphon"}], {less_than, 2},
								n,
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �����ʹ�� N[Pegasus] �ء����ͽ������ Mp ����� Skill -1 (Ability �������ӧҹ����� [S] ����� 2 㺢����ʹ��)
		{continue_condition, 
			s3_water_no055_a1, 823, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							y, null, [arena_zone], y, [{card_type, seal}, {name, "Blue Sky Pegasus"}], {less_than, 2},
								n,
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ���� [Earth] �����ʹ�� ���Ǻ��� [S] ����ö��� [S] ���մ��� Df ��
		{continue_condition, 
			s3_water_no058_a1, 826, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							y, null, [arena_zone], n, [{elem, 1}], 1,
								n,
									[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ���� [S] ����� 2 㺢����ʹ��������� Seal �ء��ʹ�����µç���� Sp = 0 
		{continue_condition, 
			s3_water_no059_a1, 827, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							y, owner, [arena_zone], y, [{card_type, seal}, {name, "Coy Crab"}], 2,
								n,
									[{active_zone, [arena_zone]}]
		}
	].
