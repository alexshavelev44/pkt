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
  type,
  flags,
  value,
  null_bytes = <<>>
}).
