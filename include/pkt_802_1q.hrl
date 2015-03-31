-record('802.1q', {
    tpid :: 1.. 65535, %% Tag Protocol Identifier
    prio :: 0..2#111, %% Priority
    cfi = 0 :: 0 | 1, %% Canonical Format Indicator
    vid :: 0..4095 %% VLAN Identifier
}).
