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

MsgBox Connected to server with conid: %con_id%

Return


#Q::
	ExitApp
Return



EXITHANDLER:
	SALTSRVAPI_QUIT(CON_ID)		;// KIll Connection
Exitapp