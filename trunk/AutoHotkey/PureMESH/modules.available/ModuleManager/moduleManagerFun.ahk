; moduleManagerFun.ahk
/**
 * Functions for ModuleManager for MESH 1.0
 */

/**
 * Discovers the Script BasePath and sets it available as a mCore variable
 */
mm_discoverModuleFolder()
{
	StringSplit, ScriptDir, A_ScriptFullPath, \
	baseDir := ""
	Loop, % ScriptDir0-2
		baseDir .= ( StrLen( baseDir ) ? "\" : "" ) ScriptDir%A_Index%
	
	if ( fs_IsDir( baseDir "\modules.enabled" ) && fs_IsDir( baseDir "\modules.available" ) )
	{
		mCore_set( "ModuleManagerBasePath", baseDir )
	}
	Else
	{
		MsgBox, 16, Error: ModuleManager, No Module Folder found, Quitting.
		ExitApp
	}
}

/**
 * Gets the information from module's sources and prepares for listing
 * Information is to be stored in mCore
 *
 * @param moduleName
 * @return Boolean
 */
mm_getSourceInformation( moduleName )
{
	; Init RegExNeedles if neccessary
	mm_setRegExNeedles()
	
	; Read the source of the module script
	source := fs_fileGetContent( mCore_get( "ModuleManagerBasePath" ) "\modules.available\" moduleName ".ahk" )
	
	RegExNeedles := mCore_get( "ModuleManagerRegExNeedles" )
	
	Loop,Parse,RegExNeedles,`n
	{
		RegExMatch( Source, r := mCore_get( "ModuleManagerRegEx" A_LoopField ), ModuleManager )
	}
	
	mCore_set( moduleName "Author", ModuleManagerAuthor )
	mCore_set( moduleName "Version", ModuleManagerVersion )
	mCore_set( moduleName "Purpose", ModuleManagerPurpose )
	mCore_set( moduleName "Licence", ModuleManagerLicense )
	mCore_set( moduleName "IsEnabled", mm_IsEnabled( moduleName ) )
	
;~ 	Icon|Name of the Module|Version|Author
	MsgBox % ModuleManagerAuthor "/" ModuleManagerVersion "/" ModuleManagerPurpose "/" ModuleManagerLicence "/"
	
;~ 	module
	/*
	Author  := "derRaphael"
	Version := "1.0"
	Purpose := "The Module-Manager allows quickly to enable or disable Modules within the Mesh."
	Licence := "EUPL 1.1 or later"
	i18n    := false
	
	ModuleRequiresMesh    := "EqualOrLater:0.5.2010-01-30"
	ModuleRequiredModules := "fs:EqualOrLater:1.0"
	*/
}

/**
 * Checks if a module is enabled
 */
mm_IsEnabled( moduleName )
{
	return FileExist( mCore_get( "ModuleManagerBasePath" ) "\modules.enabled\" moduleName ".ahk" ) ? true : false
}

/**
 * Initialises a RegEx Collection to find proper strings in a module
 */
mm_setRegExNeedles()
{
	if ( mCore_get( "ModuleManagerRegExInit" ) != 1 )
	{
		RegExNeedlesLoop := "Author,Version,Purpose,Licence,i18n,ModuleRequiresMesh,ModuleRequiredModules"

		Loop,Parse,RegExNeedlesLoop,`,
		{
			RegExNeedle := "im)" A_LoopField "(\s*)?:=(\s*)?""(?P<" A_LoopField ">[^""]+)"""
			mm_RegisterRegExNeedle( A_LoopField, RegExNeedle )
		}
		
		mCore_set( "ModuleManagerRegExInit", 1 )
	}
}

mm_RegisterRegExNeedle( RegExName, RegExNeedle )
{
	mCore_set( "ModuleManagerRegEx" RegExName, RegExNeedle )
	mCore_push( "ModuleManagerRegExNeedles", RegExName )
}