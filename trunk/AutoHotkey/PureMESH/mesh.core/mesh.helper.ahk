/**
 * MESH HELPERS COLLECTION
 * Version 1.5.2010-01-30
 *
 */
 
/**
 * Syntax sugar either overrides or preexecutes from a label
 */
mHelper_OverrideOrPreExec()
{
	Global
	if ( ! mHelper_Override() )
		mHelper_PreExec()
}

/**
 * Override - Checks ModuleLabel and overrides the function if neccessary
 */
mHelper_Override()
{
	Global
	
	Local OverrideLabel, TargetLabel
	
	TargetLabel := A_ThisLabel
	
	If ( TargetLabel ==  "" )
	{
		Return
	}
	OverRideLabel := mCore_get( "Overrides" TargetLabel )
	
	If ( StrLen( OverRideLabel ) && IsLabel( OverRideLabel ) )
	{
		Goto, % OverRideLabel
	}
	
	Return false
}

/**
 * PreExec - Checks ModuleLabel and redirects to pre executes if given
 */
mHelper_PreExec()
{
	Global
	
	Local LabelCollection, PreExecLabel, TargetLabel
	
	TargetLabel := A_ThisLabel
	
	If ( TargetLabel == "" && StrLen( mCore_sortStack( "PreExec" TargetLabel ) ) )
	{
		return
	}

	LabelCollection := mCore_get( "PreExec" TargetLabel )
	Loop,Parse,LabelCollection,`n
	{
		PreExecLabel := RegExReplace( A_LoopField, "(^\d+|\W)" )
		If ( IsLabel( PreExecLabel ) )
		{
			Gosub, % PreExecLabel
		}
	}
	Return
}
/**
 * PostExec - Checks ModuleLabel and redirects to post executes if given
 */
mHelper_PostExec()
{
	Global
	
	Local LabelCollection, PostExecLabel, TargetLabel
	
	TargetLabel := A_ThisLabel
	
	If ( TargetLabel == "" && StrLen( mCore_sortStack( "PostExec" TargetLabel ) ) )
	{
		return
	}

	LabelCollection := mCore_get( "PostExec" TargetLabel )
	Loop,Parse,LabelCollection,`n
	{
		PostExecLabel := RegExReplace( A_LoopField, "(^\d+|\W)" )
		If ( IsLabel( PostExecLabel ) )
		{
			Gosub, % PostExecLabel
		}
	}
	Return
}
 
/**
 * These functions should be called from every Module,
 * They check dependencies and if neccessary unregisters the module
 *
 * This function takes the Label it was called from and build the modulename out of it
 */
