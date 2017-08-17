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

-define(AUTH1, 1).
-define(PATH1, 2).
-define(PRG_DATA1, 3).
-define(INSTRUCTIONS1, 4).
