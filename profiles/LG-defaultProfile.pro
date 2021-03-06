æ 	 Å8OTA Mark VII Ã
variable IHERE 0 IHERE !
: iallot ( n -- ) IHERE +! ;
: ivar ( n <name> -- ) create ihere @ , dup , iallot ;
: (use-ivar) ( ivaddr object -- ivoffset object ivsize ) SWAP DUP @ SWAP CELL+ @ ROT SWAP ;
: O@ ( ivaddr object -- n ) (use-ivar) case 1 of cv@ endof 2 of wv@ endof 4 of qv@ endof endcase ;
: O! ( n ivaddr object -- ) (use-ivar) case 1 of cv! endof 2 of wv! endof 4 of qv! endof endcase ;
Ã
: submitFth
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
\ : catch46 0 METRIC qv@ #GS46 = ;
ÃE
0
1 ivar svcSt : svcSt svcSt BACKEND ;
2 ivar mcc : mcc mcc BACKEND ;
2 ivar mnc : mnc mnc BACKEND ;
2 ivar ui23val : ui23val ui23val BACKEND ;

: submitUI23 ( timestamp -- )
	2 FRONTEND 1 METHODCALL >R
	#UI23 R@ 1 METHODCALL
	R@ 3 METHODCALL \ Set ts with RecordMetric
	ui23val O@
	0 R@ wv!
	\ R@ TRUE SubmitMetricM
	TRUE R@ PACKAGE 0 METHODCALL \ RecordMetric
	R> FRONTEND 2 METHODCALL
	;

HEX 80000007 DECIMAL CONSTANT EVENT_TRIGGER_SURVEY
: triggerSurvey ( eventDataLen eventDataAddr metricID -- )
	EVENT_TRIGGER_SURVEY BACKEND 11 METHODCALL ;
: _srvHdlr DROP S" normal_voice_call.xml?manual=1" SWAP #_SRV triggerSurvey ;
: ctor 254 svcSt O! 0 mcc O! 0 mnc O! 
	['] _srvHdlr #_SRV BACKEND 7 METHODCALL ;
Ã-
HERE SWAP , ' ctor , 0 , IHERE @ , USE->REL
Æ10 ?120 I2 2 1800 http://rainbow.sky.carrieriq.com/collector/c?cm_sl=1 
3600 	0 0 127 
3600 	3600 0 127 
3600 	7200 0 127 
3600 	10800 0 127 
3600 	14400 0 127 
3600 	18000 0 127 
3600 	21600 0 127 
3600 	25200 0 127 
3600 	28800 0 127 
3600 	32400 0 127 
3600 	36000 0 127 
3600 	39600 0 127 
3600 	43200 0 127 
3600 	46800 0 127 
3600 	50400 0 127 
3600 	54000 0 127 
3600 	57600 0 127 
3600 	61200 0 127 
3600 	64800 0 127 
3600 	68400 0 127 
3600 	72000 0 127 
3600 	75600 0 127 
3600 	79200 0 127 
3600 	82800 0 127 L0 H:12 127 920 GS46 É:12 120 920 _G46 Ã
: mb_gs46cvg 
	2 METRIC cv@ DUP 255 = SWAP 0= OR
	6 2 METRIC bitv@ 3 = 4 1 METRIC bitv@ 0<> AND
	OR ;
here USE->REL
	0 , ' mb_gs46cvg , 0 , 1 , #GS46 ,
É:12 120 920 _G47 Ã8
0 IHERE !
4 ivar st47 : st47 st47 METRICBUFFER ;
: ctor_47 -1 st47 O! ;
: mb_gs47 
	st47 O@ 0 METRIC wv@ DUP st47 O! <> ;
here USE->REL
	' ctor_47 , ' mb_gs47 , IHERE @ , 1 , #GS47 ,
É:12 120 920 _CRM ÃL
0 IHERE !
1 ivar mb_evdo : mb_evdo mb_evdo METRICBUFFER ;
1 ivar mb_roam : mb_roam mb_roam METRICBUFFER ;
: ctor_crm -1 mb_evdo O! -1 mb_roam O! ;
: mb_crm
	mb_evdo O@ METRIC 0 METHODCALL #DO3M = DUP mb_evdo O! <>
	mb_roam O@ 0 METRIC cv@ DUP mb_roam O! <> OR ;
here USE->REL
	' ctor_crm , ' mb_crm , IHERE @ , 2 , #RF1A , #DO3M ,
:6 125 910 RF02 :6 125 910 RF04 :6 125 910 RF05 :5 127 920 RF55 :26 127 94 IQTC É:3 120 940 @UI1 ÃN
: mb_ui01 
	2 METRIC cv@ 0= ;
here USE->REL
	0 , ' mb_ui01 , 0 , 1 , #UI01 ,
:12 127 910 UI08 É:5 125 910 _CHG ÃU
: mb_hw03con 
	0 METRIC cv@ 2 = ;
here USE->REL
	0 , ' mb_hw03con , 0 , 1 , #HW03 ,
É:5 125 910 _DCG ÃV
: mb_hw03dis 
	0 METRIC cv@ 3 =  ;
here USE->REL
	0 , ' mb_hw03dis , 0 , 1 , #HW03 ,
É:5 125 910 _LOW ÃU
: mb_hw03low 
	0 METRIC cv@ 0=  ;
here USE->REL
	0 , ' mb_hw03low , 0 , 1 , #HW03 ,
É:5 125 95 _OFF ÃV
: mb_hw03off 
	0 METRIC cv@ 1 =  ;
here USE->REL
	0 , ' mb_hw03off , 0 , 1 , #HW03 ,
É:5 125 95 _FIN ÃX
: mb_hw03done 
	0 METRIC cv@ 4 =  ;
here USE->REL
	0 , ' mb_hw03done , 0 , 1 , #HW03 ,
:6 125 910 HW11 :5 125 910 UI09 É:10 127 910 _UPL Ã]
: mb_iqt0 0 METRIC cv@ DUP 6 = SWAP 4 = OR ;
here USE->REL
	0 , ' mb_iqt0 , 0 , 1 , #IQT0 ,
