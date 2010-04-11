/*
 * SALT webService API Explorer
 *
 * (w) 11 Apr 2010 by derRaphael
 * (c) by the SALT Team
 * 
 * http://salt.autohotkey.com/about.html
 *
 * Version 0.2.1 
 * Initial release
 *
 */

SetTitleMatchMode, 1
	
; set URL
	SaltService := "http://salt.autohotkey.com/ws_api.php"
; set debugMode - neccessary for verifications - DO NOT CHANGE
	saltDebug   := true
	
	if ( saltDebug )
	{
		SaltService .= "?debug=1"
	}

Gui,Font
	Gui,Add,ListView, AltSubmit vApiTests gApiTestsClick w250 Checked h370, saltAPI TestScenario
	Gui,Add,Button, w50 y+10 h20 gLV1SelectAll, &All
	Gui,Add,Button, w50 x+10 h20 gLV1SelectNone, &None
	Gui,Add,Button, w130 x+10 h20 gRunSelectedTests, Run Selected Tests

Gui,Add,Tab2,w450 yp-380 h400 x+10 vTabControl,Test &Details|Test &Log|Test &YAML Source
Gui,Tab,1
	Gui,Add,ListView
		, AltSubmit vApiTestDetails gApiTestDetailsClick -Multi NoSortHdr NoSort Grid w430 h180 hwndhLV2
		, Tests in this Suite
	Gui,Add,GroupBox, y+10 w210 h170, TestYaml Set
	Gui,Add,Edit, vTestYamlSet yp+15 xp+10 w190 h145
	Gui,Add,GroupBox, x+20 yp-15 w210 h170, Expected Result
	Gui,Add,Edit, vTestYamlResponse yp+15 xp+10 w190 h145
	
Gui,Tab,2
	Gui, Font, s9, Lucida Console
	Gui, Add, Edit, w430 h330 hwndhMyEdit vMyEdit ReadOnly
	Gui, Font
	Gui, Add, Button, w50 gClearLog, Clear 
	Gui, Add, Button, w50 x+10 gSaveLog, Save
	Gui, Add, Button, w50 x+10 gAppendLog, Append
	Gui, Font,s12 bold
	Gui, Add, Text, cGreen w50 x+20, OK:
	Gui, Add, Text, cGreen w50 x+20 vSuccessCount, 0
	Gui, Add, Text, cRed w50 x+10, FAIL: 
	Gui, Add, Text, cRed w50 x+10 vFailCount, 0
	Gui, Font
	
Gui,Tab,3
	Gui, Font, s9, Lucida Console
	Gui, Add, Edit, w430 h330 vMyYamlSource -Wrap 0x100000
	Gui, Font
	Gui, Add, Button, w50 gSaveMasterYaml, &Save
	Gui, Add, Button, w50 x+10 gOpenMasterYaml, &Open
	

Gui,Tab
	Gui, Add, StatusBar, hwndhwndBar
		SB_SetParts( 25,50,50,50,350,200 )

Gui,Show, h440, SALT webService API Explorer ( build 11 Apr 2010 )

	SendMessage, 0x0115, 7, 0,, ahk_id %hMyEdit% ;WM_VSCROLL
	AppendToLog( "", hMyEdit)
	hwnd := SB_SetProgress(0,6,"BackgroundGreen cLime")
   SB_SetProgress(0,6,"hide")
	
	Gosub, CountSelectedTests

return

GuiEscape:
GuiClose:
	ExitApp

OpenMasterYaml:
	FileSelectFile, yamlSource, 1
	if ( strLen( yamlSource ) )
		FileRead, yamlSourceData, % yamlSource
		
	GuiControl,,MyYamlSource,% yamlSourceData
	Gosub, UpdateMasterYaml
	
Return

SaveMasterYaml:
	Gosub, UpdateMasterYaml
	FileSelectFile, yamlSource, s16
	yaml_save( yaml )
Return

UpdateMasterYaml:
	GuiControlGet, yamlSourceData,, MyYamlSource
	yaml := yaml_init( yamlSourceData )
	Gosub, AddTestCases
Return

