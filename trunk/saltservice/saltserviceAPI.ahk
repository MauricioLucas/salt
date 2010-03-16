/********************************************************************************
SALT SERVICE API alias SALTSRVAPI
date 06.03.2010
coded by IsNull 
*********************************************************************************
*/
#Include, IPC.ahk
;namespace :: SALTSRVAPI
SALTSRVAPI_SALTSERVICE_NAME	:= "saltservice.ahk"



bCONNECTION_QUERRY_RECV		:= false




/********************************************************************************
SALTSRVAPI_CONNECT()
/*reverse connection */
*********************************************************************************
*/
SALTSRVAPI_CONNECT(){
global		


	CMD_ := SALTSRVAPI_SALTSERVICE_NAME . " " . DllCall("GetCurrentProcessId")

	IPC_CONNECTION_LISTEN(2,"cb_service_input")
	
	IPC_SYS_HOOK_EVENT("$IPC_CONNECTION_QUERRY","cbRECV_CON_QUERRY")
	
	
	Run, %comspec% /c "%CMD_%",,HIDE|UseErrorLevel,SALTSRVAPI_SALTSERVICE_PID
	If(errorlevel = "ERROR"){
		MsgBox, 16, ERROR, Can't execute: `n%CMD_%
		Return, false
	}
	
	NEW_CON_ID	:= 0 ;this var is filled in callback func cbRECV_CON_QUERRY(msg)
	Loop
	{
		if(bCONNECTION_QUERRY_RECV){
			break
		}
		Sleep, 10
	}

	Return, NEW_CON_ID
} ;******************************************************************************

SALTSRVAPI_QUIT(CON_ID){
global	
	Return, IPC_CONNECTION_QUIT(CON_ID)
}

cb_service_input(msg){
	ToolTip, % "API: "  . msg	
}

cbRECV_CON_QUERRY(TYPE,CON_ID,PID){
global
	NEW_CON_ID := CON_ID
	bCONNECTION_QUERRY_RECV := true
Return, true
}