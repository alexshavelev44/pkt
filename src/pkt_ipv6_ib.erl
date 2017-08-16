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



codec(<<Next:8, Len:8, PayloadPre/binary>>) ->

  ChunksLen = Len * 8 + 8 - 2,
  <<Value:ChunksLen/bytes, Payload/bytes>> = PayloadPre,

  IBPre = #ipv6_ib{next = Next, len = Len, value = Value},

  IB = get_chunks(Payload, IBPre),

  {IB, Payload};


codec(#ipv6_ib{next = Next, value = Value, null_bytes = NullBytes}) ->

  %% ALL TO TODO

  <<Next:8, Value/bytes, NullBytes/bytes>>.

get_chunks(<<?AUTH:8, Len:8, Chunk:Len/bytes, Rest/bytes>>, IB) -> get_chunks(Rest, IB#ipv6_ib{auth = Chunk});
get_chunks(<<?PATH:8, Len:8, Chunk:Len/bytes, Rest/bytes>>, IB) -> get_chunks(Rest, IB#ipv6_ib{path = Chunk});
get_chunks(<<?PRG_DATA:8, Len:8, Chunk:Len/bytes, Rest/bytes>>, IB) -> get_chunks(Rest, IB#ipv6_ib{prg_data = Chunk});
get_chunks(<<?INSTRUCTIONS:8, Len:8, Chunk:Len/bytes, Rest/bytes>>, IB) -> get_chunks(Rest, IB#ipv6_ib{instructions = Chunk});
get_chunks(<<>>, IB) -> IB;
get_chunks(<<0:8, _/bytes>> = Padding, IB) -> IB#ipv6_ib{null_bytes = Padding}.