:10 127 92 UPTR Ê7H102400 Ë220 120 POWER_ON TION 15 L_G46 1 0 ÍGS46 1 0 Ã
:noname FALSE ;
ÍHW03 1 0 Ã
:noname FALSE ;
IQTC 1 1 RF02 42 1 0 RF04 42 1 0 RF05 42 1 0 _CRM 42 1 0 Ë220 0 POWER_OFF TIOF 15 L_G46 0 1 RF02 0 1 RF04 0 1 RF05 0 1 Ë255 5 UPLOAD_EVENT UPTR 15 LSS10 1 0 SS18 1 0 SS1A 1 0 SS1B 1 0 SS1D 1 0 SS1E 1 0 SS1Q 2 0 SS1R 1 0 SS1S 1 0 SS1W 1 0 SS2A 1 0 IQ02 2 0 IQ04 1 0 IQ05 1 0 IQ08 2 0 IQHB 2 0 IQBR 1 0 IQP0 1 0 IQP1 1 0 IQP2 1 0 IQP3 1 0 IQP4 1 0 IQP6 1 0 IQP7 1 0 IQP8 1 0 IQPA 1 0 IQPB 1 0 IQOP 1 0 Ë240 GS03,IQPT 250 APP_VOICE_CALL <2 0 >3 GS01 15 =22432 Ã^
0 IHERE !
4 ivar callID : callID callID PACKAGE ;
: saveID 
	0 METRIC qv@ callID O! TRUE ;
: matchID 0 METRIC qv@ callID O@ = ;
: isAbnormalTerm TRUE ; \ 8 METRIC wv@ DUP 0= IF DROP 4 METRIC qv@ 0<> ELSE 31 <> THEN ;
: endCall METRIC 0 METHODCALL #GS03 = IF 
		matchID DUP IF
			triggerGcid
			isAbnormalTerm IF S" normal_voice_call.xml" SWAP #GS03 triggerSurvey THEN
		THEN
	ELSE \ assume IQPT
		triggerLC30
		FALSE
	THEN ;
here USE->REL
	' saveID , ' endCall , 0 , IHERE @ ,
LÍGS02 65535 0 42 Ã
' matchID
_G46 0 1 GS46 65535 0 42 LC18 1 0 RF55 65535 2 UI08 2 2 _CRM 0 1 RF02 1 0 RF04 65535 0 RF05 65535 0 NÏ_G46 1 0 42 Ã	
' end46
RF02 1 0 LC18 1 0 RF55 2 0 UI08 2 2 Ë250 _G46,TIOF 250 SVC_STATUS >3 _G46 15 Ã]
0 IHERE !
4 ivar stTsHi : stTsHi stTsHi PACKAGE ;
4 ivar stTsLo : stTsLo stTsLo PACKAGE ;
1 ivar needRF : needRF needRF PACKAGE ;
\ : chkTime stTsLo O@ stTsHi O@ METRIC 2 METHODCALL FRONTEND 0 METHODCALL DROP 0= SWAP 60000 < AND ;
: chkRF needRF O@ DUP IF FALSE needRF O! THEN ;
: onSvcChg 
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
	R> DUP IF
		METRIC 2 METHODCALL stTsHi O! stTsLo O!
		TRUE needRF O!
	THEN ;
: isSvcChg
	METRIC 0 methodcall #TIOF = IF
		254 svcSt O! TRUE 
	ELSE
		2 METRIC cv@ svcSt O@ <> DUP >R INVERT IF
			6 1 METRIC bitv@ 0<> IF
				6 METRIC wv@ mnc O@ <> R> OR >R
			THEN 
			7 1 METRIC bitv@ 0<> IF
				4 METRIC wv@ mcc O@ <> R> OR >R
			THEN
		THEN
		R>
	THEN ;
here USE->REL
	' onSvcChg , ' isSvcChg , 0 , IHERE @ ,
L_G46 0 2 RF55 0 1 ÍRF55 42 1 0 Ã	
' chkRF
LC18 1 0 NÏLC18 42 1 0 Ã
:noname FALSE ;
Ë250 _G47,TIOF 250 SVC_STATUS_47 >3 _G47 15 Ã 
here USE->REL
	0 , 0 , 0 , 0 ,