CountSelectedTests:
	Gui,ListView,ApiTests
	TotalSets := SelectedTests := SelectedSets := lv1Idx := 0
	Loop
	{
		lv1Idx := LV_GetNext(lv1Idx, "Checked")
		if ( !lv1Idx )
			break
		LV_GetText( currentTestPath, lv1Idx )
		if ( yaml_get( yaml, currentTestPath ".testSuite" ) != "" )
		{
			SelectedTests += Yaml_get( yaml, currentTestPath ".testSuite.0" )
		} Else {
			SelectedSets += Yaml_get(yaml, currentTestPath ".testYamls.0")
		}
	}
	TotalSets := SelectedSets+SelectedTests
	SB_SetText( "Sets: " SelectedSets, 2)
	SB_SetText( "Tests: " SelectedTests, 3 )
	SB_SetText( "Total:" TotalSets, 4 )
Return

ClearLog:
	GuiControl,,MyEdit, % ""
	GuiControl,,FailCount, 0
	GuiControl,,SuccessCount, 0
Return

AppendLog:
SaveLog:
	msgbox % A_ThisLabel
	options := "s" ( A_ThisLabel = "SaveLog" ? "16" : "" )
	MyLog := ""
	GuiControlGet,MyLog,,MyEdit
	FileSelectFile,LogFile,s16
	if ( StrLen(LogFile) )
	{
		If ( options="s16" && FileExist( LogFile ) )
		{
			FileDelete, % LogFile
		}
		FileAppend, % myLog, % LogFile
	}
Return

LV1SelectAll:
	Gui,ListView,ApiTests
	LV_Modify(0,"Check")
	Gosub, CountSelectedTests
Return

LV1SelectNone:
	Gui,ListView,ApiTests
	LV_Modify(0,"-Check")
	Gosub, CountSelectedTests
Return

SelectDetailsTab:
	GuiControl,Choose,TabControl,1
Return

SelectLogTab:
	GuiControl,Choose,TabControl,2
Return

SelectYamlSourceTab:
	GuiControl,Choose,TabControl,3
Return

RunSelectedTests:
	Gosub, SelectLogTab
   SB_SetProgress(0,6,"show")
	
	Gui,ListView,ApiTests
	lv1Idx := currentCount := 0
	Loop
	{
		lv1Idx := LV_GetNext(lv1Idx, "Checked")
		if ( !lv1Idx )
		{
			break
		}
		LV_GetText( currentTestPath, lv1Idx )
		if ( yaml_get( yaml, currentTestPath ".testSuite" ) != "" )
		{
			; Run tests from Testpath
			Loop, % Yaml_get( yaml, currentTestPath ".testSuite.0" )
			{
				testSetName := yaml_get( yaml, currentTestPath ".testSuite." A_Index )
				SB_SetText( "Exec:" currentTestPath " -> " testSetName, 5 )
				yamlAction  := yaml_get( yaml, currentTestPath ".testSuite." testSetName ".yaml" )
				postYaml    := yaml_dump( yaml, tmpVar := "", currentTestPath ".testYamls." yamlAction  )
				
				AppendToLog( "`r`nCurrentTest: " TestSetName "`r`n" )
				AppendToLog( TimeStamp() "`r`n" )
				AppendToLog( "`r`nSending data: `r`n" RegExReplace( postYaml, "\n", "`r`n") "`r`n" )
				
				data     := postQueryToVar( postYaml )
				length   := ErrorLevel
				
				AppendToLog( "`r`nReceived data (" length " bytes): `r`n" RegExReplace( data, "\n", "`r`n") "`r`n" )
				
				received := yaml_init( data )
				expected := yaml_init( yaml_dump( yaml, tmpVar:="", currentTestPath ".testSuite." testSetName ".expected result" ) )
				
				Gosub, compareResults
				AppendToLog( "`r`nResult check: `r`n" compareResult "`r`n" )
				
				SB_SetProgress(Floor((++currentCount)/totalSets*100),6)
			}
		}
		Else
		{
			; Execute only yamlSets
			Loop, % Yaml_get(yaml, currentTestPath ".testYamls.0")
			{
				yamlSetName := yaml_get( yaml, currentTestPath ".testYamls." A_Index )
				SB_SetText( "Exec:" currentTestPath " -> " yamlSetName, 5 )
				postYaml    := yaml_dump( yaml, tmpVar := "", currentTestPath ".testYamls." yamlSetName )
				
				AppendToLog( "`r`nCurrentTest: " yamlSetName "`r`n" )
				AppendToLog( TimeStamp() "`r`n" )
				AppendToLog( "`r`nSending data: `r`n" RegExReplace( postYaml, "\n", "`r`n") "`r`n" )
				
				data     := postQueryToVar( postYaml )
				length   := ErrorLevel
				
				AppendToLog( "`r`nReceived data (" length " bytes): `r`n" RegExReplace( data, "\n", "`r`n") "`r`n" )
				
				GuiControlGet, SuccessCount
				GuiControl,,SuccessCount, % ++SuccessCount
				
				SB_SetProgress(Floor((++currentCount)/totalSets*100),6)
			}
		}
	}
	SB_SetText( "Result: OK " (SuccessCount!="" ? SuccessCount : 0) " - FAIL " (FailCount!="" ? FailCount : 0) , 5 )
	SB_SetProgress(0,6,"hide")


