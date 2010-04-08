/********************************************************************************
SALT SERVICE GUI
*********************************************************************************
*/
#NoEnv 
#Persistent
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
OnExit, EXITHANDLER

#Include, saltserviceAPI.ahk 

SGUI_IMAGES_PATH	:= A_ScriptDir "\data\logos"

CON_ID := SALTSRVAPI_CONNECT()		;//Reverse Connection to saltservice (start saltservice and let the service connect to us)


GUI, -caption +border
GUI, add, Picture, , % SGUI_IMAGES_PATH "\logo_full.png"
GUI, show

msgbox % "saltservice hat mir folgendes geschickt: `n`n" . SALTSRVAPI_GET_PACKAGE_LIST()

Exitapp


#Q::
	ExitApp
Return



EXITHANDLER:
	SALTSRVAPI_QUIT()		;// KIll Connection
Exitapp