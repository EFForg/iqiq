)	 	j:SS10 HW11 65535 RF02 _GID RF55 UI09 RF04 RF05 UI15 125 127 250 UI08 UI13 120 GS46 HW12 GS47 _UI1 _CRM 220 UPTR SS2A IQTC 100 245 255 26 _DCG UI03 _GSV _LOW _UFG _CHG SS1R SS1S SS1E _UPL Å8DA-OTA Cypress Reference Mark XIX Bith Mark IV Ãvariable IHERE 0 IHERE !
: iallot IHERE +! ;
: ivar create ihere @ , dup , iallot ;
: (use-ivar) SWAP DUP @ SWAP CELL+ @ ROT SWAP ;
: O@ (use-ivar) case 1 of cv@ endof 2 of wv@ endof 4 of qv@ endof endcase ;
: O! (use-ivar) case 1 of cv! endof 2 of wv! endof 4 of qv! endof endcase ;
ÃO: cstrlenv { offset objectID | objlen orig_offset -- len }
offset -> orig_offset
objectID lengthv -> objlen
BEGIN offset objlen < offset objectID cv@ 0<> AND WHILE
1 +-> offset
REPEAT
offset orig_offset - ;
Ãs: submitFth
0 FRONTEND 1 METHODCALL >R
R@ 1 METHODCALL
R@ TRUE FRONTEND 3 METHODCALL
R> FRONTEND 2 METHODCALL ;
: triggerLC30 #FTH1 submitFth ;
: triggerGcid #FTH4 submitFth ;
: abortGcid #FTH5 submitFth ;
: end46
abortGcid
triggerLC30 TRUE ;
Ã@0
1 ivar svcSt : svcSt svcSt BACKEND ;
2 ivar mcc : mcc mcc BACKEND ;
2 ivar mnc : mnc mnc BACKEND ;
2 ivar ui23val : ui23val ui23val BACKEND ;
4 ivar appFgId : appFgId appFgId BACKEND ;
1 ivar trgBrw : trgBrw trgBrw BACKEND ;
: submitUI23
2 FRONTEND 1 METHODCALL >R
#UI23 R@ 1 METHODCALL
R@ 3 METHODCALL
ui23val O@
0 R@ wv!
TRUE R@ PACKAGE 0 METHODCALL
R> FRONTEND 2 METHODCALL
;
HEX 80000007 DECIMAL CONSTANT EVENT_TRIGGER_SURVEY
: triggerSurvey
2DROP DROP ;
: _srvHdlr
S" call_end.xml?manual=0" SWAP #_SRV triggerSurvey
S" call_drop.xml?manual=0" SWAP #_SRV triggerSurvey
S" call_setup_fail.xml?manual=0" SWAP #_SRV triggerSurvey
S" browser_exit.xml?manual=0" SWAP #_SRV triggerSurvey
S" user_satisfaction.xml?manual=1" SWAP #_SRV triggerSurvey ;
: ctor 254 svcSt O! 0 mcc O! 0 mnc O!
0 ui23val O!
0 appFgId O!
FALSE trgBrw O!
;
Ã,HERE SWAP , ' ctor , 0 , IHERE @ , USE->REL
Æ1?60 IGG60 https://oddca.t-mobile.com/collector/c 
82799 	3600 
61199 	25200 
71999 	14400 '
75599 	10800 B
79199 	7200 16 
68399 	18000 32 
64799 	21600 64 ÙLZÃ: #netkey@ 0 0 METHODCALL ;
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
HÉ:T79GS18 Ã<0 IHERE !
4 ivar ts18Hi : ts18Hi ts18Hi METRICBUFFER ;
4 ivar ts18Lo : ts18Lo ts18Lo METRICBUFFER ;
: payld18 PACKAGE [ IHERE @ ] LITERAL ; 7 iallot
1 ivar need03 : need03 need03 METRICBUFFER ;
: mb_gs18
METRIC 0 METHODCALL #LO03 = IF
need03 O@ IF
0 METRIC qv@ 0= 4 METRIC wv@ 0= AND IF
S" Android: GS18 reason string was: " 6 METRIC STRSTRV 6 = IF
FALSE need03 O!
S" apnTypeDisabled" 39 METRIC STRSTRV 39 = IF
323
ELSE S" apnTypeEnabled" 39 METRIC STRSTRV 39 = IF
324
ELSE S" masterDataDisabled" 39 METRIC STRSTRV 39 = IF
325
ELSE S" masterDataEnabled" 39 METRIC STRSTRV 39 = IF
326
ELSE S" iccRecordsL" 39 METRIC STRSTRV 39 = IF
327
ELSE S" cdmaOtaP" 39 METRIC STRSTRV 39 = IF
328
ELSE S" defaultDataDisabled" 39 METRIC STRSTRV 39 = IF
329
ELSE S" defaultDataEnabled" 39 METRIC STRSTRV 39 = IF
330
ELSE S" radioOn" 39 METRIC STRSTRV 39 = IF
331
ELSE S" radioOff" 39 METRIC STRSTRV 39 = IF
332
ELSE S" radioTechnologyChanged" 39 METRIC STRSTRV 39 = IF
333
ELSE S" networkOrModemDisconnect" 39 METRIC STRSTRV 39 = IF
334
ELSE S" dataNetworkAttached" 39 METRIC STRSTRV 39 = IF
335
ELSE S" dataNetworkDetached" 39 METRIC STRSTRV 39 = IF
336
ELSE S" dataProfileDbChanged" 39 METRIC STRSTRV 39 = IF
337
ELSE S" cdmaSubscriptionSourceChanged" 39 METRIC STRSTRV 39 = IF
338
ELSE S" tetheredModeChanged" 39 METRIC STRSTRV 39 = IF
339
ELSE S" dataConnectionPropertyChanged" 39 METRIC STRSTRV 39 = IF
343
ELSE S" pdpDropped" 39 METRIC STRSTRV 39 = IF
307
ElSE
301
THEN THEN THEN THEN THEN THEN THEN THEN THEN THEN
THEN THEN THEN THEN THEN THEN THEN THEN THEN
7 FRONTEND 1 METHODCALL >R
#GS18 R@ 1 METHODCALL
ts18Lo O@ ts18Hi O@ R@ 3 METHODCALL
R@ 0 payld18 7 MEMCPYV
4 R@ wv!
R@ FALSE FRONTEND 3 METHODCALL
R> FRONTEND 2 METHODCALL
THEN
THEN
THEN
FALSE
ELSE
4 METRIC wv@ 301 = DUP need03 O! IF
METRIC 2 METHODCALL ts18Hi O! ts18Lo O!
payld18 METRIC 0 7 MEMCPYV
FALSE
ELSE
TRUE
THEN
THEN ;
: ctor_gs18 FALSE need03 O! ;
here USE->REL
' ctor_gs18 , ' mb_gs18 , IHERE @ , 2 , #GS18 , #LO03 ,
:T79JMÉ:T79Ãu: mb_gs46
4 4 METRIC bitv@ 15 = 2 METRIC cv@ DUP 0= SWAP 255 = OR OR ;
here USE->REL
0 , ' mb_gs46 , 0 , 1 , #GS46 ,
É:TI9JÃm0 IHERE !
1 ivar svcSt : svcSt svcSt METRICBUFFER ;
2 ivar mcc : mcc mcc METRICBUFFER ;
2 ivar mnc : mnc mnc METRICBUFFER ;
: ctor_gsv 254 svcSt O! 0 mcc O! 0 mnc O! ;
: mb_gsv
2 METRIC cv@ DUP svcSt O@ <> DUP >R IF
svcSt O!
ELSE
DROP
THEN
6 1 METRIC bitv@ 0<> IF
6 METRIC wv@ DUP mnc O@ <> DUP R> OR >R IF
mnc O!
ELSE
DROP
THEN
THEN
7 1 METRIC bitv@ 0<> IF
4 METRIC wv@ DUP mcc O@ <> DUP R> OR >R IF
mcc O!
ELSE
DROP
THEN
THEN
R>
;
here USE->REL
' ctor_gsv , ' mb_gsv , IHERE @ , 1 , #GS46 ,
É:TI9JWÃ40 IHERE !
4 ivar st47 : st47 st47 METRICBUFFER ;
: ctor_47 -1 st47 O! ;
: mb_gs47
st47 O@ 0 METRIC wv@ DUP st47 O! <> ;
here USE->REL
' ctor_47 , ' mb_gs47 , IHERE @ , 1 , #GS47 ,
É:TI9JaÃH0 IHERE !
1 ivar mb_evdo : mb_evdo mb_evdo METRICBUFFER ;
1 ivar mb_roam : mb_roam mb_roam METRICBUFFER ;
: ctor_crm -1 mb_evdo O! -1 mb_roam O! ;
: mb_crm
mb_evdo O@ METRIC 0 METHODCALL #DO3M = DUP mb_evdo O! <>
mb_roam O@ 0 METRIC cv@ DUP mb_roam O! <> OR ;
here USE->REL
' ctor_crm , ' mb_crm , IHERE @ , 2 , #RF1A , #DO3M ,
:P39:P39$:P39):79J:79'tÉ:GI940 \ÃJ: mb_ui01
2 METRIC cv@ 0= ;
here USE->REL
0 , ' mb_ui01 , 0 , 1 , #UI01 ,
:T79?É:39!ÃQ: mb_hw03con
0 METRIC cv@ 2 = ;
here USE->REL
0 , ' mb_hw03con , 0 , 1 , #HW03 ,
É:39ÃR: mb_hw03dis
0 METRIC cv@ 3 =  ;
here USE->REL
0 , ' mb_hw03dis , 0 , 1 , #HW03 ,
É:39ÃQ: mb_hw03low
0 METRIC cv@ 0=  ;
here USE->REL
0 , ' mb_hw03low , 0 , 1 , #HW03 ,
É:39_OFF ÃR: mb_hw03off
0 METRIC cv@ 1 =  ;
here USE->REL
0 , ' mb_hw03off , 0 , 1 , #HW03 ,
É:39_FIN ÃT: mb_hw03done
0 METRIC cv@ 4 =  ;
here USE->REL
0 , ' mb_hw03done , 0 , 1 , #HW03 ,
:P39:39É73000 Ã}: mb_uiFG METRIC 0 METHODCALL #UI19 = IF 4 METRIC cv@ ELSE TRUE THEN ;
here USE->REL
0 , ' mb_uiFG , 0 , 2 , #UI19 , #UI13 ,
É:795Ã[: mb_iqt0 0 METRIC cv@ DUP 6 = SWAP 4 = OR ;
here USE->REL
0 , ' mb_iqt0 , 0 , 1 , #IQT0 ,
72000 D:79jÊH102400 ËfIPOWER_ON TION 0LÍMÃ:noname FALSE ;
ÍHW03 Ã:noname FALSE ;
t44$4)4aËfPOWER_OFF TIOF 0L$)ËUPLOAD_EVENT j0L SS18 SS1A SS1B SS1D 0SS1Q &+SS1W oSS2B IQ02 IQ04 IQ05 IQ08 IQHB IQBR IQP0 IQP1 IQP2 IQP3 IQP4 IQP6 IQP7 IQP8 IQPA IQPB IQOP Ë240 GS03,IQPT =22432 ;APP_VOICE_CALL <>GGS01 0Ã@0 IHERE !
4 ivar callID : callID callID PACKAGE ;
1 ivar conn : conn conn PACKAGE ;
1 ivar term : term term PACKAGE ;
: saveID
0 METRIC qv@ callID O! FALSE conn O! 39 1 METRIC bitv@ term O! TRUE ;
: matchID 0 METRIC qv@ callID O@ = ;
: stChk 4 METRIC cv@ 5 = IF TRUE conn O! THEN matchID ;
: isAbnormalTerm 8 METRIC wv@ DUP 16 = SWAP 128 = OR 4 METRIC qv@ 129 = OR 0= ;
: endCall METRIC 0 METHODCALL #GS03 = IF
matchID DUP IF
triggerGcid
conn O@ 0= IF
term O@ 0= IF
S" call_setup_fail.xml"
SWAP #GS03 triggerSurvey
THEN
ELSE
isAbnormalTerm IF
S" call_drop.xml"
ELSE
S" call_end.xml"
THEN
SWAP #GS03 triggerSurvey
THEN
THEN
ELSE
triggerLC30
FALSE
THEN ;
here USE->REL
' saveID , ' endCall , 0 , IHERE @ ,
LÍ4GS02 
Ã' stChk
4M