Return

compareResults:

	expectedResult := y_dump(expected)
	receivedResult := y_dump(received)
	
	found := fail := ""

	Loop,Parse,expectedResult,`n,`r
	{
		if ( ! InStr( receivedResult, A_LoopField ) )
		{
			case := RegExReplace( A_LoopField, "\:\:.*" )
			RegExMatch( receivedResult, "ims`a)" case "[^\r\n]+", found )
			fail .= (StrLen(fail) ? "`r`n" : "" ) "Expected: " A_LoopField "`r`nReceived: " found
			
		}
	}

	if ( strLen(fail) )
	{
		GuiControlGet, FailCount
		GuiControl,,FailCount, % ++FailCount
		CompareResult := "There was an error. Here is a quick dump:`r`n" fail
		
	} else {
		GuiControlGet, SuccessCount
		GuiControl,,SuccessCount, % ++SuccessCount
		CompareResult := "Everything ok."
	}

return

AddTestCases:
	Gui,ListView,ApiTests
	Loop, % Yaml_get( yaml, 0 )
	{
		LV_Add( "Check", yaml_get( yaml, A_Index ) )
	}
Return

AddTestDetails:
	Gui,ListView,ApiTestDetails
	
	LV_Delete()
	
	if ( yaml_get( yaml, yamlPath ".testSuite" ) != "") {
		yamlPath .= ".testSuite"
		LV_ModifyCol(1,"","Tests in this Suite")
	} Else {
		yamlPath .= ".testYamls"
		LV_ModifyCol(1,"","Yamls in this Suite")
	}

	Loop, % Yaml_get( yaml, yamlPath ".0" )
	{
		testName  := yaml_get( yaml, yamlPath "." A_Index )
		extraData := ""
		
		if ( InStr( yamlPath, ".testSuite" ) )
		{
			extraData := " :: " yaml_get( yaml, yamlPath "." testName ".info" )
		}
		LV_Add( "", testName extraData )
	}
Return

ApiTestsClick:
	if ( A_GuiEvent = "DoubleClick" || A_GuiEvent = "Normal" || A_GuiEvent = "K" )
	{
		currentIdx := LV_GetSelectedIdx( "ApiTests" )
		Gui,ListView,ApiTests
		LV_GetText(yamlPath, currentIdx )
		Gosub, AddTestDetails
	}
	Gosub, CountSelectedTests
Return

