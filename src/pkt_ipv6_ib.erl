%%%-------------------------------------------------------------------
%%% @author alex_shavelev
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Jun 2017 11:41 AM
%%%-------------------------------------------------------------------
-module(pkt_ipv6_ib).
-author("alex_shavelev").

-include("pkt.hrl").

%% API
-export([
  codec/1
]).

-define(RECORD_TO_TUPLELIST(Rec, Ref), lists:zip(record_info(fields, Rec),tl(tuple_to_list(Ref)))).


codec(<<Next:8, Len:8, PayloadPre/binary>>) ->

  ChunksLen = Len * 8 + 8 - 2,
  <<Value:ChunksLen/bytes, Payload/bytes>> = PayloadPre,

  IBPre = #ipv6_ib{next = Next, len = Len, value = Value},

  IB = get_chunks(Value, IBPre),

  {IB, Payload};


codec(#ipv6_ib{next = Next} = Rec) ->

  Value = fold_ib_header(?RECORD_TO_TUPLELIST(ipv6_ib, Rec)),

  Len = byte_size(Value) div 8,

  <<Next:8, Len:8, Value/bytes>>.


fold_ib_header(List) -> fold_ib_header(List, <<>>).

fold_ib_header([{auth, <<>>} | Rest], Acc) -> fold_ib_header(Rest, Acc);
fold_ib_header([{auth, Value} | Rest], Acc) ->
  Len = byte_size(Value),
  fold_ib_header(Rest, <<Acc/bytes, ?AUTH1:4, Len:12, Value/bytes>>);

fold_ib_header([{path, <<>>} | Rest], Acc) -> fold_ib_header(Rest, Acc);
fold_ib_header([{path, Value} | Rest], Acc) ->
  Len = byte_size(Value),
  fold_ib_header(Rest, <<Acc/bytes, ?PATH1:4, Len:12, Value/bytes>>);

fold_ib_header([{instructions, <<>>} | Rest], Acc) -> fold_ib_header(Rest, Acc);
fold_ib_header([{instructions, Value} | Rest], Acc) ->
  Len = byte_size(Value),
  fold_ib_header(Rest, <<Acc/bytes, ?INSTRUCTIONS1:4, Len:12, Value/bytes>>);

fold_ib_header([{prg_data, <<>>} | Rest], Acc) -> fold_ib_header(Rest, Acc);
fold_ib_header([{prg_data, Value} | Rest], Acc) ->
  Len = byte_size(Value),
  fold_ib_header(Rest, <<Acc/bytes, ?PRG_DATA1:4, Len:12, Value/bytes>>);

fold_ib_header([{_, _} | Rest], Acc) -> fold_ib_header(Rest, Acc);

fold_ib_header([], Acc) ->
  NullBytesSize = padding_to_eight_bytes(byte_size(Acc) + 2),
  NullBits = NullBytesSize * 8,
  NullBytes = <<0:NullBits>>,
  <<Acc/bytes, NullBytes/bytes>>.

%% test





padding_bytes(0) -> 0;
padding_bytes(Diff) -> 8 - Diff.


padding_to_eight_bytes(Len) ->
  Padding = Len rem 8,
  padding_bytes(Padding).



get_chunks(<<?AUTH1:4, Len:12, Chunk:Len/bytes, Rest/bytes>>, IB) ->
  get_chunks(Rest, IB#ipv6_ib{auth = Chunk, auth_len = Len + 2});
get_chunks(<<?PATH1:4, Len:12, Chunk:Len/bytes, Rest/bytes>>, IB) ->
  get_chunks(Rest, IB#ipv6_ib{path = Chunk, path_len = Len + 2});
get_chunks(<<?PRG_DATA1:4, Len:12, Chunk:Len/bytes, Rest/bytes>>, IB) ->
  get_chunks(Rest, IB#ipv6_ib{prg_data = Chunk, prg_data_len = Len + 2});
get_chunks(<<?INSTRUCTIONS1:4, Len:12, Chunk:Len/bytes, Rest/bytes>>, IB) ->
  get_chunks(Rest, IB#ipv6_ib{instructions = Chunk, instructions_len = Len + 2});
get_chunks(<<>>, IB) ->
  IB;
get_chunks(<<0:8, _/bytes>> = Padding, IB) ->
  IB#ipv6_ib{null_bytes = Padding}.





