/*
 * SALT API Login - Logout Test
 * (w) 09 Apr 2010 by derRaphael
 * (c) by the SALT Team
 * 
 * http://salt.autohotkey.com/about.html
 *
 * Version 0.1 
 * Initial release
 *
 */

	SuiteName   := "SALT API Login - Logout Test"
;~ 	SaltService := "http://salt.ahk.com/ws_api.php"
	SaltService := "http://salt.autohotkey.com/ws_api.php"
	Gosub, staticYamlInit

	Gui, Font, s9, Lucida Console
	Gui, Add, Edit, r20 w500 hwndhMyEdit vMyEdit ReadOnly
	Gui, Show,, %SuiteName%

	SendMessage, 0x0115, 7, 0,, ahk_id %hMyEdit% ;WM_VSCROLL

	AppendToLog( "Starting TestSuite '" SuiteName "'.`r`n", hMyEdit)
	
	Loop,Parse,TestSuite,`,
		apiTest( %A_LoopField% )

	AppendToLog( "TestSuite '" SuiteName "' completed.`r`n", hMyEdit)
return

staticYamlInit:

version=
(Join`r`n
`%yaml
---
saltApi:
  version:
)

login=
(Join`r`n
`%yaml
---
saltApi:
  login:
    username: testuser
    password: secretPassword
)

invalidLogin=
(Join`r`n
`%yaml
---
saltApi:
  login:
    username: hacker
    password: 1337
)

logout=
(Join`r`n
`%yaml
---
saltApi:
  logout:
)

testSuite := "login,version,logout,version,invalidLogin,logout"

Return

GuiClose:
GuiEscape:
	ExitApp

apiTest( testName )
{
	FormatTime, TimeStamp, % A_Now " L1033", dddd MMMM d, yyyy HH:mm:ss tt
	AppendToLog( TimeStamp "`r`n" )
	AppendToLog( "`r`nSending data: `r`n" testName "`r`n" )
	
	data     := postQueryToVar( testName )
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