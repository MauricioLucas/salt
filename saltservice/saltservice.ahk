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
#Include, Include\httpquery.ahk
#Include, Include\yaml.ahk
;------------------------------------------
SALT_SCRIPTNAME     := "saltservice"
SALT_VER            := "0.1 alpha"

SALT_CREDITS=
(
######  SALT TEAM  ##################################
    HotKeyiT        yaml Parser
    DerRaphael      webfrontend, backend strategies
    IsNull          saltservice
#####################################################
)

SALT_CACHE          := A_ScriptDir "\core\cache"
SALT_RESLIST        := A_ScriptDir "\core\resources.txt"

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
Console_Write("welcome to " SALT_SCRIPTNAME " - " SALT_VER "`n")
Console_Write("----------------------------------------`nsalt>> ")

Loop
{
    ui := Console_GetUserInput()
    Console_Write(a_tab a_tab EXEC_CMD(ui) "`nsalt>> ")
}
Return

;#################### COMMANDLINE START ############################

/*******************************
handle CLI input
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
    }else if(param1 = "update"){
        ret := _SALT_UPDATE_CLI()
    }else if(param1 = "download"){
        ret := _SALT_DOWNLOAD(param2,SALT_CACHE "\dummy.exe")
    }else if(param1 = "credits"){
        Console_Write("`n" SALT_CREDITS "`n")
    }else{
        ret := "unknown commad: " param1
    }
   Return, ret
}
;#################### COMMANDLINE END ############################


_SALT_UPDATE_CLI(){
global    
    UPDATE_LOG := ""
    Loop, read, % SALT_RESLIST, `n,`r
    {
        if(A_LoopReadLine = ""){   ;// TODO: here Continue comments too. 
            Continue
        }
        Console_Write(A_LoopReadLine ":`n")
        postdata := "data[set]=blup&data[set2][sub1]=sub1&data[set2][sub2]=sub2"
        length := httpQuery(data, A_LoopReadLine "help", postdata)
        VarSetCapacity(data, -1 )
        if(!length || length = -1){
            Console_Write("`t update failed!`n")
            Continue
        }
        yml := Yaml_Init(data)
        Console_Write("`t" Yaml_Save(yml) "`n")
    }
    Return, UPDATE_LOG
}


_SALT_DOWNLOAD(lpszUrl,dest){
global httpQueryOps    

    if(lpszUrl = "test"){
        lpszUrl := "http://dl.securityvision.ch/4789213741029347129837/data.bin"
    }

    httpQueryOps := "updateSize"
    data := ""
    Console_Write("Starting downloading...`n")
    SetTimer,SHOW_DL_PROGRESS,500
    length   := httpQuery(data,lpszUrl)
    if (write_bin(data,dest,length)!=1){
       Return, "There was an Error!"
    }else{
        Console_Write("`t 100%`n")
      Return, "Downloaded and saved as " dest
    }
}

SHOW_DL_PROGRESS:
    Console_Write("`t" Round(100 / HttpQueryFullSize * HttpQueryCurrentSize,0) "%`t"  HttpQueryCurrentSize "/" HttpQueryFullSize "`n")
Return

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




;-----------------------------------------------

write_bin(byref bin,filename,size){
   h := DllCall("CreateFile","str",filename,"Uint",0x40000000
            ,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
   IfEqual h,-1, SetEnv, ErrorLevel, -1
   IfNotEqual ErrorLevel,0,ExitApp ; couldn't create the file
   r := DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
   IfEqual r,0, SetEnv, ErrorLevel, -3
   IfNotEqual ErrorLevel,0, {
      t = %ErrorLevel%              ; save ErrorLevel to be returned
      DllCall("CloseHandle", "Uint", h)
      ErrorLevel = %t%              ; return seek error
   }
   result := DllCall("WriteFile","UInt",h,"Str",bin,"UInt"
               ,size,"UInt *",Written,"UInt",0)
   h := DllCall("CloseHandle", "Uint", h)
   return, 1
}