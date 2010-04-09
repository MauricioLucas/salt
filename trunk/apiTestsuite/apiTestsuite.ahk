/*
 * SALT API Testsuite
 * (w) 09 Apr 2010 by derRaphael
 * (c) by the SALT Team
 * 
 * http://salt.autohotkey.com/about.html
 *
 * Version 0.1 
 * Initial release
 *
 */

Gosub, initTestCases

Loop, Parse, testCases, `,, %A_Space%
{
	RegExMatch( A_LoopField, "(?P<Name>\w+)=(?P<Counts>\d+)", test )
	Loop, % testCounts*1
	{
		postData := %testName%%A_Index%
		data     := postQueryToVar( postData )
		length   := ErrorLevel

		msgbox, 0
				, "%testName%" - %A_index% of %testCounts% ( received length: %Length% )
				, % Data	
	}
}


initTestCases:

version1=
(Join`n
`%yaml
---
saltApi:
  cmd: version
)

version2=
(Join`n
`%yaml
---
saltApi:
  version:
)

login1=
(Join`n
`%yaml
---
saltApi:
  cmd: login
  param_0: user
  param_1: pass
)

login2=
(Join`n
`%yaml
---
saltApi:
  cmd: login
  username: user
  password: pass
)

login3=
(Join`n
`%yaml
---
saltApi:
  login:
    username: user
    password: pass
)

testCases := "version=2, login=3"
Return

postQueryToVar( post="" )
{

	static url    := "http://salt.autohotkey.com/ws_api.php"
	static header := "Content-type: text/x-yaml`nContent-Length: "
	
	length := httpQuery( data, url, post, header strlen( post ) )
	VarSetCapacity( data, -1 )
	ErrorLevel := Length
	
	return data
}

