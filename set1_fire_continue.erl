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
-module(set1_fire_continue).
-compile(export_all).

continue_condition() ->
	[
		%Seal ����� Mp ������¹��¡��� [S] �ء��ʹ�����µç���� At �1 Df �1
		{continue_condition, 
			s1_fire_no033_a2, 289, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],											
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%[S] ����ö���բ�����ѧ Df Line �� ��� Seal ���١ [S] ������ Sp �ҡ���� [S]
		{continue_condition, 
			s1_fire_no033_a1, 289, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],											
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �������� [S] -Mp ������µ���ӹǹ [Evil] � Shrine ���
		{continue_condition, 
			s1_fire_no038_a1, 294, 1,
				n,[],
					n, null, [],									
						y, [{zone, [hand_cards]}],											
							n, null, [null], null, [], null,
								e,
								[{active_zone, [hand_cards]}]
		},
		%��Һ��ҷ�� Seal �ʹ�����µç�����ҡ������� [S] At +3 
		{continue_condition, 
			s1_fire_no042_a1, 298, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {arena_count, {owner, seal, less}}],											
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� Seal �ʹ�����µç�������¡������ [S] At -3 
		{continue_condition, 
			s1_fire_no042_a2, 298, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {arena_count, {opponent, seal, less}}],											
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%[S] ����ö���ըҡ Df Line ��
		{continue_condition, 
			s1_fire_no044_a1, 300, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],											
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%��Һ��ҷ�� [S] �����ҧ [S] ����ö���բ�����ѧ Df Line �� (At Line)
		{continue_condition, 
			s1_fire_no044_a2, 300, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {combine, y}, {line, 1}],											
							n, null, [null], null, [], null,
								n,
								[{active_zone, [arena_zone]}]
		},
		%[S] +At ����ӹǹ [S] �����ʹ��
		{continue_condition, 
			s1_fire_no045_a1, 301, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],											
							n, null, [null], null, [], null,
								e,% environment_depend
								[{active_zone, [arena_zone]}]
		},
		%[S] ¡��ԡ Skill �ͧ [Wind] ��� Death Curse
		{continue_condition, 
			s1_fire_no120_a2, 376, 2,
					n,[],
						n, null, [],									
							y, [{zone,[arena_zone]}],					
								n, null, [null], null, [], null,
									n,
									[{active_zone, [arena_zone]}]
		}
	].
