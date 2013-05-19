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
-module(target_check).
-import (mnesia_table, [do/1]).
-compile (export_all).

-include_lib("stdlib/include/qlc.hrl").
-include_lib("ability_list.hrl").
%===============================================================================
playerown_target_check(AbilityId) -> 
	[Player1Effect ]= do(qlc:q( [ X#card_ability.playerown_have_effect|| X <- mnesia:table(card_ability), X#card_ability.ability_id =:= AbilityId ])),
	if 
		Player1Effect =/= y -> [];
		Player1Effect =:= y -> 1
	end.
%===============================================================================
playeropp_target_check(AbilityId) -> 
	[Player2Effect] = do(qlc:q( [ X#card_ability.player_have_effect|| X <- mnesia:table(card_ability), X#card_ability.ability_id =:= AbilityId ])),
	if 
		Player2Effect =/= y -> [];
		Player2Effect =:= y -> 1
	end.
%===============================================================================
owner_target_check(AbilityId) ->
	[OwnerEffect] = do(qlc:q( [ X#card_ability.owner_have_effect|| X <- mnesia:table(card_ability), X#card_ability.ability_id =:= AbilityId ])),
	if 
		OwnerEffect =/= y -> [];
		OwnerEffect =:= y -> 1
	end.
%===============================================================================
other_target_check({Zone, {PlayerOwnID, CardOrder, CardID}}, AbilityId, PlayerOppID) ->	% retreive whole card in every stage of the Game and check each card status wheater its matching to the ability requirement
	%io:format ("Start OtherTargetCheck ~n"),
	[OtherTargetHaveEffect] = do(qlc:q( [ X#card_ability.other_target_have_effect|| X <- mnesia:table(card_ability), X#card_ability.ability_id =:= AbilityId ])),
	%io:format ("Start OtherTargetCheck ~n ~p~n",[OtherTargetHaveEffect]),
	if 
		OtherTargetHaveEffect =:= n -> [];
		OtherTargetHaveEffect =/= n -> 
			%[IsUntil] = do(qlc:q( [ X#card_ability.is_until|| X <- mnesia:table(card_ability), X#card_ability.ability_id =:= AbilityId ])),
			%io:format('SIsUntil ~p~n',[IsUntil]),
			%if 
				%IsUntil =:= y -> [];
					  %io:format('Check by Requirement ~n'),
					  %requirement:card_requirement(AbilityId);
				%IsUntil =/= y ->	
					list_target_check(Zone, {PlayerOwnID, CardOrder, CardID}, AbilityId, PlayerOppID)
			%end
	end.
%===============================================================================
list_target_check(Zone, {PlayerOwnID, AbilOwnCardOrder, CardID}, AbilityId, PlayerOppID) ->
	%io:format('list_target_check {~p, {~p, ~p, ~p, ~p, ~p}} ~n',[Zone, PlayerOwnID, AbilOwnCardOrder, CardID, AbilityId, PlayerOppID]),
	[{RequirePlayer, RequirePresentZone}] = do(qlc:q([{X#card_ability.target_player_check,X#card_ability.target_present_check} || X <- mnesia:table(card_ability), X#card_ability.ability_id =:= AbilityId])),       
			     % retreive whole card in every stage of the Game and check each card status wheater its matching to the ability requirement
	PlayerZoneList1 = card_list:player_zone_list({RequirePlayer, RequirePresentZone}, {PlayerOwnID, PlayerOppID}), % Return a list of cards of each player in require zone
	[SelfInclude] = do(qlc:q([X#card_ability.target_self_include_check || X <- mnesia:table(card_ability), X#card_ability.ability_id =:= AbilityId])),
	if
		SelfInclude =:= n -> PlayerZoneList = PlayerZoneList1--[{Zone, {PlayerOwnID, AbilOwnCardOrder, CardID}}];
		SelfInclude =/= n -> PlayerZoneList = PlayerZoneList1
	end,
	CheckAllResult = check_all({Zone, {PlayerOwnID, AbilOwnCardOrder, CardID}}, AbilityId, PlayerZoneList),
	%io:format('CheckAllResult ~p~n',[CheckAllResult]),
	CheckAllResult.
%===============================================================================
check_all({CardZone, {AbilOwnPlayerOwnID, AbilOwnCardOrder, AbilOwnCardID}}, AbilityId, [PlayerZoneListHead|Tail]) ->
	[ConditionNeed] = card_condition_require(AbilityId),
	%io:format('ConditionNeed ~p~n',[ConditionNeed]),
	check_all_require_attribute({CardZone, {AbilOwnPlayerOwnID ,AbilOwnCardOrder, AbilOwnCardID}}, PlayerZoneListHead, ConditionNeed)++check_all({CardZone, {AbilOwnPlayerOwnID, AbilOwnCardOrder, AbilOwnCardID}}, AbilityId, Tail);
check_all(_, _, []) -> [].
%===============================================================================
check_all_require_attribute(AbilOwnCardData, PlayerZoneListHeadl, [Head|Tail]) ->
	Return = check_each_require_attribute(AbilOwnCardData, PlayerZoneListHeadl, Head),
	if 
		Return =:= true -> check_all_require_attribute(AbilOwnCardData, PlayerZoneListHeadl, Tail);
		Return =:= false -> []
	end;
check_all_require_attribute(_, PlayerZoneListHeadl, []) -> 
	{_, OtherCardData} = PlayerZoneListHeadl,
	[OtherCardData].
%===============================================================================
check_each_require_attribute(AbilityOwnCardData, OtherCardDataZone,{Attribute, Value}) ->
	case Attribute of
		card_type -> 
			{_,{_,_, CardID}} = OtherCardDataZone,
			attribute_check:card_type_check(CardID, Value);
		name -> attribute_check:name_check(game_info:card_name(OtherCardDataZone), Value);
		naming -> attribute_check:naming_check(game_info:card_name(OtherCardDataZone), Value);
		line -> attribute_check:line_check(game_info:card_line(OtherCardDataZone), Value, game_info:card_curse(OtherCardDataZone));
		action -> attribute_check:action_check(game_info:card_action(OtherCardDataZone), Value);
		elem -> attribute_check:element_check(game_info:card_element(OtherCardDataZone), Value);
		type -> attribute_check:type_check(game_info:card_type(OtherCardDataZone), Value);
		level -> attribute_check:level_check(AbilityOwnCardData, game_info:card_level(OtherCardDataZone), Value);
		mpcast -> attribute_check:mp_cast_check(AbilityOwnCardData, game_info:card_mpcast(OtherCardDataZone), Value);
		mpat -> attribute_check:mpat_check(AbilityOwnCardData, game_info:card_mpat(OtherCardDataZone), Value);
		attack -> attribute_check:at_check(AbilityOwnCardData, game_info:card_at(OtherCardDataZone), Value);
		defend -> attribute_check:df_check(AbilityOwnCardData, game_info:card_df(OtherCardDataZone), Value);
		speed -> attribute_check:sp_check(AbilityOwnCardData, game_info:card_sp(OtherCardDataZone), Value);
		curse -> attribute_check:curse_check(game_info:card_curse(OtherCardDataZone), Value);
		combine -> attribute_check:combine_check(game_info:card_combine(OtherCardDataZone), Value);
		skill -> attribute_check:skill_effect_check(game_info:card_skill_effect(OtherCardDataZone), Value);
		ability -> attribute_check:ability_effect_check(game_info:card_ability_effect(OtherCardDataZone), Value);
		mystic -> attribute_check:mystic_paste_check(game_info:card_mystic_paste(OtherCardDataZone), Value);
		growth -> attribute_check:growth_check(game_info:card_growth(OtherCardDataZone), Value);
		counter -> attribute_check:counter_check(game_info:card_counter(OtherCardDataZone), Value)
	end.
%===============================================================================	
card_condition_require(AbilityId) ->
	do(qlc:q([X#card_ability.target_check || X <- mnesia:table(card_ability), X#card_ability.ability_id =:= AbilityId])).
%===============================================================================