ApiTestDetailsClick:
	if ( A_GuiEvent = "DoubleClick" || A_GuiEvent = "Normal" || A_GuiEvent = "K" )
	{
		currentIdx := LV_GetSelectedIdx( "ApiTestDetails" )
		
		Gui,ListView,ApiTests
		mainPath := ""
		lv1Row := LV_GetSelectedIdx( "ApiTests" )
		LV_GetText(mainPath, lv1Row )
		
		if ( yaml_get( yaml, mainPath ".testSuite" ) != "" )
		{
			testName := yaml_get( yaml, mainPath ".testSuite." currentIdx )
			testData := yaml_dump( yaml, tmpVar := "", mainPath ".testSuite." testName )
			testYaml := yaml_get( yaml, mainPath ".testSuite." testName ".yaml" )
			expectedResultYaml := yaml_dump( yaml, tmpVar := "", mainPath ".testSuite." testName ".expected result" )
			testYamlData := yaml_dump( yaml, tmpVar := "", mainPath ".testYamls." testYaml )
			
			GuiControl,,TestYamlSet,% testYamlData
			GuiControl,,TestYamlResponse,% expectedResultYaml
			GuiControl,Enable,TestYamlResponse
		}
		else
		{
			testYamlname := yaml_get( yaml, mainPath ".testYamls." currentIdx )
			tmpData := ""
			testYamlData := yaml_dump( yaml, tmpData, mainPath ".testYamls." testYamlname )
			GuiControl,,TestYamlSet,% testYamlData
			GuiControl,,TestYamlResponse,Not available
			GuiControl,Disable,TestYamlResponse
		}
	}
Return

/*
 * UDFs
 */
 
timeStamp()
{
	FormatTime, TimeStamp, % A_Now " L1033", dddd MMMM d, yyyy HH:mm:ss tt
	return TimeStamp
}

apiTest( postData )
{
	FormatTime, TimeStamp, % A_Now " L1033", dddd MMMM d, yyyy HH:mm:ss tt
	AppendToLog( TimeStamp "`r`n" )
	AppendToLog( "`r`nSending data: `r`n" postData "`r`n" )
	
	data     := postQueryToVar( postData )
	length   := ErrorLevel
	
	AppendToLog( "`r`nReceived data: `r`n" RegExReplace( data, "\n", "`r`n") "`r`n" )
}

postQueryToVar( post="" )
{
	global httpQueryOps := "storeHeader"
	global httpQueryHeader
	global SaltService

	static cookies
	static header := "Content-type: text/x-yaml`nContent-Length: "
	
	length := httpQuery( data, SaltService, post, header strlen( post ) cookies )
	VarSetCapacity( data, -1 )
	
	if ( length && cookies = "" )
	{
		cookies := "`n" CookiesFromHeader( HttpQueryHeader )
	}
	
	ErrorLevel := Length
	return data
}

CookiesFromHeader( headerData ) {
   while ( p := RegExMatch( headerData, "sim`a)^Set-Cookie:\s*(?P<Crumb>[^;]+);", Cookie, ( p ? p+StrLen(Cookie) : 1 ) ) )
      Cookies .= ( StrLen( Cookies ) ? " " : "" ) CookieCrumb ";"
   return "Cookie: " Cookies
}


AppendToLog( txt, hEdit="" ) ; by TheGood
{ ; http://www.autohotkey.com/forum/topic56717.html
	
	static WM_GETTEXTLENGTH := 0xE, EM_SETSEL := 0xB1, EM_REPLACESEL := 0xC2, hE
	
	if ( hEdit != "" )
		hE := hEdit
		
	SendMessage, WM_GETTEXTLENGTH, 0, 0,, ahk_id %hE%
	SendMessage, EM_SETSEL, ErrorLevel, ErrorLevel,, ahk_id %hE%
	SendMessage, EM_REPLACESEL, False, &txt,, ahk_id %hE%
}


LV_GetSelectedIdx( SysListView32 = "SystListView321" )
{
	If ( SysListView32 != "" )
	{
		WinGetClass, TestClass, ahk_id %SysListView32%
		If ( RegExMatch( TestClass, "^SysListView32" ) )
		{
			LVhWnd := SysListView32
		}
	}
	if ( SysListView32 = "" )
	{
		SysListView32 := "SysListView321"
	}
	GuiControlGet, LVhWnd, Hwnd, %SysListView32%
	
	LVM_FIRST = 0x1000
	LVM_GETSELECTIONMARK := LVM_FIRST + 66
	SendMessage LVM_GETSELECTIONMARK, 0, 0, , ahk_id %LVhWnd%
	Return ErrorLevel+1
}


