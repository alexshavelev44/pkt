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

padding_bytes(0) -> 0;
padding_bytes(Diff) -> 4 - Diff.

codec(<<Next:8, LenPre:8, Type:8, Flags:8, PayloadPre/binary>>) ->

  Len =  LenPre - 4,

  Padding = Len rem 4,
  AddedNullBytes = padding_bytes(Padding),

  <<Value:Len/bytes, NullBytes:AddedNullBytes/bytes, Payload/bytes>> = PayloadPre,

  {#ipv6_ib{next = Next, len = LenPre, type = Type, flags = Flags, value = Value, null_bytes = NullBytes}, Payload};

codec(#ipv6_ib{next = Next, len = Len, type = Type, flags = Flags, value = Value, null_bytes = NullBytes}) ->

  <<Next:8, Len:8, Type:8, Flags:8, Value/bytes, NullBytes/bytes>>.

