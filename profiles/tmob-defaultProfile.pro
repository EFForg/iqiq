 	60 1 Å8Default OTA Profile Bith Android Mark I Ćvariable IHERE 0 IHERE !
: iallot IHERE +! ;
: ivar create ihere @ , dup , iallot ;
: (use-ivar) SWAP DUP @ SWAP CELL+ @ ROT SWAP ;
: O@ (use-ivar) case 1 of cv@ endof 2 of wv@ endof 4 of qv@ endof endcase ;
: O! (use-ivar) case 1 of cv! endof 2 of wv! endof 4 of qv! endof endcase ;
Ć#0
HERE SWAP , 0 , 0 , 0 , USE->REL
Ę1? I3 3  https://oddca.t-mobile.com/collector/c 
82799 	3600 
61199 	25200 2 
71999 	14400 4 
75599 	10800 8 
79199 	7200 16 
68399 	18000 32 
64799 	21600 64 ŁLŚE Ć: #netkey@ 0 0 METHODCALL ;
: $netkey@ 0 1 METHODCALL ;
1    CONSTANT PROPID_TECH ;
3    CONSTANT PROPID_ROAMING ;
101  CONSTANT PROP_TECH_GSM ;
104  CONSTANT PROP_ROAMING_NO ;
106  CONSTANT PROP_TECH_LAN ;
2000 CONSTANT PROPID_APN ;
2001 CONSTANT PROPID_MCC ;
2002 CONSTANT PROPID_MNC ;
:noname PROPID_TECH #netkey@ DUP PROP_TECH_LAN = DUP IF
NIP
ELSE
DROP PROP_TECH_GSM =
PROPID_ROAMING #netkey@ PROP_ROAMING_NO = AND DUP IF
DROP PROPID_APN $netkey@ S" epc.tmobile.com" COMPARE 0= DUP IF
DROP PROPID_MCC #netkey@ 310 = DUP IF
DROP PROPID_MNC #netkey@
DUP 200 =
SWAP DUP 901 =
SWAP DUP 800 =
SWAP DUP 660 =
SWAP DUP 580 =
SWAP DUP 310 =
SWAP DUP 270 =
SWAP DUP 250 =
SWAP DUP 220 =
SWAP DUP 970 =
SWAP DUP 160 =
SWAP DUP 260 =
OR OR OR OR OR OR OR OR OR OR OR
THEN
THEN
THEN
THEN ;
JĖ255 G5 UPLOAD_EVENT UPTR 15 LSS10 SS18 SS1A SS1B SS1D SS1E SS1Q SS1R SS1S SS1W SS2A SS2B 