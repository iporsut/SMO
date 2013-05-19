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
%%----------------------------------------------------------
%% McDuck steal this code form : http://langweenie.blogspot.com/2007/06/utf8-for-erlang.html
%% Thanks to Matt Bishop who prepare erlang code based on http://en.wikipedia.org/wiki/UTF-8
%%----------------------------------------------------------
-module(lib_utf8).
-export([from_binary/1, to_binary/1, trim_unicode/1]).

%% Given a binary of UTF-8 encoded text, return a UTF-32 String
%% (i.e. each element is a unicode code point).
from_binary(Bin) ->
    decode_binary(Bin, []).

decode_binary(<<>>, Str) ->
    {ok, lists:reverse(Str)};
decode_binary(Bin, Str) ->
    {B1,B2} = split_binary(Bin, 1),
    case B1 of
        %% 0-7F  0zzzzzzz
        <<0:1,Z:7>> ->
            decode_binary(B2, [Z|Str]);

        %% 110yyyyy 10zzzzzz
        <<2#110:3,Y:5>> ->
            {<<2#10:2,Z:6>>,B3} = split_binary(B2, 1),
            U32 = (Y bsl 6) bor Z,
            decode_binary(B3, [U32|Str]);

        %% 1110xxxx 10yyyyyy 10zzzzzz
        <<2#1110:4,X:4>> ->
            {<<2#10:2,Y:6,2#10:2,Z:6>>,B3} = split_binary(B2, 2),
            U32 = (X bsl 12) bor (Y bsl 6) bor Z,
            decode_binary(B3, [U32|Str]);

        %% 11110www 10xxxxxx 10yyyyyy 10zzzzzz
        <<2#11110:5,W:3>> ->
            {<<2#10:2,X:6,2#10:2,Y:6,2#10:2,Z:6>>,B3} = split_binary(B2, 3),
            U32 = (W bsl 18) bor (X bsl 12) bor (Y bsl 6) bor Z,
            decode_binary(B3, [U32|Str]);

        %% an exception will be raised if the utf8 encoding is off
        %% and causes a match error
        true ->
            {bad_octet, B1}
    end.

%% Given a list of unicode code points, return a binary of UTF-8
%% encoded text.
to_binary(Str) ->
    encode_utf32(Str, []).

encode_utf32([], Utf8) ->
    {ok, list_to_binary(lists:reverse(Utf8))};
encode_utf32([U32|Str], Utf8) ->
    if
        %% 0-7F  0zzzzzzz
        U32 < 16#80 ->
            encode_utf32(Str, [U32|Utf8]);

        %% 110yyyyy 10zzzzzz
        U32 < 16#800 ->
            Y = 2#11000000 bor ((U32 band 16#7c0) bsr 6),
            Z = 2#10000000 bor  (U32 band 16#3f),
            encode_utf32(Str, [Z|[Y|Utf8]]);

        %% 1110xxxx 10yyyyyy 10zzzzzz
        U32 < 16#10000  ->
            X = 2#11100000 bor ((U32 band 16#f000) bsr 12),
            Y = 2#10000000 bor ((U32 band 16#fc0) bsr 6),
            Z = 2#10000000 bor  (U32 band 16#3f),
            encode_utf32(Str, [Z|[Y|[X|Utf8]]]);

        %% 11110www 10xxxxxx 10yyyyyy 10zzzzzz
        U32 < 16#110000 ->
            W = 2#11110000 bor ((U32 band 16#1c0000) bsr 18),
            X = 2#10000000 bor ((U32 band 16#3f000) bsr 12),
            Y = 2#10000000 bor ((U32 band 16#fc0) bsr 6),
            Z = 2#10000000 bor  (U32 band 16#3f),
            encode_utf32(Str, [Z|[Y|[X|[W|Utf8]]]]);

        %% past allocated code points
        true ->
            {bad_code_point, U32}
    end.

trim_unicode([]) -> [];
trim_unicode([H|T]) ->
	if 
		H > 255 -> [H - 3424] ++ trim_unicode(T);
		true -> [H] ++ trim_unicode(T)
	end.
