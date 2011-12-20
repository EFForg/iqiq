\ This program is embedded as CDATA in the <Connection> element in T-Mobile's
\ default profile. It appears to specify when a connection is eligible for
\ reporting.

\ Foreign method (propertyId -- n) 
\ IQNetwork::CIQ_ForthConnectionObj_NetKeyInteger(ciq_forth_vm*, ciq_forth_object*)
\ Retrieves an integer valued property from the connection object.
: #netkey@ 0 0 METHODCALL ;

\ Foreign method (propertyId -- c1 .. cN N)
\ IQNetwork::CIQ_ForthConnectionObj_NetKeyString(ciq_forth_vm*, ciq_forth_object*)
\ Retrieves a string valued property from the connection object.
: $netkey@ 0 1 METHODCALL ;

\ Properties in the connection object and enums for their values.
1    CONSTANT PROPID_TECH ;     \ Current network technology.
3    CONSTANT PROPID_ROAMING ;  \ Roaming state.
101  CONSTANT PROP_TECH_GSM ;   \ GSM connection.
104  CONSTANT PROP_ROAMING_NO ; \ Not roaming.
106  CONSTANT PROP_TECH_LAN ;   \ LAN connection.
2000 CONSTANT PROPID_APN ;      \ Access point name.
2001 CONSTANT PROPID_MCC ;      \ Mobile country code.
2002 CONSTANT PROPID_MNC ;      \ Mobile network code.

\ :noname compiles an anonymous definition and pushes a token that can
\ be used to execute it (so the side-effect of this embedded program is
\ to leave such a token on the stack.)
:noname
  \ Determine if this connection is eligible.
  PROPID_TECH #netkey@ DUP  \ Get network technology. (-- t t)
  PROP_TECH_LAN = DUP IF    \ Is this a LAN connection? (t t -- t flags)
    NIP                     \ If so, leave TRUE on the stack. (t flags -- flags)
  ELSE  \ Not a LAN connection.
    DROP
    PROP_TECH_GSM =  \ GSM connection, (t -- flags)
    PROPID_ROAMING #netkey@ PROP_ROAMING_NO = AND  \ And not roaming?
    DUP IF  \ GSM connection, not roaming. (flags -- flags)
      DROP
      \ Does the access point name equal epc.tmobile.com?
      PROPID_APN $netkey@ S" epc.tmobile.com" COMPARE 0= DUP IF
        DROP
        \ Is the country code for the United States?
        PROPID_MCC #netkey@ 310 = DUP IF
          DROP
	  \ This seems intended to check if the network code is one of several
	  \ values, leaving TRUE on the stack if so else FALSE. However it is
          \ bugged, and actually returns non-zero for any non-zero MNC. For a
          \ list of mobile network codes, see
          \ http://en.wikipedia.org/wiki/List_of_mobile_network_codes_in_the_United_States#MCC_310
          PROPID_MNC #netkey@  \ (-- m)
          DUP 200 =       \ T-Mobile USA  Formerly Smith Bagley, discontinued (m -- m f) 
          SWAP DUP 901 =  \ ? (m f -- f m f)
          SWAP DUP 800 =  \ T-Mobile USA  Formerly SOL Communications (...--f+ m f)
          SWAP DUP 660 =  \ T-Mobile USA  Formerly DigiPhone PCS / DigiPH
          SWAP DUP 580 =  \ T-Mobile USA  Formerly PCS One
          SWAP DUP 310 =  \ T-Mobile USA  Formerly Aerial Communications
          SWAP DUP 270 =  \ T-Mobile USA  Formerly Powertel
          SWAP DUP 250 =  \ T-Mobile USA  Discontinued
          SWAP DUP 220 =  \ T-Mobile USA  Discontinued
          SWAP DUP 970 =  \ Globalstar    Satellite non-GSM
          SWAP DUP 160 =  \ T-Mobile USA  Formerly Omnipoint, discontinued
          SWAP DUP 260 =  \ T-Mobile USA  Standard; formerly Cook Inlet Voicestream
          \ BUG: There's probably a missing SWAP DROP here.
          \ The stack is now (f{11} m f). The following 11 ORs will include 'm'
          \ and omit one test result, instead of ORing all the test results.
          OR OR OR OR OR OR OR OR OR OR OR
        THEN  \ end if MCC == 310 (FALSE if not).
      THEN  \ end if APN == "epc.tmobile.com" (FALSE if not).
    THEN  \ end if GSM and not roaming (FALSE if not).
  THEN  \ end if !LAN
;
