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
-module(lib_tournament).
-compile(export_all).
-export ([compatitor_name_status/3]).

reject_action(SPlayer, Reason) ->
	RejectReason =
	case Reason of
		no_valid_tournament -> 0;
		inadequate_fee_requirement -> 1;
		inadequate_rank_requirement -> 10;
		no_room -> 11;
		too_late -> 12;
		no_compatitor_info -> 2;
		no_user_scoreline -> 3;
		cannot_found_next_match_info -> 4;
		no_tournament_information -> 5;
		you_late_game_is_over -> 6;
		cannot_found_game_info -> 7;
		cannot_found_match_schedule -> 8;
		too_early -> 9;
		your_compatitor_late -> 10;
		you_are_not_yet_ready_game_is_over -> 11;
		_ -> 99
	end,
	gen_server:cast(SPlayer, {send, [16#ff, 16#aa, RejectReason]}).
	
reject_register(SPlayer, Reject) ->
	SendReject = 
	case Reject of
		inadequate_fee_requirement -> 2;
		inadequate_rank_requirement -> 3;
		register_close -> 4;
		no_room -> 5;
		ban_user -> 6;
		overlap_period -> 7;
		cancel_success -> 8;
		cannot_cancel_register -> 9;
		unsuccess_register -> 10
	end,
	gen_server:cast(SPlayer, {send, [16#81, 16#a0, SendReject]}).
%------------------------------------------------------------------
% ��ǹ��õ�Ǩ�ͺ Tournament ���Դ�Ѻ��Ѥ���� User ����ѧ�������Ѥ�
request_valid_tournament(SPlayer) ->
	LoginName = lib_lobby_protocol:get_user_data_pid(SPlayer, [user_id]),
	SQLCommand = "CALL smno.sp_league_open(" ++ integer_to_list(0) ++", '"++ LoginName ++"');",
	QueryResult = lib_database:get_query(SQLCommand),
	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
	case QueryResult of
		[{selected, _, [{0}]}, _] -> gen_server:cast(SPlayer, {send, [16#81, 16#a6, 0]});
		[{selected, _, ValidTRM}, _] ->	transform_valid(SPlayer, ValidTRM);
		_ -> reject_action(SPlayer, no_valid_tournament)
	end.
%------------------------------------------------------------------
% ��ǹ��õ�Ǩ�ͺ Tournament ���Դ�Ѻ��Ѥ���� User �����Ѥ������
request_registered_tournament(SPlayer) ->
	LoginName = lib_lobby_protocol:get_user_data_pid(SPlayer, [user_id]),
	SQLCommand = "CALL smno.sp_league_open(" ++ integer_to_list(1) ++", '"++ LoginName ++"');",
	QueryResult = lib_database:get_query(SQLCommand),
	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
	case QueryResult of
		[{selected, _, []}, _] -> gen_server:cast(SPlayer, {send, [16#81, 16#a7, 0]});
		[{selected, _, ValidTRM}, _] ->	transform_registed(SPlayer, ValidTRM);
		_ -> reject_action(SPlayer, no_valid_tournament)
	end.
%------------------------------------------------------------------
transform_to_binary([]) -> [];
transform_to_binary([{STRMID}|ValidTRM]) ->
	TRMID = list_to_integer(STRMID),
	[<<TRMID:16>>] ++ transform_to_binary(ValidTRM);
transform_to_binary([{STRMID, Status}|ValidTRM]) ->
	TRMID = list_to_integer(STRMID),
	[<<TRMID:16>>, Status] ++ transform_to_binary(ValidTRM).
	
% ��ǹ��� Register ������������ Tournament
transform_valid(SPlayer, ValidTRM) ->
	DataSize = length(ValidTRM),
	TRM = transform_to_binary(ValidTRM),
	io:format("TRM ~p~n", [TRM]),
	gen_server:cast(SPlayer, {send, [16#81, 16#a6, DataSize] ++ TRM}).
	
transform_registed(SPlayer, ValidTRM) ->
	DataSize = length(ValidTRM),
	TRM = transform_to_binary(ValidTRM),
	io:format("TRM ~p~n", [TRM]),
	gen_server:cast(SPlayer, {send, [16#81, 16#a7, DataSize] ++ TRM}).
%------------------------------------------------------------------
cancel_tournament_register(SPlayer, TnmID) ->
	io:format("TournamentID is ~p~n", [TnmID]),
	<<TID:16>> = list_to_binary(TnmID),
	LoginName = lib_lobby_protocol:get_user_data_pid(SPlayer, [user_id]),
	SQLCommand = "CALL smno.sp_league_register (" ++ integer_to_list(0) ++ ","++integer_to_list(TID)++ ",'" ++ LoginName ++ "');",
	QueryResult = lib_database:get_query(SQLCommand),
	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
	case QueryResult of
		[{selected, _, [{1}]}, _] -> gen_server:cast(SPlayer, {send, [16#81, 16#a8, 1]});
		_ -> gen_server:cast(SPlayer, {send, [16#81, 16#a8, 0]})
	end.

request_register(SPlayer, TnmID) ->
	io:format("TournamentID is ~p~n", [TnmID]),
	<<TID:16>> = list_to_binary(TnmID),
	LoginName = lib_lobby_protocol:get_user_data_pid(SPlayer, [user_id]),
	smo_logger:fmsg("~p ~n", [LoginName]),
	SQLCommand = "CALL smno.sp_league_chk_requirement ("++integer_to_list(TID)++ ",'" ++ LoginName ++ "');",
	QueryResult = lib_database:get_query(SQLCommand),
	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
	case QueryResult of
		[{selected, _, [{1}]}, _] -> register_success(SPlayer, TID, LoginName);
		[{selected, _, [{2}]}, _] -> reject_register(SPlayer, inadequate_fee_requirement);
		[{selected, _, [{3}]}, _] -> reject_register(SPlayer, inadequate_rank_requirement);
		[{selected, _, [{4}]}, _] -> reject_register(SPlayer, register_close);
		[{selected, _, [{5}]}, _] -> reject_register(SPlayer, no_room);
		[{selected, _, [{6}]}, _] -> reject_register(SPlayer, ban_user);
		[{selected, _, [{7}]}, _] -> reject_register(SPlayer, overlap_period);
		_ -> reject_action(SPlayer, other)
	end.
% -----------------------------------------------------------------
request_match_player_information(SPlayer, TnmID) ->
	io:format("TournamentID is ~p~n", [TnmID]),
	[A, B|_] = TnmID,
	<<TID:16>> = list_to_binary([A, B]),
	LoginName = lib_lobby_protocol:get_user_data_pid(SPlayer, [user_id]),
	case compatitor_name_status(SPlayer, LoginName, TID)  of
		[{_, ComLogin, _, _, StartTime, _}] -> % return �� �ش������ ���� .... UserName �ͧ�����, �ѹ����, �������Ңͧ match
			 ONameData =  request_player_data(ComLogin),
			 SStat = request_player_statistic(TID, LoginName),
			 OStat = request_player_statistic(TID, ComLogin),
			 manage_statistic(SPlayer, TnmID, SStat, ONameData, OStat, StartTime);
		_ -> gen_server:cast(SPlayer, {send, [16#81, 16#a1, 0]})
	end.
		 
	
request_player_data(LoginName) ->
	SQLCommand = "CALL smno.sp_get_data_player('" ++ LoginName ++ "');",
	QueryResult = lib_database:get_query(SQLCommand),
	smo_logger:fmsg("~p <=:=> ~p on ~p~n", [SQLCommand, QueryResult, now()]),
	case QueryResult of
		[{selected, _, []}, _] -> {0, [], 0};
		[{selected, _, Result}, _] ->
			[{_PlayerID, PNUTF, Avatar1, Avatar2, _DeckUsed}] = Result,
			Avatar_1 = list_to_integer(Avatar1),
			Avatar_2 = list_to_integer(Avatar2),
			{length(PNUTF), PNUTF, Avatar_1, Avatar_2};
		_ -> {0, [], 0}
	end.
	
request_player_statistic(TID, LoginName) ->
	SQLCommand = "CALL smno.sp_league_get_data_player (" ++integer_to_list(TID)++ ", '" ++ LoginName ++ "');",
	QueryResult = lib_database:get_query(SQLCommand),
	%total_point,  num_win, num_lose, num_draw, num_leave
	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
	case QueryResult of
		[{selected,_, OtherResult},_] -> OtherResult;
		_ -> []
	end.
	
manage_statistic(SPlayer, TnmID, SelfResult, {ONameSize, OName, OAvatar1, OAvatar2}, OtherResult, StartTime) ->
	case {SelfResult, OtherResult} of
		{[], []} -> "";
		{[], _} -> "";
		{_, []} -> "";
		_ ->
			[{_STotalP, SWin, Sloss, SDraw, SLeave, SMatchRem}] = SelfResult,
			[{_OTotalP, OWin, Oloss, ODraw, OLeave, OMatchRem}] = OtherResult,
			A = [<<SWin:8>>, <<Sloss:8>>, <<SDraw:8>>, <<SLeave:8>>, <<SMatchRem:8>>], 
			B = [<<OWin:8>>, <<Oloss:8>>, <<ODraw:8>>, <<OLeave:8>>, <<OMatchRem:8>>],
			TimeSize = length(StartTime),
		%	gen_server:cast(SPlayer, {send, [16#81, 16#a1, 1] ++ TnmID ++  A ++ [ONameSize] ++ OName ++ [0] ++B ++ [TimeSize]++StartTime})
			gen_server:cast(SPlayer, {send, [16#81, 16#a1, 1] ++ [TnmID, ONameSize, OName, OAvatar1, OAvatar2, TimeSize, StartTime]})
	end.
	
register_success(SPlayer, TID, LoginName) ->
	SQLCommand = "CALL smno.sp_league_register (" ++ integer_to_list(1) ++ ", "++integer_to_list(TID)++ ",'" ++ LoginName ++ "');",
	QueryResult = lib_database:get_query(SQLCommand),
	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
	case QueryResult of
		[{selected, _, [{1}]}, _] -> gen_server:cast(SPlayer, {send, [16#81, 16#a0, 1]});
		_ -> reject_register(SPlayer, unsuccess_register)
	end.
%------------------------------------------------------------------	
compatitor_name_status(_SPlayer, LoginName, TID) ->
	%%SQLCommand = "CALL smno.sp_league_get_challenger (" ++integer_to_list(TID)++ ", '" ++ LoginName ++ "');",
	SQLCommand = "CALL smno.sp_league_get_challenger (" ++integer_to_list(TID)++ ", '" ++ LoginName ++ "');",
	QueryResult = lib_database:get_query(SQLCommand),
	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
	case QueryResult of
		[{selected, _, Match}, _] -> Match; % return �� �ش������ ���� .... UserName �ͧ�����, �ѹ����, �������Ңͧ match
		_ -> []
	end.
%------------------------------------------------------------------
% ��ǹ�����ͧ�� �����š���觢ѹ �ͧ User ���
request_player_scoreline(SPlayer) ->
	LoginName = lib_lobby_protocol:get_user_data_pid(SPlayer, [user_id]),
	SQLCommand = "SELECT smno.request_player_scoreline ('" ++ LoginName ++ "');",
	QueryResult = lib_database:get_query(SQLCommand),
	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
	case QueryResult of
		{selected, _, PlayerInfo} -> transform_scoreline_info(SPlayer, PlayerInfo);
		_ -> reject_action(SPlayer, no_user_scoreline)
	end.

transform_scoreline_info(SPlayer, PlayerInfo) ->
	gen_server:cast(SPlayer, {send, [16#ff, 16#aa, PlayerInfo]}).
%------------------------------------------------------------------
% ��ǹ�����ͧ�� �����Ţͧ Torunament
request_tournament_info(SPlayer) ->
	LoginName = lib_lobby_protocol:get_user_data_pid(SPlayer, [user_id]),
	SQLCommand = "SELECT smno.request_tournament_info ('" ++ LoginName ++ "');",
	QueryResult = lib_database:get_query(SQLCommand),
	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
	case QueryResult of
		{selected, _, ComInfo} -> transform_tournament_info(SPlayer, ComInfo);
		_ -> reject_action(SPlayer, no_tournament_information)
	end.

transform_tournament_info(SPlayer, ComInfo) ->
	gen_server:cast(SPlayer, {send, [16#ff, 16#aa, ComInfo]}).
%------------------------------------------------------------------
% ���¡��ԡʶҹо�����觨з�����ѧ�ҡ����к�������¹ʶҹ��繾����������
cancel_player_ready(SPlayer, _TnmID) ->
	lib_lobby_protocol:change_player_data(SPlayer, playing_status, 0),
	case get(counter_pid) of
		undefined -> do_nothing;
		CountPid -> 
			unlink(CountPid),
			exit(CountPid, unused) 
	end,
	
%	put(cancle_clicked, 1),
%	OverTime = get(overtime),

%	if OverTime =:= 1 ->
%		put(ready_clicked, 0);
%	true ->
%		put(waiting, 0)
%	end,

	gen_server:cast(SPlayer, {send, [16#81, 16#a3]}), % ��仺͡����к���¡��ԡʶҹФ���о�����ͧ�س����
	exit.
	
% ��ǹ��èѺ���
response_player_send_ready(SPlayer, Reason) ->
	ReasonSend =
	case Reason of
		compatitor_is_ready -> [1, 1];
		compatitor_is_not_ready -> [1, 2];
		connot_find_match_schedule -> [1, 3];
		waiting_for_next_match -> [1, 4];
		{too_early, TimeEarlier} -> [5, 5] ++ TimeEarlier;
		{too_late, TimeLate} -> [5, 6] ++ TimeLate;
		compatitor_late_you_win -> [1, 7];
		you_are_not_yet_ready_for_match -> [1, 8]
	end,
	gen_server:cast(SPlayer, {send, [16#81, 16#a2] ++ ReasonSend}).
	
player_ready(SPlayer, TnmID) ->
%	Room_Cancle = get(cancle_clicked),
%	if Room_Cancle =:= 1 ->
%		put(ready_to_rejoin, 1);
%	true ->
%		put(ready_to_rejoin, 0)
%	end,
%	ReJoin = get(ready_to_rejoin),
		
%	OverTime = get(overtime),
%	if OverTime =:= 1 ->
%		put(ready_clicked, 1);
%	true ->
%		put(ready_clicked, 2)
%	end,
	
	
%	ReadyClick = get(ready_clicked),
	
	io:format("Tournament ID is ~p~n", [TnmID]),
	<<TID:16>> = list_to_binary(TnmID), 
	% 1. ����Ҥ�������� � ComInfo (��ͧ�� user_id �ͧ����觴���)
	SLogin = lib_lobby_protocol:get_user_data_pid(SPlayer, [user_id]),
		% 2. ��������� �����ͧ�觡Ѻ����� ���쨺������ѧ 
		case compatitor_name_status(SPlayer, SLogin, TID) of
			% �����ѧ��診 ����� condition ��� Db �� Return 1 ��������� �����ѧ������Ѻ��§ҹ��Ҩ������
			[{MID, ComLogin, _, _, _, 1}] ->
				%%��� MID ����˹�� ComLogin ��Ҩ���ش2
				put(match_ID, MID),
				
%				if ReadyClick =:= 1 ->
					PStatusPid = lib_lobby_protocol:get_user_data_login(ComLogin, [playing_status, process_id]),
					io:format("PlayeStatus and ProcessID are ~p~n", [PStatusPid]),
					case PStatusPid of
					% 3.1 ��Ҥ���觾�������� �������ö�������
						[4, ComPid] -> 
							check_schedule_time_remain(SPlayer, SLogin, ComPid, ComLogin, TID, ready);
						% 3.2 ��Ҥ�����ѧ������� (�ó� ��������������к�����)
						[_OtherNo, ComPid] -> 
							%response_player_send_ready(ComPid, compatitor_is_ready),
							%response_player_send_ready(SPlayer, compatitor_is_not_ready),
							check_schedule_time_remain(SPlayer, SLogin, ComPid, ComLogin, TID, not_ready); % �����͹��Ҥ�������������к�����
						% 3.2 ��Ҥ�����ѧ������� (�ó� ��������ѧ����������к�)
						_Other ->
							%response_player_send_ready(SPlayer, compatitor_is_not_ready),
							check_schedule_time_remain(SPlayer, SLogin, [], ComLogin, TID, other_case)
					end;
%					if OverTime =/= 1 ->
%							put(waiting, 1);
%					true ->
%						""
%					end;
					
%				true ->
%					if ReadyClick =:= 0 ->
%						"";
%					true ->
%						if Room_Cancle =/= 1; ReJoin =/= 0 ->
%							put(ready_to_rejoin, 0),
%							% 3. ��д���Ҥ���������ʶҹо�����������ѧ
%							PStatusPid = lib_lobby_protocol:get_user_data_login(ComLogin, [playing_status, process_id]),
%							io:format("PlayeStatus and ProcessID are ~p~n", [PStatusPid]),
%							case PStatusPid of
%								% 3.1 ��Ҥ���觾�������� �������ö�������
%								[4, ComPid] -> 
%									check_schedule_time_remain(SPlayer, SLogin, ComPid, ComLogin, TID, ready);
%								% 3.2 ��Ҥ�����ѧ������� (�ó� ��������������к�����)
%								[_OtherNo, ComPid] -> 
%									%response_player_send_ready(ComPid, compatitor_is_ready),
%									%response_player_send_ready(SPlayer, compatitor_is_not_ready),
%									check_schedule_time_remain(SPlayer, SLogin, ComPid, ComLogin, TID, not_ready); % �����͹��Ҥ�������������к�����
%								% 3.2 ��Ҥ�����ѧ������� (�ó� ��������ѧ����������к�)
%								_Other ->
%									%response_player_send_ready(SPlayer, compatitor_is_not_ready),
%									check_schedule_time_remain(SPlayer, SLogin, [], ComLogin, TID, other_case)
%							end,
%							if OverTime =/= 1 ->
%								put(waiting, 1);
%							true ->
%								""
%							end;
%						true ->  
%							put(ready_to_rejoin,1)
%						end
%					end
%				end;

			error -> response_player_send_ready(SPlayer, connot_find_match_schedule);
				% ���쨺���� ���������ҵ͹������¶֧ �Ҫ�ҡ������ҷ���˹� �駼���������ѧ���֧�����觢ѹ�������� ���������͹˹�ҹ�騺�����
				% �����ѧ�� ����� condition ��� Db �� Return 0 ��������� ���쨺�������С�� Query ����з���ѧ�ҡ���쨺�����Թ 30 �ҷ�
			_Other ->
				% �ó� Other ���� ���쨺���� ...���ͧ�ҡ����������§ҹ��Ǫ�� �١ẹ ���� ���쨺����Ǩ�ԧ� ��ͧ������к͡ �˵ټšѺ Client ����
				response_player_send_ready(SPlayer, waiting_for_next_match) % You Lose
		end.
%		put(cancle_clicked, 0).
		

			% 3.2.1 ��������Ҷ֧���ҷ����觵����˹���������ѧ
				% 3.2.1 ��Ҷ֧�������� �礵����� ������������ѧ 
					% 3.2.1.1 ������������������ �����蹹�骹� ����红�����ŧ Db
					% 3.2.1.2 ����ѧ�������������Ҥ�����ѧ������� ��йѺ���� �������������Ǥ�����ѧ���������� �����蹹�骹� ���Ҥú�������� ����Ǩ����Ҽ���������¹ʶҹ��� play �����ѧ
						% 3.2.1.2.1 �������¹���� ������ͧ������
						% 3.2.1.2.2 ����ѧ�������¹�ʴ�����ѧ����ա���觢ѹ ����������蹹�骹�
				% 3.2.2 ����ѧ���֧������� ������ѧ���֧������ ��йѺ���� �������������Ǥ�����ѧ���������� �����蹹�骹� ���Ҥú�������� ����Ǩ����Ҽ���������¹ʶҹ��� play �����ѧ
					% 3.2.2.1 �������¹���� ������ͧ������
					% 3.2.2.2 ����ѧ�������¹�ʴ�����ѧ����ա���觢ѹ ����������蹹�骹�
check_schedule_time_remain(SPlayer, LoginName, ComPid, ComName, TID, Case) -> 
	Match_ID = get(match_ID),
%	Waiting = get(waiting),
	SQLCommand = "CALL smno.sp_league_chk_status_game (" ++ integer_to_list(Match_ID) ++ ");",
	%%SQLCommand = "CALL smno.sp_league_chk_status_game (" ++ integer_to_list(TID) ++ ", '" ++ LoginName ++ "', '" ++ ComName ++ "');",
	QueryResult = lib_database:get_query(SQLCommand),
	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
	case QueryResult of
		[{selected, _, MatchSchedule}, _] ->
			case MatchSchedule of
				[{0, TimeEarlier}]   -> 
					ETime = round(TimeEarlier/1000),
					response_player_send_ready(SPlayer, {too_early, [<<ETime:32>>]}); % �͡�������������Ѻ���ա㹡��ҷբ�ҧ˹��
%					put(overtime, 0);
				%	 case get(counter_pid) of
				%		undefined -> do_nothing;
				%		CountPid -> 
				%			unlink(CountPid),
				%			exit(CountPid, unused)
				%	end,
				%	
				%	CounterPid = counter_spawn(SPlayer, LoginName, ComPid, ComName, TID, TimeEarlier),
				%	put(counter_pid, CounterPid);
				[{1, TimeRemain}] ->
%					put(overtime, 1),
%					if Waiting =/= 0 ->
						case Case of
							ready ->
								Rank = 3, % �� Rank �� 3 ��͡�����ҧ��ͧ������Ẻ Tournament 
								% ����������������ǵ�ͧ�����¹���� DB ��Ҥ���������������������Ŷ١��ͧ������� remain_time_countdown
								gen_server:cast(ComPid, {arena_to_create, SPlayer, Rank, TID});
%								put(overtime, 0);
							_ ->
								% 1. ����¹ʶҹТͧ���������� 4 ��͹, Status �ͧ�������� 4 ��� �����蹾������ Tournament
								lib_lobby_protocol:change_player_data(SPlayer, playing_status, 4),
								% ���������Ҷ֧��ǹ������Ǽ����蹨Ш֧������ö�� Cancel �����͡价����ҧ����� ���Ͷ�����衴���ͨ����Ҩ�������� �������� �������ա������ҡ� Ready
								%��仺͡����������к�������¹ʶҹТͧ�������繾���������� (����ѧ������ѹ���� ��ͧ��� Client �ӻ�������������͹ ���������顴¡��ԡ)
								%gen_server:cast(SPlayer, {send, []}),
								% ���������Ѻ���Ҩ��֧������Ңͧ Match
								case is_pid(ComPid) of
									true -> 	response_player_send_ready(ComPid, compatitor_is_ready);
									_ -> ""
								end,
								response_player_send_ready(SPlayer, compatitor_is_not_ready),
								case get(counter_pid) of
									undefined -> do_nothing;
									CountPid -> 
										unlink(CountPid),
										exit(CountPid, unused) 
								end,
								CounterPid = counter_spawn(SPlayer, LoginName, ComPid, ComName, TID, TimeRemain),
								put(counter_pid, CounterPid)
						end;
%					true ->
%						""
%					end;
				[{2, TimeLate}] -> LTime = round(TimeLate/1000),
					response_player_send_ready(SPlayer, {too_late, [<<LTime:32>>]}) % You Lose
			end;
		_ -> response_player_send_ready(SPlayer, connot_find_match_schedule)
	end.	
	
% 3.2.1.2 ����ѧ�������������Ҥ�����ѧ������� ��йѺ���� �������������Ǥ�����ѧ���������� �����蹹�骹� ���Ҥú�������� ����Ǩ����Ҽ���������¹ʶҹ��� play �����ѧ
remain_time_countdown(SPlayer, LoginName, ComPid, ComName, TID, TimeRemain) ->
	lib_database:connect(),
	time_countdown(SPlayer, LoginName, ComPid, ComName, TID, TimeRemain).
	
time_countdown(SPlayer, LoginName, ComPid, ComName, TID, TimeRemain) ->	
	case compatitor_name_status(SPlayer, LoginName, TID)  of
	[{MID, _, _, _, _, _}] -> % return �� �ش������ ���� .... UserName �ͧ�����, �ѹ����, �������Ңͧ match
		put(match_ID, MID);
		_ -> gen_server:cast(LoginName, {send, [16#81, 16#a1, 0]})
	end,
	Match_ID = get(match_ID),
	receive
	after TimeRemain ->
		%%SQLCommand = "SELECT smno.fc_league_chk_status (" ++ integer_to_list(TID) ++ ", '" ++ LoginName ++ "', '" ++ ComName ++ "');",
		SQLCommand = "SELECT smno.fc_league_chk_status (" ++ integer_to_list(Match_ID) ++ ");",
		QueryResult = lib_database:get_query(SQLCommand),
		smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]),
		case QueryResult of
			% 3.2.1.2.1 �������¹���� ������ͧ������
			{selected, _, [{1}]} -> 
			% 3.2.1.2.2 ����ѧ�������¹�ʴ�����ѧ����ա���觢ѹ ����������蹹�骹� ��������� �����蹹���ѧ�����ʶҹо������
				case lib_lobby_protocol:get_user_data_pid(SPlayer, [playing_status]) of
					% �������ѧ�����ʶҹо������
					[4] ->
						lib_lobby_protocol:change_player_data(SPlayer, playing_status, 0),
						% �纼š���觢ѹ������ DB
						collect_match_result(LoginName, ComName, TID, "4"),
						response_player_send_ready(SPlayer, compatitor_late_you_win), % You Win
						case is_pid(ComPid) of
							true -> response_player_send_ready(ComPid, you_are_not_yet_ready_for_match);
							_ -> ""
						end;
					% ��������������ʶҹо���������� �Ҩ�ա��¡��ԡ�͡仡�͹
					Other -> smo_logger:fmsg("check user playing status is ~p~n", [Other])
						% response_player_send_ready(SPlayer, you_are_not_yet_ready_for_match),
						% case is_pid(ComPid) of
						%	 true -> response_player_send_ready(ComPid, you_are_not_yet_ready_for_match);
						%	 _ -> ""
						% end
				end;
			_ -> do_nothing
		end
	end.

counter_spawn(SPlayer, LoginName, ComPid, ComName, TnmID, TimeRemain) ->
	spawn_link(lib_tournament, remain_time_countdown, [SPlayer, LoginName, ComPid, ComName, TnmID, TimeRemain]).
	
	
collect_match_result(LoginName, ComName, TID, Result) ->
	Match_ID = get(match_ID),
	%%UpdateCommand = "CALL smno.sp_league_update_logGame (" ++ integer_to_list(TID) ++  ", '" ++ LoginName ++ "', '" ++ ComName ++ "', "++ Result ++");",
	UpdateCommand = "CALL smno.sp_league_update_logGame ("++ integer_to_list(Match_ID) ++" , '" ++ LoginName ++ "', '" ++ ComName ++ "', "++ Result ++");",
	UpdateResult = lib_database:get_query(UpdateCommand),
	smo_logger:fmsg("~p <=:=> ~p~n", [UpdateCommand, UpdateResult]).
%%	SQLCommand = "CALL smno.sp_league_get_challenger (" ++integer_to_list(TID)++ ", '" ++ LoginName ++ "');",
%%	QueryResult = lib_database:get_query(SQLCommand),
%%	smo_logger:fmsg("~p <=:=> ~p~n", [SQLCommand, QueryResult]).