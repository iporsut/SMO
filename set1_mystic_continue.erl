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
-module(set1_mystic_continue).
-compile(export_all).

% e_check ��Ѻ PS ����� Continuous ���դ����¡���� ���������� 
	% ���ͧ �ա�� ��Ǩ�ͺ Condition �ͧ������·�� Mystic ��� paste ��ʹ���� 
	% �� ��� seal ���Դ �� Dark  ��ͧ��Ǩ�ͺ ����ѧ���� Dark ������� ���� ���������� Dark ���� ��Ҿ�ѧ���������¹
	% e_check ��ͧ renew ��� ������� �������¹�ŧ���� ������¨� �� ��ҷ�� Mystic ���  Paste ��ҹ��
% ����� PS ������դ����¡��� ����ͧ���� Continuous
% e ��Ѻ Continuous ����ͧ check ��Ҿ�Ǵ���� �� ��� Check �ӹǹ �ͧ���� �� �. Zone ��

continue_condition() ->
	[
	%Seal ��� [S] �Դ �Դ Charm Curse ¡���: Seal ����� Lv 3 ����, [Light] ���/���� [Machine]
		{continue_condition, 
			s1_no093_a1, 349, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{elem, {n, 6}}, {type, {n, "Machine"}}], 1}}],													
							n, null, [null], null, [], null,
								n, 
									[{zone, [arena_zone]}, {paste_on, {[{elem, {n, 6}}, {type, {n, "Machine"}}], 1}}]
		},
	%Seal ��� [S] �Դ����ö���������� 2 �����¨��� Mp ���������§��������  ¡���: Seal ����� Lv 4 ���� ���/���� [Machine]
		{continue_condition,
			s1_no099_a1, 355, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}],													
							n, null, [null], null, [], null,
								n, 
									[{zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
	%���͡ 1 ���ҧ
		%- ��� Seal ��� [S] �Դ��� [Knight] Seal ��� At +2
		%¡���: Seal ����� Lv 3 ���� ���/���� [Machine]
		{continue_condition,
			s1_no103_a1, 359, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{type, "Knight"}, {type, {n, "Machine"}}], 1}}],													
							n, null, [null], null, [], null,
								e_check, 
									[{zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
		%- ��� Seal ��� [S] �Դ��� [Wind] Seal ��� At +2 Sp +1 
		%¡���: Seal ����� Lv 3 ���� ���/���� [Machine]
		{continue_condition,
			s1_no103_a2, 359, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{elem, 3}, {type, {n, "Machine"}}], 1}}],													
							n, null, [null], null, [], null,
								e_check, 
									[{zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
		%���͡ 1 ���ҧ
			%- ��� Seal ��� [S] �Դ��� [Mage] Seal ��� At +2 
			%¡���: Seal ����� Lv 3 ���� ���/���� [Machine]
		{continue_condition,
			s1_no104_a1, 360, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{type, "Mage"}, {type, {n, "Machine"}}], 1}}],													
							n, null, [null], null, [], null,
								e_check, 
									[{zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
			%- ��� Seal ��� [S] �Դ��� [Earth] Seal ��� At +2 Df +1 
			%¡���: Seal ����� Lv 3 ���� ���/���� [Machine]
		{continue_condition,
			s1_no104_a2, 360, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{elem, 1}, {type, {n, "Machine"}}], 1}}],													
							n, null, [null], null, [], null,
								e_check, 
									[{zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		}
		% %Seal �ء㺷������� At Line ��ͧ�ѹ�������
		% {continue_condition, 
			% p1_no125_a1, 381, 1,
				% n,[],
					% n, null, [],									
						% y, [{zone, [arena_zone]}],													
							% n, null, [null], null, [], null,
								% n, 
									% [{zone, [arena_zone]}]
		% }
	].
