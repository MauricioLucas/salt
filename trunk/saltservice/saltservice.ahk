/********************************************************************************
SALT SERVICE
*********************************************************************************
*/

#NoEnv 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
OnExit, EXITHANDLER
#Include, IPC.ahk

scriptname := "saltservice"

; +++++++++++  COMMANDLINE PARAMS  ++++++++++++++++++++++++++++
if 0 < 1    ; we need the service requester PID
{
    MsgBox,16,ERROR, SALT Service: Wrong initialisation! 
    ExitApp
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



cb_msg_input(MSG){
 ToolTip, %MSG%   
}

cbRECV_CON_QUIT(TYPE,CON_ID,PID){
    ; the client wants to disconnect...
    MsgBox salt service is shutting down!
    exitapp
}


EXITHANDLER:
 ;here we handle clean exits
ExitApp