?a$
)
oNÏ4Ã' end46
?Ë;_GSV,TIOF ;SVC_STATUS_LEGACY >G0Ãhere USE->REL
0 , 0 , 0 , 0 ,
L4Ë;GS47,TIOF ;SVC_STATUS >GW0Ãhere USE->REL
0 , 0 , 0 , 0 ,
L$)W4Ë}_DCG,_FIN,TIOF CHARGE_CYCLE >G!0L

$)NË}_CHG,_OFF,TIOF DRAIN_CYCLE >G0L

$)NË240 GS18,IQPT,TIOF ;PDP_CONTEXT <30 >GGS19 0Ã0 IHERE !
4 ivar pdpCtxt : pdpCtxt pdpCtxt PACKAGE ;
1 ivar pdpTO : pdpTO pdpTO PACKAGE ;
: isCtxt pdpCtxt O@ 0 METRIC qv@ = ;
: pdpAct isCtxt DUP IF FALSE pdpTO O! THEN ;
: ctorPdp 0 METRIC qv@ pdpCtxt O! TRUE pdpTO O! TRUE ;
: endPdp METRIC 0 METHODCALL DUP #IQPT = IF DROP
pdpTO O@
ELSE #GS18 = IF
isCtxt
ELSE
TRUE
THEN THEN DUP IF triggerGcid THEN ;
here USE->REL
' ctorPdp , ' endPdp , 0 , IHERE @ ,
LÍ4GS15 
Ã	' pdpAct
4M
a$
)