mHelper_RegisterModule()
{
	Global Author, Purpose, Version, Licence, i18n, ModuleRequiresMesh, extType, extAttr
	
	ModuleLabel := A_ThisLabel

	If ( ! InStr( ModuleLabel, "AutoExecute" ) )
	{
		MsgBox, 16, Error: Moduleload Failure
			, % "The module """ ModuleLabel """ is not in the proper format.`n"
			  . "Mesh requires it to be. Exiting."
		ExitApp
	}

	ModuleName := RegExReplace( ModuleLabel, "i)AutoExecute" )
	
	If ( ModuleRequiresMesh == A_Null )
	{
		MsgBox, 16, Error: Moduleversion Failure
			, % "The module """ ModuleName """ is not in the proper format`n"
			  . "Mesh requires it to be. It will be disabled."
		mHelper_DisableModule( ModuleName )
	}
	
	RegExVersion := "i)((?P<Mode>(Exact|EqualOrLater))\:)?(?P<Major>\d+)"
				  . "\.(?P<Minor>\d+)(\.(?P<Build>\d{4}-\d\d-\d\d))?"
	
	VersionCheck := RegExMatch( ModuleRequiresMesh, RegExVersion, MeshModuleVersion )
	
	if ( ! VersionCheck )
	{
		MsgBox, 16, Error: Moduleversion Failure
			, % "The module """ ModuleName """ is not in the proper format`n"
			  . "Mesh requires it to be. It will be disabled."
		mHelper_DisableModule( ModuleName )
	}

	; Reset VersionMode if neccessary
	If ( MeshModuleVersionMode == "" )
	{
		MeshModuleVersionMode := "EqualOrLater"
	}

	; Set VersionBuild if neccessary
	If ( MeshModuleVersionBuild == "" )
	{
		MeshModuleVersionBuild := ""
	}

	VersionInfo := MeshModuleVersionMode ":" 
				 . MeshModuleVersionMajor "." 
				 . MeshModuleVersionMinor "." 
				 . MeshModuleVersionBuild
				 
	If ( ! mHelper_ModuleVersionIsCompatible( VersionInfo ) )
	{
		MsgBox, 16, Error: Moduleversion Mismatch
			, % "The module """ ModuleName """ is not compatible to current`n"
			  . "Mesh version. It will be deactivated."
		mHelper_DisableModule( ModuleName )
	}
	
	Author  := ( StrLen( Author  ) ? Author  : "Unknown Author" )
	Version := ( StrLen( Version ) ? Version : "Unknown Version" )
	Purpose := ( StrLen( Purpose ) ? Purpose : "Unknown Purpose" )
	Licence := ( StrLen( Licence ) ? Licence : "Unknown Licence" )
	i18n    := "i18n " ( i18n ? "available" : "unavailable" )
	
	; extType 
	; ExtensionTypes may be one of the following:
	;      "core"   - Basic Core functionality of mesh: eg Functions
	;      "module" - Provides additional functionalities 
	extType := ( RegExMatch( extType, "(core|mod(ule)?|ext(ension)?)", _Type ) ? extType : "module" )
	
	; extAttr
	; ExtensionAttributes may be one of the following
	;      "noMenu"     - Provides an attribute to skip the autoabout feature
	;                     This is only allowed when extType euqals core
	extAttr := ( RegExMatch( extAttr, "(noMenu)", _Type ) ? extAttr : "AboutMenu" )
	
	mCore_set( ModuleName "Author",  Author )
	mCore_set( ModuleName "Version", Version )
	mCore_set( ModuleName "Purpose", Purpose )
	mCore_set( ModuleName "Licence", Licence )
	mCore_set( ModuleName "MeshVer", VersionInfo )
	mCore_set( ModuleName "i18n"   , i18n )
	mCore_set( ModuleName "extType", extType )
	mCore_set( ModuleName "extAttr", extAttr )
	
	mConst_RegisterModule( ModuleName )
	
	Author := Version := Purpose := ModuleRequiresMesh := i18n := Licence := extType := extAttr := ""
}

/**
 * Deactivates a given Module and moves it into the Modules.disabled folder
 * Afterwards the Mesh Script reloads itself.
 *
 * @param ModuleName
 * @return boolean
 */
mHelper_DisableModule( ModuleName )
{
	StringSplit, DirName, A_ScriptDir, \
	DirName := ""
	
	Loop, % DirName0-1
	{
		DirName .= ( StrLen( DirName ) ? "\" : "" ) DirName%A_Index%
	}

	if ( ! InStr( FileExist( DirName "\modules.disabled" ), "D" ) )
		FileCreateDir, % DirName "\modules.disabled"
	
	; Move Module
	FileMove, % DirName "\modules.available\" ModuleName ".ahk"
			, % DirName "\modules.disabled\" ModuleName ".ahk", 1
	
	; Move ModuleDirectory if existent
	If ( InStr( FileExist( DirName "\modules.available\" ModuleName ), "D" ) )
	{
		FileMoveDir, % DirName "\modules.available\" ModuleName
				, % DirName "\modules.disabled\" ModuleName, 2
	}

	; Move ModulePriorityFile if Existent
	If ( FileExist( DirName "\modules.enabled\" ModuleName ".prio" ) )
	{
		FileMove, % DirName "\modules.enabled\" ModuleName ".prio"
				, % DirName "\modules.disabled\" ModuleName ".prio", 1
	}
	
	Run, "%A_AhkPath%" /ErrorStdOut "%DirName%\mesh.ahk", % DirName
	ExitApp
}

/**
 * Checks a given VersionInfo against the running Mesh version
 *
 * @param VersionInfo - A string containing a MeshVersion String and matching Criteria
 * @return Boolean
 */
mHelper_ModuleVersionIsCompatible( VersionInfo )
{
	Global MeshVersionMajor, MeshVersionMinor, MeshVersionBuild
	
	RegExVersion := "i)((?P<Mode>(Exact|EqualOrLater))\:)?(?P<Major>\d+)"
				  . "\.(?P<Minor>\d+)(\.(?P<Build>\d{4}-\d\d-\d\d))?"
	
	VersionMatch := RegExMatch( VersionInfo, RegExVersion, MeshModuleVersion )
	
	If ( MeshModuleVersionMode = "Exact" )
	{
		If ( ( MeshModuleVersionMajor == MeshVersionMajor )
		  && ( MeshModuleVersionMinor == MeshVersionMinor )
		  && ( MeshModuleVersionBuild == MeshVersionBuild ) )
		{
			VersionCheck := True
		}
		Else
		{
			VersionCheck := False
		}
	}
	Else If ( MeshModuleVersionMode = "EqualOrLater" )
	{
		If ( ( MeshModuleVersionMajor <= MeshVersionMajor )
		  && ( MeshModuleVersionMinor <= MeshVersionMinor ) )
		{
			VersionCheck := True
		}
		Else
		{
			VersionCheck := False
		}
	}
	
	return % VersionCheck
}
/**
 * Displays a standard MsgBox about registered Modules
 *
 * @param ModuleName - The name of the module
 * @return ExitCode - the pressed Btn
 */
mHelper_AboutModule( ModuleName )
{
	title   := "Autogenerated Module Information:" 
	
	mText   := "About Module:`t""" ModuleName """`n`n"
			 . "For MeshVersion:`t" mCore_get( ModuleName "MeshVer" ) "`n"
			 . "Module Author:`t"   mCore_get( ModuleName "Author"  ) "`n"
			 . "Module Version:`t"  mCore_get( ModuleName "Version" ) "`n"
			 . "Module Licence:`t"  mCore_get( ModuleName "Licence" ) "`n"
			 . "i18n Capable:`t"    mCore_get( ModuleName "i18n"    ) "`n`n"
			 . "Purpose of this module:`n`n" 
			 . mHelper_TextChunks( mCore_get( ModuleName "Purpose" ) )
	
	Return mHelper_MsgBoxIndirect( mText, title, 160 )
}

/**
 * Displays a MsgBox with a custom icon (by default taken from interpreter)
 * 
 * @param lText - The text to display
 * @param lCaption - The caption of the msgbox (defaults to script's name)
 * @param lIcon - Icon number to display
 * @param Source of the icons
 * @param dwStyle - style of the msgbox (just as standard msgbox)
 * @return ExitCode eg BtnPressed
 */
mHelper_MsgBoxIndirect( lText, lCaption = "", lIcon = 159, hTarget = "", dwStyle = 0 )
{
	if ( hTarget == "" )
	{
		hInst := DllCall("GetModuleHandle")
	}
	else
	{
		hInst := DllCall("GetModuleHandle", "Str", hTarget)
	}
	If ( lCaption = "" )
	{
		lCaption := A_ScriptName
	}
	
	; Build the Structure
	VarSetCapacity(MsgBoxParams,40,0)
	NumPut(40,           MsgBoxParams,  0,"uInt") ; StructSize
	NumPut(hInst,        MsgBoxParams,  8,"uInt") ; hInstance
	
	NumPut(&lText,       MsgBoxParams, 12,"uInt") ; lpszText
	NumPut(&lCaption,    MsgBoxParams, 16,"uInt") ; lpszCaption
	; dwStyle just as with standard MsgBox but additionally with OR 0x80 := MB_USEICON
	NumPut(dwStyle|0x80, MsgBoxParams, 20,"uInt") ; dwStyle
	; 160 is the resourcenumber of the AutoHotkeyScriptIcon in interpreter's exe-file
	NumPut(lIcon,        MsgBoxParams, 24,"uInt") ; lpszIcon
	
	return DllCall("MessageBoxIndirect","Uint",&MsgBoxParams)
}
/**
 * Separate TextChunks with a given widt (aka wordwrap)
 *
 * @param mText - the text to be wrapped
 * @param col   - the width to split
 * @param idt   - indentation
 * @return string
 */
mHelper_TextChunks( mText, col = "50", idt = "    " )
{
	Return % idt RegExReplace( mText, "(.{1," col "})( +|$\n?)|(.{1," col "})", "$1$3`n" idt )
}
