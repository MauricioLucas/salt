/********************************************************************************
SALT SERVICE
*********************************************************************************
*/

#NoEnv 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
OnExit, EXITHANDLER
;------------------------------------------
#Include, Include\IPC.ahk
#Include, Include\console.ahk
#Include, Include\process.ahk
;------------------------------------------
SALT_SCRIPTNAME     := "saltservice"
SALT_VER            := "0.1 alpha"


; +++++++++++  COMMANDLINE PARAMS  ++++++++++++++++++++++++++++
if 0 < 1    ; we need the service requester PID
{
    ; //MsgBox,16,ERROR, SALT Service: Wrong initialisation! 
    ; //ExitApp
    Gosub, CreateConsoleHandler
}else{
    Loop, %0%       ; fill cmd params in easyer to use Vars.
    {
        Param_%a_index% :=    %a_index% 
    }
} ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


IPC_CONNECTION_LISTEN(2,"cb_msg_input")                             ;// Listen to incomming conections
IPC_SYS_HOOK_EVENT("$IPC_CONNECTION_QUIT","cbRECV_CON_QUIT")        ;// Hook SYS: incomming CONECTION_QUIT msgs 

Process, Exist, %Param_1%                                           ;// caller submits his own PID/ProcName as cmd param
TARGET_PID := errorlevel
if(TARGET_PID){
    connection_id := IPC_CONNECTION_CONNECT(TARGET_PID)             ;// Connect to the caller PID
}else{
    MsgBox,16,%scriptname%, Expected a valid PID, but got %TARGET_PID%! Saltservice is shutting down.
    Exitapp
}
return


;#################### SALT COMMANDLINE ############################
CreateConsoleHandler:

Console_Alloc()
Console_Write("welcome to saltservice " ver "`n")
Console_Write("----------------------------------------`nsalt>> ")

Loop
   {
   ui := Console_GetUserInput()
   
   Console_Write(a_tab a_tab EXEC_CMD(ui) "`nsalt>> ")
   }
Return


/*******************************
handle input
********************************
*/
EXEC_CMD(ui){
global   
   StringSplit,param,ui,%a_space%
   
   if(param1 = "install"){
      ret := "package " param2 " not found!"
   }else if(param1 = "exit" || param1 = "quit" || param1 = "bye"){
      exitapp
   }else if(param1 = "ver"){
      ret := SALT_VER
   }else if(param1 = "help"){
      ret := "no help for you o.0"
   }else{
   ret := "unknown commad: " param1
   }
   Return, ret
}
;#################### COMMANDLINE END ############################

/*********************************************************************************
_SALT_PACKAGES_LIST()
________________________

Currently only a demo implementation. Sends a String (PACKAGELIST) to the client script.
**********************************************************************************
*/
_SALT_PACKAGES_LIST(){
    
PACKAGELIST =
    (LTrim
    packet01
    packet02
    packet03
    ...
    jojo 
    packet containing | as char =)
    pukat ...
    )
    Return, PACKAGELIST
}


/*********************************************************************************
_SALT_PROCESS_MSGQUEUE()
________________________

This function loops until every MSG in the MSG BUFFER is handled.
The Function is usually called when a new msg arrives.
**********************************************************************************
*/
_SALT_PROCESS_MSGQUEUE(){
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
		if(hexascii(PARAM2) == "$SALT_PACKAGES_LIST"){
            IPC_UPAK_ADD(IPC_UPAK_PAK_LIST,"$SALT_PACKAGES_LIST_ANSW")  ; cmd/response Type
            IPC_UPAK_ADD(IPC_UPAK_PAK_LIST,_SALT_PACKAGES_LIST())       ; pakage list
            IPC_UPAK_SEND(PARAM1,IPC_UPAK_PAK_LIST)
		}else{
			MsgBox % "SALTSERVICE: unknown command: " hexascii(PARAM2) "`n FULL MSG STRING:" msg
		}
	}
	bMESAGEPROCESS_RUNNING := false
}

/**************************************************************
All non SYS IPC Messages are handled here.
So, here we implement our own protocol for the salt service.
***************************************************************
*/
cb_msg_input(MSG){
 _SALT_PROCESS_MSGQUEUE()
}

/**************************************************************
Callback Function of SYS EVENT: $IPC_CONNECTION_QUIT
***************************************************************
*/
cbRECV_CON_QUIT(TYPE,CON_ID,PID){
    ; the client wants to disconnect...
    MsgBox salt service is shutting down!
    exitapp
}


EXITHANDLER:
 ;here we handle clean exits
ExitApp