?oNÏ4Ã' end46
?Ë200 =32000 3UNCLEAN_SHUTDOWN SQSF 0LRHW13 $)60 &+0tËQU05 ;SURVEY_INSTANCE >GQU01 0ÃU0 IHERE !
4 ivar svyId : svyId svyId PACKAGE ;
: getSvyId 0 METRIC cstrlenv 1+ METRIC qv@ ;
: matchSvy svyId O@ getSvyId = ;
: ctorSvy getSvyId svyId O! TRUE ;
here USE->REL
' ctorSvy , ' matchSvy , 0 , IHERE @ ,
LÍ4QU03 
Ã' matchSvy
Í4QU04 
Ã' matchSvy
W$)?Ë}5BATTERY_TRIGGER 0L44Ë_GID,FTH5 ;5IQPT =yGCID_TRIGGER <JFTH4 0ÃC: endGcid triggerLC30 TRUE ;
here USE->REL
0 , ' endGcid , 0 , 0 ,
N4MË;UI19,UI15,TIOF APP_FOCUS_EVENT >G0Ãg0 IHERE !
4 ivar dwAppFId : dwAppFId dwAppFId PACKAGE ;
1 ivar need13 : need13 need13 PACKAGE ;
1 ivar need15 : need15 need15 PACKAGE ;
: matchAppFId 0 METRIC qv@ dwAppFId O@ = ;
: brwChk
4 METRIC cv@ DUP 0 = trgBrw O!
32 = trgBrw O@ AND IF
FALSE trgBrw O!
S" browser_exit.xml" SWAP #UI15 triggerSurvey
THEN ;
: ui13Match matchAppFId need13 O@ AND DUP IF
FALSE need13 O!
brwChk
THEN ;
: ui15Match matchAppFId need15 O@ AND ;
: ctorF
0 METRIC qv@ DUP appFgId O! dwAppFId O!
TRUE need15 O!
METRIC 0 METHODCALL #UI19 = DUP need13 O!
0= IF brwChk THEN
TRUE ;
: endF METRIC 0 METHODCALL DUP #TIOF = DUP IF NIP ELSE DROP #UI19 = IF
4 METRIC cv@ 0=
ELSE
FALSE need15 O! TRUE
THEN matchAppFId AND THEN ;
here USE->REL
' ctorF , ' endF , 0 , IHERE @ ,
L\Í4DyÃ' ui13Match

N\Ï4.Ã' ui15Match
Ë;APP_BACKGND_CLOSE >.0ÃH0 IHERE !
4 ivar dwAppBId : dwAppBId dwAppBId PACKAGE ;
1 ivar need13Bg : need13Bg need13Bg PACKAGE ;
: matchAppBId 0 METRIC qv@ dwAppBId O@ = ;
: ui13Bg matchAppBId need13Bg O@ AND DUP IF
FALSE need13Bg O!
THEN ;
: ctorBg
TRUE need13Bg O!
0 METRIC qv@ DUP dwAppBid O! appFgId O@ <> ;
here USE->REL
' ctorBg , 0 , 0 , IHERE @ ,
L\Í4DyÃ	' ui13Bg
Ë_UPL,IQPT UPLOAD_STATUS >G50ÃC: uplCtor 0 METRIC cv@ 6 = ;
here USE->REL
' uplCtor , 0 , 0 , 0 ,
Lj4IQT0 
4IQT1 
4LO03 
N?