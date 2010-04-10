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
SALT_VER            := "0.2 alpha"

SALT_CREDITS=
(
######  SALT TEAM  ##################################
    AutoHotKeyiT    yaml Parser
    DerRaphael      webfrontend, backend strategies
    IsNull          saltservice
#####################################################
)

SALT_CACHE          := A_ScriptDir "\core\cache"
SALT_DATA_P	        := A_ScriptDir "\data"
SALT_IMAGES_P	    := SALT_DATA_P "\images"
SALT_RESLIST        := A_ScriptDir "\core\resources.txt"
SALT_API_URI        := "/ws_api.php"
;-------------------------------------------------------
SALT_REPO_CON   := ""   ; connection id to the current repo
SALT_REPO_URL   := ""   ; url of current repo
;------------------------------------------------------------------
;------------------------------------------------------------------

; +++++++++++  COMMANDLINE PARAMS  ++++++++++++++++++++++++++++
if 0 < 1
{
    Gosub, SALT_GUI_MAIN
}else{
    Loop, %0%       ; fill cmd params in easyer to use Vars.
    {
        Param_%a_index% :=    %a_index% 
    }
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
} ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
return



SALT_GUI_MAIN:

    GUI, add, Tab2, w600 h500,  Browse Repository|Installed Packages|Manage Repositorys
    
    ;//#######---------- Repo Browser -----------#######
    GUI, Tab, 1
    
    ;----------------------------- Filter Controls
    GUI, add, Groupbox,x20 y50 w550 h85, Filter
    GUI, Add, Picture,xp+35 yp-5 , % SALT_IMAGES_P "\search_icon_small.png"
    GUI, Add, TEXT, xp yp+20, Shown Types:
    GUI, Add, TEXT, xp+170 yp, Hidden Types:
    Gui, Add, ListBox, x30 yp+15 w150 h50 vVisible HwndVisible_ID gLB_Visible, Netzwerk|STdLib|Games|Tools
    Gui, Add, ListBox, xp+170 yp w150 h50 vInVisible hwndInVisible_ID gLB_InVisible

    GUI, Add, TEXT, x500 w80 xp+170 yp-15, search:
    GUI, Add, EDIT, xp+40 yp w150 vFILTER_SEARCH gFILTER_SEARCH
    GUI, Add, Checkbox, xp yp+30 vCHK_PK_NAME, Paket Name
    GUI, Add, Checkbox, xp yp+20 vCHK_PK_DESCR, Description
    ;-----------------------------    
    GUI, add, ListView, x20 yp+40 w300 h330 vREPO_BROWSER_LIST, Package Name | Type
    GUI, add, text, xp+320 yp, Selected Package Detail:
    
    ;//#######---------- Installed Packages Browser -----------#######
    GUI, Tab, 2
    GUI, add, ListView, x20 y50 w550 h350 vINSTALLED_BROWSER_LIST, Package Name | Version | Type
    
    ;//#######---------- Repository Manager  -----------#######
    GUI, Tab, 3
    GUI, add, ListView, x20 y50 w550 h350 vREPOSITORY_LIST, Repo URL | Status
    LV_ModifyCol(1,400)
    GUI, show, , % SALT_SCRIPTNAME " " SALT_VER

    yml := SALT_READ_REPOSITORYS()
    SALT_G_REPOSITORYS_UPDATE(yml)
return

GuiClose:
Exitapp

LB_Visible:
If (A_GuiEvent = "DoubleClick"){
	NewItemList := ""
	ControlGet, ItemList, List,,, ahk_id %Visible_ID%
	Loop, parse, ItemList, `n
	{
		if (a_index !=  A_EventInfo){
			NewItemList .= A_LoopField . "|"
		}else{
			GuiControl,,InVisible,%A_LoopField%
		}
	}
	GuiControl,,Visible,|%NewItemList%
	;SESAM_GUI_PUT_GPK(1)
	}
return

LB_InVisible:
If (A_GuiEvent = "DoubleClick"){
	NewItemList := ""
	ControlGet, ItemList, List,,, ahk_id %InVisible_ID%
	Loop, parse, ItemList, `n
	{
		if (a_index !=  A_EventInfo){
			NewItemList .= A_LoopField . "|"
		}else{
			GuiControl,,Visible,%A_LoopField%
		}
	}
	GuiControl,,InVisible,|%NewItemList%
	;SESAM_GUI_PUT_GPK(1)
	}
return
FILTER_SEARCH:
return