L_G46 1 2 RF55 0 1 RF55 42 1 0 LC18 1 0 NÏLC18 42 1 0 Ã
:noname FALSE ;
Ë245 _DCG,_FIN,TIOF 2 CHARGE_CYCLE >3 _CHG 15 LUI09 65535 1 HW11 65535 1 _G46 0 1 RF04 0 1 RF05 0 1 LC18 1 0 NUI09 1 0 HW11 1 0 Ë245 _CHG,_OFF,TIOF 10 DRAIN_CYCLE >3 _DCG 15 LUI09 65535 1 HW11 65535 1 _G46 0 1 RF04 0 1 RF05 0 1 LC18 1 0 NUI09 1 0 HW11 1 0 Ë240 GS18,IQPT,TIOF 250 PDP_CONTEXT <30 GS19 >3 15 Ã 
0 IHERE !
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
LÍGS15 42 65535 0 Ã

' pdpAct
_G46 0 1 GS46 42 65535 0 _CRM 0 1 RF04 65535 0 RF05 65535 0 LC18 1 0 RF55 65535 2 UI08 2 2 NÏ_G46 1 0 42 Ã	
' end46
LC18 1 0 RF55 0 10 UI08 0 2 Ë200 =32000 125 UNCLEAN_SHUTDOWN 1 SQSF 15 LHW12 1 0 HW13 1 0 _G46 0 1 RF04 0 1 RF05 0 1 RF55 0 60 SS1R 1 0 SS1S 1 0 SS1E 1 0 IQTC 1 0 UI03 1 0 Ë255 AL41 SURVEY_RESULTS >3 AL40 15 Ãm
0 IHERE !
4 ivar surId : surId surId PACKAGE ;
: isSurMatch 0 METRIC qv@ surId O@ = ;
: isSurLast isSurMatch 40 1 METRIC bitv@ 0= AND ;
: storeSur
	0 METRIC qv@ surId O! TRUE ;
here USE->REL
	' storeSur , ' isSurLast , 0 , IHERE @ ,
			LÍAL41 65535 0 Ã
' isSurMatch
Ë245 52 BATTERY_TRIGGER _LOW 15 LUI09 41 1 0 HW11 41 1 0 Ë_G46,FTH5,LC18 250 IQPT 5=100 GCID_TRIGGER 5 <20 FTH4 >0 15 ÃE
: endGcid triggerLC30 TRUE ;
here USE->REL
	0 , ' endGcid , 0 , 0 ,
NGS46 41 1 0 Ë250 _CRM,TIOF 250 CDMA_SVC_STATUS >3 _CRM 15 Ã 
here USE->REL
	0 , 0 , 0 , 0 ,
LRF02 1 1 RF04 1 1 RF05 1 1 RF55 0 1 RF55 42 1 0 LC18 1 0 NÏLC18 42 1 0 Ã
:noname FALSE ;
Ë255 _UPL,IQPT UPLOAD_STATUS 0 >3 _UPL 15 ÃE
: uplCtor 0 METRIC cv@ 6 = ;
here USE->REL
	' uplCtor , 0 , 0 , 0 ,
LUPTR 0 1 IQT0 42 65535 0 IQT1 42 65535 0 LO03 42 65535 0 NRF55 0 2 UI08 0 2 ËAPP_EVENT UI13 0 >3 255 UI15,TIOF =25000 0 15 Ã`
0 IHERE !
4 ivar dwAppId : dwAppId dwAppId PACKAGE ;
1 ivar ucAppType : ucAppType ucAppType PACKAGE ;
4 ivar tsLo : tsLo tsLo PACKAGE ;
4 ivar tsHi : tsHi tsHi PACKAGE ;
\ 33 CONSTANT session_ui_event
\ 65534 CONSTANT pldrawstart_ui_event
\ 65535 CONSTANT pldrawend_ui_event
: incUI23 ui23val O@ 1+ ui23val O! METRIC 2 METHODCALL submitUI23 ;
: decUI23 ui23val O@ 1- ui23val O! METRIC 2 METHODCALL submitUI23 ;
: ctor13
   	0 METRIC qv@ dwAppId O!
   	4 METRIC cv@ ucAppType O! 
   	METRIC 2 METHODCALL tsHi O! tsLo O!
   	incUI23
   	TRUE ;
: matchAppId 0 METRIC qv@ dwAppId O@ = ;
: matchEndAppId METRIC 0 METHODCALL #TIOF = IF 
		TRUE 
	ELSE 
		matchAppId 
	THEN 
	DUP IF decUI23 ucAppType O@ 0= IF S" browser_exit.xml" SWAP #UI15 triggerSurvey THEN THEN ;
: matchAppType 4 METRIC cv@ ucAppType O@ = ;
here USE->REL
	' ctor13 , ' matchEndAppId , 0 , IHERE @ ,
LÍUI03 65535 0 Ã
' matchAppType
ÍUI19 65535 0 Ã
' matchAppId
NÏUI24 0 2 Ã
' matchAppId
