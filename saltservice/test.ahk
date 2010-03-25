/********************************************************************************
SALT SERVICE Test
*********************************************************************************
*/
#NoEnv 
#Persistent
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
OnExit, EXITHANDLER

#Include, saltserviceAPI.ahk 


CON_ID := SALTSRVAPI_CONNECT()		;//Reverse Connection to saltservice (start saltservice and let the service connect to us)


msgbox % "saltservice hat mir folgendes geschickt: `n`n" . SALTSRVAPI_GET_PACKAGE_LIST()

Exitapp


#Q::
	ExitApp
Return



EXITHANDLER:
	SALTSRVAPI_QUIT()		;// KIll Connection
Exitapp