/************************************************************************
SALT_READ_REPOSITORYS()

Reads the local plain text file and imports repos in a 
yml Repo Object.
*************************************************************************
*/
SALT_READ_REPOSITORYS(){
global
    YML_REPOSITORY :=   Yaml_Init("") ;create empty yaml
    cnt := 0

    Loop, read, % SALT_RESLIST, `n,`r
    {
        if(A_LoopReadLine = ""){   ;// TODO: here Continue comments too. 
            Continue
        }
        ++cnt
        Yaml_Add(YML_REPOSITORY,"repositorys.repo" cnt ".url",A_LoopReadLine) 
        Yaml_Add(YML_REPOSITORY,"repositorys.repo" cnt ".status","unchecked") 
    }

    Return, YML_REPOSITORY
} ;*************************************************************************

SALT_G_REPOSITORYS_UPDATE(YML_REPOSITORY){
    Loop, % Yaml_GET(YML_REPOSITORY,"repositorys.0") 
    {
        URL := Yaml_GETs(YML_REPOSITORY,"repositorys.repo" a_index ".url") 
        STA := Yaml_GETs(YML_REPOSITORY,"repositorys.repo" a_index ".status") 
        LV_Add("",URL,STA)
    }
}

Yaml_GETs(yml,key=""){
    str := Yaml_GET(yml,key) 
    if(substr(str,1,1) = "'"){
        StringTrimLeft,str,str,1
        StringTrimRight,str,str,1
    }
    Return, str
}
/*
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
        httpQueryOps := "storeHeader"
        length := httpQuery(data, A_LoopReadLine SALT_API_URI "/help", postdata)
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

_SALT_CONNECT_BACKEND_CLI(BackendURI,uUser,uPass){
global
    BackendURI := BackendURI = "salt" ? "http://salt.autohotkey.com" : BackendURI
    if(_SALT_CONNECT_BACKEND(BackendURI,uUser,uPass)){
        Return "login successful:`n`tCON_ID: " SALT_REPO_CON
    }else{
        Return, "`tlogin failed"
    }
}



_SALT_DOWNLOAD_CLI(lpszUrl,dest){
global httpQueryOps    

    if(lpszUrl = "test"){
        lpszUrl := "http://dl.securityvision.ch/4789213741029347129837/data.bin"
    }

    httpQueryOps := "updateSize"
    data := ""
    Console_Write("Starting downloading...`n")
    SetTimer,SHOW_DL_PROGRESS,500
    length   := httpQuery(data,lpszUrl)
    if(!length || length = -1){
        Return, "Can't download: " lpszUrl
    }else{
        if (write_bin(data,dest,length)!=1){
           Return, "There was an Error!"
        }else{
            Console_Write("`t 100%`n")
          Return, "Downloaded and saved as " dest
        }
    }
}

SHOW_DL_PROGRESS:
    Console_Write("`t" Round(100 / HttpQueryFullSize * HttpQueryCurrentSize,0) "%`t"  HttpQueryCurrentSize "/" HttpQueryFullSize "`n")
Return

_SALT_BAKEND_GET_VER_CLI(BackendURI){
global    
    BackendURI := BackendURI = "" ? SALT_REPO_URL : BackendURI
    
   if(!(ver := _SALT_BAKEND_GET_VER(BackendURI))){
        Return, "`tconnection failed"
    }else{
        Return, "`tbackend-api-ver: " ver
    }
}
*/


/*********************************************************************************
_SALT_CONNECT_BACKEND(user,pass)
________________________


**********************************************************************************
*/
_SALT_CONNECT_BACKEND(BackendURI,uUser,uPass){
global     
    ;URL      := "http://salt.autohotkey.com/login.html"
    URL := BackendURI "/login.html"
    httpQueryOps := "storeHeader"
    postdata := "username=" uUser "&no=password&password=" uPass
    length := httpQuery(html, URL, postdata)
    SALT_REPO_CON   := ""   
    SALT_REPO_URL   := ""
    if(!length || length = -1){
        Return false
    }else{
        RegExMatch(CookiesFromHeader(HttpQueryHeader),"SALT=(.*?);",out)
        SALT_REPO_CON   := out1   
        SALT_REPO_URL   := BackendURI
    }
    Return, true
} ;*******************************************************************************
CookiesFromHeader( headerData ) { ; by dR
   while ( p := RegExMatch( headerData, "sim`a)^Set-Cookie:\s*(?P<Crumb>[^;]+);", Cookie, ( p ? p+StrLen(Cookie) : 1 ) ) )
      Cookies .= ( StrLen( Cookies ) ? " " : "" ) CookieCrumb ";"
   return Cookies
}

_SALT_BAKEND_GET_VER(BackendURI){
global
    URL := BackendURI . SALT_API_URI
    length := httpQuery(yaml, URL "version")
    VarSetCapacity(yaml, -1 )
    if(!length || length = -1){
        Return, false
    }
    yml := Yaml_Init(yaml)
    Return, Yaml_Save(yml)
}

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