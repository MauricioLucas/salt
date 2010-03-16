/***************************************************************

****************************************************************
*/

m_IPC_MSG_QUEUE			:= "" ;//Internal msg queue
m_IPC_MSG_QUEUE_COUNT	:= 0

m_IPC_LISTEN_MODE		:= 2
m_IPC_CALLBACK_FUNC 	:= ""

m_IPC_CON_ID_LIST 		:= ""  ;// connected proc list
m_IPC_CONID_COUNT		:= 0

m_IPC_PACKETID_RECV_COUNTER	:= 0


IPC_SYS_COMMAND_LIST	:= "$IPC_CONNECTION_QUERRY,$IPC_CONNECTION_ACK,$IPC_CONNECTION_REM,$IPC_CONNECTION_QUIT"



/*******************
connection struct

m_IPC_CON_[CON_ID]_PID
m_IPC_CON_[CON_ID]_STATE

********************
*/


/*****************************************************
mode
allow the script to recevie msgs
1 = accept all [1],[2],[3]
2 = accept connection request PAK, [2],[3]
3 = accept connected PAK [3]

;--------------
NOTE: modes arn't implemented for now...
******************************************************
*/
IPC_CONNECTION_LISTEN(mode=2,callbackfunction=""){
global
	m_IPC_LISTEN_MODE := mode
	if(callbackfunction != ""){
		m_IPC_CALLBACK_FUNC  := callbackfunction
	}
	OnMessage(0x4a, "_IPC_Receive_WM_COPYDATA")
}

/*
	IPC SYS MSG are hidden from the user - here you can set hooks to let IPC notifiy if a specified 
	SYS MSG is incomming:
*/
IPC_SYS_HOOK_EVENT(EVENT_NAME,CALLBACK_FUNC){
global 	
	if EVENT_NAME in %IPC_SYS_COMMAND_LIST%
	{
		m_HOOKcb_%EVENT_NAME% := CALLBACK_FUNC
		Return, true
	}
	Return, false
}


IPC_CONNECTION_CONNECT(TARGET_PID){
	
	
	$IPC_NEW_CONID	:=  _IPC_CREATENEW_CONID()
	$PIC_SYS_MSG	:= "$IPC_CONNECTION_QUERRY|" . $IPC_NEW_CONID . "|" . DllCall("GetCurrentProcessId") ;$IPC_CONNECTION_QUERRY|[CON_ID]|[PID]
	
	
	_IPC_CONNECTION_REGISTER($IPC_NEW_CONID,TARGET_PID)
	
	IPC_CONNECTION_STATE($IPC_NEW_CONID,"$IPC_WAIT")
	state := _IPC_Send_WM_COPYDATA($PIC_SYS_MSG, TARGET_PID)
	if(!instr(state,"FAIL")){
		;// Wait for connection ACK/REM
		Loop
		{
			if(IPC_CONNECTION_STATE($IPC_NEW_CONID) = "$IPC_CONNECTED"){
				Break
			}else if(IPC_CONNECTION_STATE($IPC_NEW_CONID) = "$IPC_REM"){ 
				Break
			}
			Sleep, 10
		}
		if(IPC_CONNECTION_STATE($IPC_NEW_CONID) = "$IPC_REM"){
			_IPC_CONNECTION_LIST_REM($IPC_NEW_CONID)
			$IPC_NEW_CONID := false
		}
	}else{
		MsgBox,16, ERROR, % "Process " DllCall("GetCurrentProcessId") "(me) can't  connect to " TARGET_PID " Reason:`n" . state
		_IPC_CONNECTION_LIST_REM($IPC_NEW_CONID)
		$IPC_NEW_CONID := false
	}
	Return, $IPC_NEW_CONID
}

IPC_CONNECTIONS_LIST(){
global m_IPC_CON_ID_LIST
	Return, m_IPC_CON_ID_LIST
}
IPC_CONNECTION_PID(CON_ID){
global
	Return, m_IPC_CON_%CON_ID%_PID
}
/*
	set and get con_state
	---------------------- 
	enum states
	{
	$IPC_CONNECTED
	$IPC_DISCONNECTED 
	$IPC_REM
	$IPC_WAIT
	}
	
*/
IPC_CONNECTION_STATE(CON_ID,new_state = ""){
global	
	if(new_state != ""){
		m_IPC_CON_%CON_ID%_STATE := new_state
	}
	Return, m_IPC_CON_%CON_ID%_STATE
}

;************** private function with _ prefix

IPC_CONNECTION_QUIT(CON_ID){
	
	$PIC_SYS_MSG	:= "$IPC_CONNECTION_QUIT|" . CON_ID
	
	IPC_CONNECTION_STATE(CON_ID,"$IPC_DISCONNECTED")
	_IPC_CONNECTION_LIST_REM(CON_ID)
	
	TARGET_PID := IPC_CONNECTION_PID(CON_ID)
	state := _IPC_Send_WM_COPYDATA($PIC_SYS_MSG, TARGET_PID)
	if(instr(state,"FAIL")){
		MsgBox CONNECTION ERROR, EEROR_MSG: %state%
		Return, false
	}
	
	Return, true
}


