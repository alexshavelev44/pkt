%%%-------------------------------------------------------------------
%%% @author alex_shavelev
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Jun 2017 11:48 AM
%%%-------------------------------------------------------------------
-author("alex_shavelev").

-record(ipv6_ib, {
  next,
  len,
  value,
  null_bytes = <<>>,
  auth = <<>>,
  path = <<>>,
  prg_data = <<>>,
  instructions = <<>>
}).

-define(AUTH, 144).
-define(PATH, 145).
-define(PRG_DATA, 146).
-define(INSTRUCTIONS, 147).
