ż 	20 1 21599 127 12 Å8Default Profile Hoth Mark IX Ćvariable IHERE 0 IHERE !
: iallot IHERE +! ;
: ivar create ihere @ , dup , iallot ;
: (use-ivar) SWAP DUP @ SWAP CELL+ @ ROT SWAP ;
: O@ (use-ivar) case 1 of cv@ endof 2 of wv@ endof 4 of qv@ endof endcase ;
: O! (use-ivar) case 1 of cv! endof 2 of wv! endof 4 of qv! endof endcase ;
Ć#0
HERE SWAP , 0 , 0 , 0 , USE->REL
Ę1?60 I3600 https://ciqcol01.ciq.labs.att.com:10010/collector/c 
 	
 	64800 ŁLŚE Ć: #netkey@ 0 0 METHODCALL ;
: $netkey@ 0 1 METHODCALL ;
1    CONSTANT PROPID_TECH ;
3    CONSTANT PROPID_ROAMING ;
101  CONSTANT PROP_TECH_GSM ;
104  CONSTANT PROP_ROAMING_NO ;
106  CONSTANT PROP_TECH_LAN ;
2000 CONSTANT PROPID_APN ;
:noname PROPID_TECH #netkey@ PROP_TECH_LAN = ;
JĖ255 G5 UPLOAD_EVENT UPTR 15 LSS10 SS18 SS1A SS1B SS1D SS1E SS1Q SS1R SS1S SS1W SS2B 