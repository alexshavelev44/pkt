-module(pkt_ipv6_tests).

-include_lib("pkt/include/pkt.hrl").
-include_lib("eunit/include/eunit.hrl").

codec_test_() ->
    [
        decode(),
        encode()
    ].

packet() ->
    <<96,0,0,0,0,64,58,64,32,1,4,112,0,8,16,109,20,26,254,106,
      31,249,166,149,38,7,248,176,64,11,8,10,0,0,0,0,0,0,16,3,
      128,0,255,149,7,79,0,1,169,244,102,82,0,0,0,0,36,187,0,
      0,0,0,0,0,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,
      31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,
      49,50,51,52,53,54,55>>.

decode() ->
    {Header, Payload} = pkt:ipv6(packet()),
    ?_assertEqual(
        {{ipv6,6,0,0,64,58,64,
         {8193,1136,8,4205,5146,65130,8185,42645},
         {9735,63664,16395,2058,0,0,0,4099}},
         <<128,0,255,149,7,79,0,1,169,244,102,82,0,0,0,0,36,187,0,
           0,0,0,0,0,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,
           31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,
           49,50,51,52,53,54,55>>},
        {Header, Payload}
    ).

encode() ->
    Packet = packet(),
    {Header, Payload} = pkt:ipv6(Packet),
    ?_assertEqual(Packet, <<(pkt:ipv6(Header))/binary, Payload/binary>>).
