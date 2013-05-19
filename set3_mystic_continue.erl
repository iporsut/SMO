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
-module(set3_mystic_continue).
-export([continue_condition/0]).

% e_check ��Ѻ PS ����� Continuous ���դ����¡���� ���������� 
	% ���ͧ �ա�� ��Ǩ�ͺ Condition �ͧ������·�� Mystic ��� paste ��ʹ���� 
	% �� ��� seal ���Դ �� Dark  ��ͧ��Ǩ�ͺ ����ѧ���� Dark ������� ���� ���������� Dark ���� ��Ҿ�ѧ���������¹
	% e_check ��ͧ renew ��� ������� �������¹�ŧ���� ������¨� �� ��ҷ�� Mystic ���  Paste ��ҹ��
% ����� PS ������դ����¡��� ����ͧ���� Continuous
% e ��Ѻ Continuous ����ͧ check ��Ҿ�Ǵ���� �� ��� Check �ӹǹ �ͧ���� �� �. Zone ��

continue_condition() ->
	[
		% 096   Atimazo Sword
		% Seal ��� [S] �Դ - At ����ӹǹ Seal �����Ǻ��� Seal ��鹤Ǻ������� [interfere]
		{continue_condition, 
			s3_no096_a1, 864, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [], null, [], null,
								e, 
									[{zone, [arena_zone]}]
		},
		
		% % 100 Pege Lagoon
		% %2. �������� [Unicorn] ���/���� [Pegasus] �ʹ�� Sacrifice [S]
		% {continue_condition,
			% s3_no100_a1, 868, 1,
				% n,[],
					% n, null, [],									
						% y, [{zone, [arena_zone]}],											
							% y, null, [arena_zone], null, [{naming_or, ["Unicorn", "Pegasus"]}], {less_than, 1},
							% %y, null, [arena_zone], null, [], 1,
								% n,
								% [{zone, [arena_zone]}]
		% },
		
		% % 101  Benediction
		% % �� Seal 1 �� Shrine ��Ң�����
		% % ¡���: [Evil] ���/���� [Machine]
		% {continue_condition,
			% s3_no101_a1, 869, 1,
				% n,[],
					% n, null, [],									
						% y, [{zone, [arena_zone]}, {paste_on, {[{type, {n, "Evil"}}, {type, {n, "Machine"}}], 1}}],											
							% n, null, [null], null, [], null,
								% n,
								% [{active_zone, [arena_zone]}]
		% },
		% 102   Chaotic World
		% ���͡�ҵ� 1 �ҵ� �ҡ��� Seal ��� [S] �Դ����¹�繸ҵط�����͡ [interfere]
		% ¡���: [Divine]
		{continue_condition,
			s3_no102_a1, 870, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on,{[{type, {n, "Divine"}}], 1}}],											
							n, null, [], null, [], null,
								e_check,
								[{active_zone, [arena_zone]}]
		},
		% 103   Holy Sun 
		% ���͡ 1 ���ҧ 
			% - ��� Seal ��� Holy Sun �Դ��� [Light] Seal ��� At + 2
			% ¡���: Seal ����� Lv 3 ���� ���/���� [Machine
		{continue_condition, 
			s3_no103_a1, 871, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{elem, 6}, {type, {n, "Machine"}}], 1}}],											
							n, null, [], null, [], null,
								e_check,
								[{active_zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
			% - ��� Seal ��� Holy Sun �Դ��� [Fire] Seal ��� �Դ At + 2
			% ¡���: Seal ����� Lv 3 ���� ���/���� [Machine
		{continue_condition, 
			s3_no103_a2, 871, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{elem, 4}, {type, {n, "Machine"}}], 1}}],											
							n, null, [], null, [], null,
								e_check,
								[{active_zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
			% - ��� Seal ��� Holy Sun �Դ��� [Divine] Seal ��� �Դ At + 2 
			% ¡���: Seal ����� Lv 3 ���� ���/���� [Machine
		{continue_condition, 
			s3_no103_a3, 871, 3,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{type, "Divine"}, {type, {n, "Machine"}}], 1}}],											
							n, null, [], null, [], null,
								e_check,
								[{active_zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
		% 104   Light Tear Whip
		% ��Һ��ҷ������蹽��µç�����Ǻ��� Seal �ҡ������Ңͧ Seal ��� [S] �Դ Seal ��� [S] �Դ At +1 [interfere]
		{continue_condition, 
			s3_no104_a1, 872, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],											
							n, null, [], null, [], null,
								e_check,
								[{active_zone, [arena_zone]}]
		},
		% 107   Beauty & the Beast
		% ���͡ 1 ���ҧ
			% - ��� Seal ��� [S] �Դ��� [Monster] Seal ��� At +2
			% ¡���: Seal ����� Lv 3 ���� ���/���� [Machine]
			{continue_condition, 
			s3_no107_a1, 875, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{type, "Monster"}, {type, {n, "Machine"}}], 1}}],											
							n, null, [], null, [], null,
								e_check,
								[{active_zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
			% - ��� Seal ��� [S] �Դ��� [Beast] Seal ��� At +2 
			% ¡���: Seal ����� Lv 3 ���� ���/���� [Machine]
		{continue_condition, 
			s3_no107_a2, 875, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{type, "Beast"}, {type, {n, "Machine"}}], 1}}],											
							n, null, [], null, [], null,
								e_check,
								[{active_zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
			% - ��� Seal ��� [S] �Դ��� [Dragon] Seal ��� At +1 
			% ¡���: Seal ����� Lv 3 ���� ���/���� [Machine]
		{continue_condition, 
			s3_no107_a3, 875, 3,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{type, "Dragon"}, {type, {n, "Machine"}}], 1}}],											
							n, null, [], null, [], null,
								e_check,
								[{active_zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		}
	].


