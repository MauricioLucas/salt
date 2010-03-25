/********************************************************************************
SALT SERVICE API as SALTSRVAPI
date 25.03.2010
coded by IsNull 
*********************************************************************************
*/
#Include, IPC.ahk
;namespace :: SALTSRVAPI
SALTSRVAPI_SALTSERVICE_NAME	:= "saltservice.ahk"
SALTSRVAPI_VER				:= "0.01 under-dev"


bCONNECTION_QUERRY_RECV		:= false
SALTSRVAPI_CON_ID			:= 0


/********************************************************************************
SALTSRVAPI_CONNECT()

Init a (reverse) connection with the saltservice.
---------------------------------------------------------------------------------
RETURN:		CON_ID
*********************************************************************************
*/
SALTSRVAPI_CONNECT(){
global		


	CMD_ := SALTSRVAPI_SALTSERVICE_NAME . " " . DllCall("GetCurrentProcessId")

	IPC_CONNECTION_LISTEN(2,"cb_service_input")
	
	IPC_SYS_HOOK_EVENT("$IPC_CONNECTION_QUERRY","cbRECV_CON_QUERRY")
	
	
	Run, %comspec% /c "%CMD_%",,HIDE|UseErrorLevel
	If(errorlevel = "ERROR"){
		MsgBox, 16, ERROR, Can't execute: `n%CMD_%
		Return, false
	}
	
	SALTSRVAPI_CON_ID	:= 0 ; this var is filled in callback func cbRECV_CON_QUERRY(msg)
	Loop
	{
		if(bCONNECTION_QUERRY_RECV){
			break
		}
		Sleep, 10
	}

	Return, SALTSRVAPI_CON_ID
} ;******************************************************************************

/********************************************************************************
SALTSRVAPI_QUIT()

Kills the existing Connection.
---------------------------------------------------------------------------------
RETURN:		
*********************************************************************************
*/
SALTSRVAPI_QUIT(){
global	
	if(SALTSRVAPI_CON_ID != 0){
		return, IPC_CONNECTION_QUIT(SALTSRVAPI_CON_ID)
	}
} ;******************************************************************************



/********************************************************************************
SALTSRVAPI_GET_PACKAGE_LIST()

---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
RETURN:		List of PACKAGES
*********************************************************************************
*/
SALTSRVAPI_GET_PACKAGE_LIST(){
global	
	;// Are we connected to the saltservice?
	if(SALTSRVAPI_CON_ID == 0){
		return, false				;// not connected!
	}
	if(IPC_CONNECTION_STATE(SALTSRVAPI_CON_ID) != "$IPC_CONNECTED"){
		return, false				;// connection not ready!
	}
	
	; ok, all seems to be ready, now we ask the service:
	; $SALT_PACKAGES_LIST
	IPC_UPAK_ADD(UPACK,"$SALT_PACKAGES_LIST")
	
	M_SALT_PACKAGES_LIST_ANSW := ""

	If(IPC_UPAK_SEND(SALTSRVAPI_CON_ID,UPACK)){
		;// Warten auf antwort des servers:
		While (M_SALT_PACKAGES_LIST_ANSW = "")
		{
			ToolTip, %A_Scriptname% waiting for M_SALT_PACKAGES_LIST_ANSW
			Sleep, 30
		}
		SALTSRVAPI_ANSW := M_SALT_PACKAGES_LIST_ANSW
		M_SALT_PACKAGES_LIST_ANSW := ""
	}else{
		SALTSRVAPI_ANSW := false
	}	
	Return, SALTSRVAPI_ANSW
} ;******************************************************************************

_SALTSRVAPI_PROCESS_MSGQUEUE(){
global

	if(bMESAGEPROCESS_RUNNING = true){
		return
	}else{
		bMESAGEPROCESS_RUNNING := true
	}
	
	SALTSERVICE_COMMANDS	:= "$SALT_PACKAGES_LIST,$SALT_PACKAGES_LIST_ANSW"
	
	While (IPC_MSG_COUNT() > 0) ; loopt solange, bis alle MSGS abgehandelt wurden.
	{
		msg := IPC_MSG_POP()
		StringSplit,PARAM,msg,|	
		;PARAM1 = connection id
		;PARAM2 = command
		;PARAM3+ = params
		if(hexascii(PARAM2) == "$SALT_PACKAGES_LIST_ANSW"){
			M_SALT_PACKAGES_LIST_ANSW :=	hexascii(PARAM3)
		}else{
			MsgBox % "API unknown command: " . hexascii(PARAM2)
		}
	}
	bMESAGEPROCESS_RUNNING := false
}


;callback - if the API gets a message from the service
cb_service_input(msg){
	_SALTSRVAPI_PROCESS_MSGQUEUE()
}

;callback - SYS EVENT HOOK: if the API gets a connection request
cbRECV_CON_QUERRY(TYPE,CON_ID,PID){
global
	SALTSRVAPI_CON_ID := CON_ID
	bCONNECTION_QUERRY_RECV := true
Return, true
}