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
  auth_len = 0,
  path = <<>>,
  path_len = 0,
  instructions = <<>>,
  instructions_len = 0,
  prg_data = <<>>,
  prg_data_len = 0
}).

-define(AUTH1, 1).
-define(PATH1, 2).
-define(PRG_DATA1, 4).
-define(INSTRUCTIONS1, 3).