y_dump(db,key="",level=0)
{
	static CRLF := "`r`n"
	
	if ( key != "" )
		key := RegExReplace( key, "\.\d" ) "."
		
	if ( (c := yaml_get(db,key 0)) && c+0 = c )
	{
		loop, % c
		{
			currentKey := yaml_get(db,key A_Index)
			displayKey := ( RegExMatch( currentKey, "\W" ) ? """" currentKey """" : currentKey )
			name := key currentKey
			if ( yaml_get(db,name ".0" ) == "" ) {
				out .= name "::" yaml_get(db,name) CRLF
			} else {
				out .= y_dump( db, name )
			}
		}
	}
	Else
	{
		out := ( RegExMatch( ( currentKey := yaml_get(db,key 1) ), "\W" ) ? "'" currentKey "'" : currentKey ) "::" yaml_get(db,currentKey) CRLF
	}
	return out
}

; SB_SetProgress
; (w) by DerRaphael / Released under the Terms of EUPL 1.0 
; see http://ec.europa.eu/idabc/en/document/7330 for details
SB_SetProgress(Value=0,Seg=1,Ops="")
{
   ; Definition of Constants   
   Static SB_GETRECT      := 0x40a      ; (WM_USER:=0x400) + 10
        , SB_GETPARTS     := 0x406
        , SB_PROGRESS                   ; Container for all used hwndBar:Seg:hProgress
        , PBM_SETPOS      := 0x402      ; (WM_USER:=0x400) + 2
        , PBM_SETRANGE32  := 0x406
        , PBM_SETBARCOLOR := 0x409
        , PBM_SETBKCOLOR  := 0x2001 
        , dwStyle         := 0x50000001 ; forced dwStyle WS_CHILD|WS_VISIBLE|PBS_SMOOTH

   ; Find the hWnd of the currentGui's StatusbarControl
   Gui,+LastFound
   ControlGet,hwndBar,hWnd,,msctls_statusbar321

   if (!StrLen(hwndBar)) { 
      rErrorLevel := "FAIL: No StatusBar Control"     ; Drop ErrorLevel on Error
   } else If (Seg<=0) {
      rErrorLevel := "FAIL: Wrong Segment Parameter"  ; Drop ErrorLevel on Error
   } else if (Seg>0) {
      ; Segment count
      SendMessage, SB_GETPARTS, 0, 0,, ahk_id %hwndBar%
      SB_Parts :=  ErrorLevel - 1
      If ((SB_Parts!=0) && (SB_Parts<Seg)) {
         rErrorLevel := "FAIL: Wrong Segment Count"  ; Drop ErrorLevel on Error
      } else {
         ; Get Segment Dimensions in any case, so that the progress control
         ; can be readjusted in position if neccessary
         if (SB_Parts) {
            VarSetCapacity(RECT,16,0)     ; RECT = 4*4 Bytes / 4 Byte <=> Int
            ; Segment Size :: 0-base Index => 1. Element -> #0
            SendMessage,SB_GETRECT,Seg-1,&RECT,,ahk_id %hwndBar%
            If ErrorLevel
               Loop,4
                  n%A_index% := NumGet(RECT,(a_index-1)*4,"Int")
            else
               rErrorLevel := "FAIL: Segmentdimensions" ; Drop ErrorLevel on Error
         } else { ; We dont have any parts, so use the entire statusbar for our progress
            n1 := n2 := 0
            ControlGetPos,,,n3,n4,,ahk_id %hwndBar%
         } ; if SB_Parts

         If (InStr(SB_Progress,":" Seg ":")) {

            hWndProg := (RegExMatch(SB_Progress, hwndBar "\:" seg "\:(?P<hWnd>([^,]+|.+))",p)) ? phWnd :

         } else {

            If (RegExMatch(Ops,"i)-smooth"))
               dwStyle ^= 0x1

            hWndProg := DllCall("CreateWindowEx","uint",0,"str","msctls_progress32"
               ,"uint",0,"uint", dwStyle
               ,"int",0,"int",0,"int",0,"int",0 ; segment-progress :: X/Y/W/H
               ,"uint",DllCall("GetAncestor","uInt",hwndBar,"uInt",1) ; gui hwnd
               ,"uint",0,"uint",0,"uint",0)

            SB_Progress .= (StrLen(SB_Progress) ? "," : "") hwndBar ":" Seg ":" hWndProg

         } ; If InStr Prog <-> Seg

         ; HTML Colors
         Black:=0x000000,Green:=0x008000,Silver:=0xC0C0C0,Lime:=0x00FF00,Gray:=0x808080
         Olive:=0x808000,White:=0xFFFFFF,Yellow:=0xFFFF00,Maroon:=0x800000,Navy:=0x000080
         Red:=0xFF0000,Blue:=0x0000FF,Fuchsia:=0xFF00FF,Aqua:=0x00FFFF

         If (RegExMatch(ops,"i)\bBackground(?P<C>[a-z0-9]+)\b",bg)) {
              if ((strlen(bgC)=6)&&(RegExMatch(bgC,"i)([0-9a-f]{6})")))
                  bgC := "0x" bgC
              else if !(RegExMatch(bgC,"i)^0x([0-9a-f]{1,6})"))
                  bgC := %bgC%
              if (bgC+0!="")
                  SendMessage, PBM_SETBKCOLOR, 0
                      , ((bgC&255)<<16)+(((bgC>>8)&255)<<8)+(bgC>>16) ; BGR
                      ,, ahk_id %hwndProg%
         } ; If RegEx BGC
         If (RegExMatch(ops,"i)\bc(?P<C>[a-z0-9]+)\b",fg)) {
              if ((strlen(fgC)=6)&&(RegExMatch(fgC,"i)([0-9a-f]{6})")))
                  fgC := "0x" fgC
              else if !(RegExMatch(fgC,"i)^0x([0-9a-f]{1,6})"))
                  fgC := %fgC%
              if (fgC+0!="")
                  SendMessage, PBM_SETBARCOLOR, 0
                      , ((fgC&255)<<16)+(((fgC>>8)&255)<<8)+(fgC>>16) ; BGR
                      ,, ahk_id %hwndProg%
         } ; If RegEx FGC

         If ((RegExMatch(ops,"i)(?P<In>[^ ])?range((?P<Lo>\-?\d+)\-(?P<Hi>\-?\d+))?",r)) 
              && (rIn!="-") && (rHi>rLo)) {    ; Set new LowRange and HighRange
              SendMessage,0x406,rLo,rHi,,ahk_id %hWndProg%
         } else if ((rIn="-") || (rLo>rHi)) {  ; restore defaults on remove or invalid values
              SendMessage,0x406,0,100,,ahk_id %hWndProg%
         } ; If RegEx Range
      
         If (RegExMatch(ops,"i)\bEnable\b"))
            Control, Enable,,, ahk_id %hWndProg%
         If (RegExMatch(ops,"i)\bDisable\b"))
            Control, Disable,,, ahk_id %hWndProg%
         If (RegExMatch(ops,"i)\bHide\b"))
            Control, Hide,,, ahk_id %hWndProg%
         If (RegExMatch(ops,"i)\bShow\b"))
            Control, Show,,, ahk_id %hWndProg%

         ControlGetPos,xb,yb,,,,ahk_id %hwndBar%
         ControlMove,,xb+n1,yb+n2,n3-n1,n4-n2,ahk_id %hwndProg%
         SendMessage,PBM_SETPOS,value,0,,ahk_id %hWndProg%

      } ; if Seg greater than count
   } ; if Seg greater zero

   If (regExMatch(rErrorLevel,"^FAIL")) {
      ErrorLevel := rErrorLevel
      Return -1
   } else 
      Return hWndProg

}

#IfWinActive, SALT webService API Explorer
^o::
	Gosub, OpenMasterYaml
return
!l::
	Gosub, SelectLogTab
Return
!d::
	Gosub, SelectDetailsTab
Return
!y::
	Gosub, SelectYamlSourceTab
Return
#IfWinActive

