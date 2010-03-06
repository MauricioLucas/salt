; StdLibFiles.ahk
/**
 * MESH StdLibFiles
 *
 * SYNOPSIS
 *  This modules enlists all StdLib Files and tries to detect their proper versions
 *
 * See ReadMe.txt from Mesh for additional information
 *
 * LICENCE
 *   This File is licensed under EUPL 1.1 or later
 *   written Jan 2010 by derRaphael for Salt 1.0
 *
 */
StdLibFilesAutoExecute:
	; Initialize Globale Module Variables:
	Author  := "derRaphael"
	Version := "1.0"
	Purpose := "This modules enlists all StdLib Files and tries to detect their proper versions"
	Licence := "EUPL 1.1 or later"
	i18n    := false
	
	ModuleRequiresMesh    := "EqualOrLater:0.5.2010-01-30"
	ModuleRequiredModules := ""
	
	; After Registration, the above variables are stored in the MeshModuleInfo functions
	; and the global variables are deleted
	mHelper_RegisterModule()
	
Return

; My Custom Module Action

; The <ModuleName>LABEL style is not neccessary here, but it avoids errors and leads to a cleaner
; style of programming

StdLibFilesDemoAction:
	; Just a demo
	MsgBox This is the ModuleSkeleton-Script Action Demo
Return

; If <ModuleName>Menu Exists, it will be automatically included in the GUI's Modules Menu
StdLibFilesMenu:
	; Of course we're not limited to a single Menu here ...
	Menu, MenuStdLibFiles, Add, StdLibFilesDemoAction
Return

; If <ModuleName>About Exists, it will be automatically called from GUIs about Modules page
StdLibFilesAbout:
	; Replace with whatever you like
	mHelper_AboutModule( "StdLibFiles" )
Return

; If <ModuleName>OnExit Exists, it will be automatically called whenever the script exits
StdLibFilesOnExit:
	; Your ExitAction Stuff goes here...
;~ 	MsgBox Module Skeleton ExitAction
Return