/*
Create Systemwide unique ConID
*/
_IPC_CREATENEW_CONID(){
global m_IPC_CONID_COUNT
	++m_IPC_CONID_COUNT
	return,  DllCall("GetCurrentProcessId")  . "_" . m_IPC_CONID_COUNT
}

_IPC_CONNECTION_REGISTER(CON_ID,TARGET_PID){
global
	m_IPC_CON_%CON_ID%_PID		:= TARGET_PID
	m_IPC_CON_%CON_ID%_STATE	:= "CONNECTED"
	_IPC_CONNECTION_LIST_ADD(CON_ID)
}

_IPC_CONNECTION_LIST_ADD(CON_ID){
global m_IPC_CON_ID_LIST	
	m_IPC_CON_ID_LIST .= CON_ID "`n"
	return
}

/*
	remove item from list.
*/
_IPC_CONNECTION_LIST_REM(CON_ID){
global m_IPC_CON_ID_LIST	

	m_IPC_CON_ID_LIST_NEW := ""

	Loop,parse, m_IPC_CON_ID_LIST,`n,`r
	{
		if(A_LoopField = ""){
			Continue
		}
		if(A_LoopField != CON_ID){
			m_IPC_CON_ID_LIST_NEW .= A_LoopField . "`n"
		}
	}
	m_IPC_CON_ID_LIST := m_IPC_CON_ID_LIST_NEW
	return
}

/********************************************************************************
SALTSRVAPI_Receive_WM_COPYDATA(wParam, lParam)
NOTE: This code was taken from AHK HELP
*********************************************************************************
*/
_IPC_Receive_WM_COPYDATA(wParam, lParam){
global SALTSRVAPI_CALLBACKFUNC

    StringAddress := NumGet(lParam + 8)  ; lParam+8 is the address of CopyDataStruct's lpData member.
    StringLength := DllCall("lstrlen", UInt, StringAddress)
	
    if (StringLength <= 0){
        ;blank string or error
    }else{
        VarSetCapacity(MSG_sITEM, StringLength)
        DllCall("lstrcpy", "str", MSG_sITEM, "uint", StringAddress)  ; Copy the string out of the structure.
		
		if(!IPC_PROCESS_SYSDATA(MSG_sITEM)){	;// if it's not a system msg...
			IPC_MSG_PUSH(MSG_sITEM)
			if(m_IPC_CALLBACK_FUNC != ""){
				%m_IPC_CALLBACK_FUNC%(MSG_sITEM)
			}
		}
    }
    return true
} ;******************************************************************************

/********************************************************************************

Here we handle the hidden SYS IPC Events.

$IPC_CONNECTION_QUERRY|[CON_ID]|[PID]
$IPC_CONNECTION_QUIT|[CON_ID]
$IPC_CONNECTION_ACK|[CON_ID]|[PID]
$IPC_CONNECTION_REM|[CON_ID]|[PID]
*********************************************************************************
*/
IPC_PROCESS_SYSDATA(MSG_sITEM){
global IPC_SYS_COMMAND_LIST, $SYS_LOG
	StringSplit,IPC_MSG_ITEM,MSG_sITEM,|
	
	$SYS_LOG .= MSG_sITEM  . "`n"
	ToolTip, % $SYS_LOG
	
	if IPC_MSG_ITEM1 in %IPC_SYS_COMMAND_LIST%
	{
		;----handle SYS HOOKs -----------------------------------
		if(m_HOOKcb_%IPC_MSG_ITEM1% != ""){ ;// is a hook defined?
			;yes it is!
			callback := m_HOOKcb_%IPC_MSG_ITEM1%
			if(!%callback%(IPC_MSG_ITEM1,IPC_MSG_ITEM2,IPC_MSG_ITEM3)){
			 ;if callback func returns false, we cancel handling of this SYS EVENT here
			 Return, false
			}
		}
		;-------------------------------------------------------
		if(IPC_MSG_ITEM1 = "$IPC_CONNECTION_QUERRY"){
		
		;// berechtingungen pr�fen, ob connetion zulassen

		;// �berpr�fen ob schon mit dieser PID connected
		
		;// ok connection akzeptieren.
		$PIC_SYS_MSG	:= "$IPC_CONNECTION_ACK|" . IPC_MSG_ITEM2 . "|" . DllCall("GetCurrentProcessId") ;$IPC_CONNECTION_QUERRY|[CON_ID]|[PID]
		_IPC_CONNECTION_REGISTER(IPC_MSG_ITEM2,IPC_MSG_ITEM3)
		IPC_CONNECTION_STATE(IPC_MSG_ITEM2,"$IPC_CONNECTED")
		_IPC_Send_WM_COPYDATA($PIC_SYS_MSG, Target_PID)
		
		}else if(IPC_MSG_ITEM1 = "$IPC_CONNECTION_ACK"){
			
			;unser request wurde akzeptiert
			IPC_CONNECTION_STATE(IPC_MSG_ITEM2,"$IPC_CONNECTED")
		}else if(IPC_MSG_ITEM1 = "$IPC_CONNECTION_REM"){
			;unser request wurde abgelehnt
			IPC_CONNECTION_STATE(IPC_MSG_ITEM2,"$IPC_REM")
		}else if(IPC_MSG_ITEM1 = "$IPC_CONNECTION_QUIT"){
			IPC_CONNECTION_STATE(IPC_MSG_ITEM2,"$IPC_REM")
		}
		Return, true
	}else{
		Return, false
	}
}


