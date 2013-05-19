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
-module(set2_mystic_continue).
-compile(export_all).

% e_check ��Ѻ PS ����� Continuous ���դ����¡���� ���������� 
	% ���ͧ �ա�� ��Ǩ�ͺ Condition �ͧ������·�� Mystic ��� paste ��ʹ���� 
	% �� ��� seal ���Դ �� Dark  ��ͧ��Ǩ�ͺ ����ѧ���� Dark ������� ���� ���������� Dark ���� ��Ҿ�ѧ���������¹
	% e_check ��ͧ renew ��� ������� �������¹�ŧ���� ������¨� �� ��ҷ�� Mystic ���  Paste ��ҹ��
% ����� PS ������դ����¡��� ����ͧ���� Continuous
% e ��Ѻ Continuous ����ͧ check ��Ҿ�Ǵ���� �� ��� Check �ӹǹ �ͧ���� �� �. Zone ��

continue_condition() ->
	[
	%Seal �ء㺽��������Ѻ At �Ѻ Df (�ŷ������ At ����¹�ŧ�����¹�ŧ Df ��мŷ������ Df ����¹�ŧ�����¹�ŧ At)
		{continue_condition, 
			s2_no094_a1, 606, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}],													
							n, null, [null], null, [], null,
								n, 
									[{zone, [arena_zone]}]
		},
		%���͡ 1 ���ҧ
			%- ��� Seal ��� Crescent �Դ��� [Dark] Seal ��� At +2 
			%¡���: Seal ����� Lv 3 ���� ���/���� [Machine] 
		{continue_condition, 
			s2_no102_a1, 614, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{elem, 5}, {type, {n, "Machine"}}], 1}}],													
							n, null, [null], null, [], null,
								e_check, 
									[{zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
			%- ��� Seal ��� Crescent �Դ��� [Water] Seal ��� At +1, Mp -1 
			%¡���: Seal ����� Lv 3 ���� ���/���� [Machine] 
		{continue_condition, 
			s2_no102_a2, 614, 2,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{elem, 2}, {type, {n, "Machine"}}], 1}}],
							n, null, [null], null, [], null,
								e_check, 
									[{zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		},
		%Seal ��� [S] �Դ At +2
		{continue_condition, 
			s2_no104_a1, 616, 1,
				n,[],
					n, null, [],									
						y, [{zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}],
							n, null, [null], null, [], null,
								n, 
									[{zone, [arena_zone]}, {paste_on, {[{type, {n, "Machine"}}], 1}}]
		}
	].