/********************************************************************************
Send_WM_COPYDATA
NOTE: This code was taken from AHK HELP
*********************************************************************************
*/
_IPC_Send_WM_COPYDATA(ByRef StringToSend, Target_PID){
	
	Process, Exist, %Target_PID%
	if(!errorlevel){
		Return "FAIL - Target Process not found! (" . Target_PID . ")"
	}
	
	;--------------------------------------------------------------------------
    VarSetCapacity(CopyDataStruct, 12, 0)  ; Set up the structure's memory area.
    ; First set the structure's cbData member to the size of the string, including its zero terminator:
    NumPut(StrLen(StringToSend) + 1, CopyDataStruct, 4)  ; OS requires that this be done.
    NumPut(&StringToSend, CopyDataStruct, 8)  ; Set lpData to point to the string itself.
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SendMessage, 0x4a, 0, &CopyDataStruct,, ahk_pid %Target_PID%  ; 0x4a is WM_COPYDATA. Must use Send not Post.
    DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
    SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
    return ErrorLevel  ; Return SendMessage's reply back to our caller.
} ;********************************************************************************





;// IPC MSG QUEUE
/**************
Format of MSG_ITEM:

PACKETid|CONNECTIONID|(hex)MSG 
***************
*/

IPC_MSG_PUSH(MSG_sITEM){
global m_IPC_MSG_QUEUE, m_IPC_MSG_QUEUE_COUNT, m_IPC_PACKETID_RECV_COUNTER
	If(MSG != ""){
		m_IPC_PACKETID_RECV_COUNTER++
		m_IPC_MSG_QUEUE := m_IPC_PACKETID_RECV_COUNTER . "|" . MSG_sITEM . "`n" . m_IPC_MSG_QUEUE
		m_IPC_MSG_QUEUE_COUNT++
		return, true
	}
}
IPC_MSG_POP(CONNECTIONID=0){
global m_IPC_MSG_QUEUE, m_IPC_MSG_QUEUE_COUNT

bdone 				:= false
MSG_sITEM			:= ""
m_IPC_MSG_QUEUE_new := ""
	If (IPC_MSG_COUNT() > 1){
		Loop, parse, m_IPC_MSG_QUEUE,`n,`r
		{
			if(A_LoopField = ""){
				Continue
			}
			StringSplit,MSG_ITEM,A_LoopField,|
			
			if(((!CONNECTIONID) || (MSG_ITEM2 = CONNECTIONID)) && (!bdone)){
				MSG_sITEM := A_LoopField
				bdone := true
				m_IPC_MSG_QUEUE_COUNT--
			}else{
				m_IPC_MSG_QUEUE_new := A_LoopField "`n" . m_IPC_MSG_QUEUE_new
			}
		}
		m_IPC_MSG_QUEUE := m_IPC_MSG_QUEUE_new
		Return, MSG_sITEM
	}else{
		Return, false
	}
}

IPC_MSG_COUNT(){
global m_IPC_MSG_QUEUE_COUNT
	Return, m_IPC_MSG_QUEUE_COUNT
}


;//********** get *********************
IPC_MSGITEM_GET_PAKID(MSG_sITEM){
	StringSplit,MSG_ITEM,MSG_sITEM,|
	Return, hexascii(MSG_ITEM1)
}
IPC_MSGITEM_GET_CONID(MSG_sITEM){
	StringSplit,MSG_ITEM,MSG_sITEM,|
	Return, hexascii(MSG_ITEM2)
}
IPC_MSGITEM_GET_MSG(MSG_sITEM){
	StringSplit,MSG_ITEM,MSG_sITEM,|
	Return, hexascii(MSG_ITEM3)
}

IPC_CREATE_MSGsITEM(CONid, MSG){
	Return, CONid . asciihex(MSG)
}


/**********************************************
	ascii --> hex
***********************************************
*/
asciihex(str,size=0){
	setformat,integer,h
	if(!size){
		size := StrLen(str)
	}
   Loop, % size
   {
      zahl := substr(numget(str,a_index-1,"uchar"),3)
      if (strlen(zahl)<2)
         zahl := "0" . zahl
      resultat .= zahl
   }
   return, resultat
} ;********************************************


/**********************************************
	von hex to ascii
***********************************************
*/
hexascii(var){
    size := strlen(var) / 2
    Loop, % size
    {
      hex := SubStr(var,A_Index*2-1,2)
      asc .= chr( "0x" . hex)
    }
	return, asc
} ;********************************************