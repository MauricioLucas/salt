; ModuleSkeleton.ahk
/**
 * Mesh Module Skeleton
 *
 * SYNOPSIS
 *   This File is intendet to show how modules may be created and add into Salt to provide additional 
 *   functionalities which may be triggered by either other modules (dependancy modules) or from
 *   GUI like this one.
 *
 * See ReadMe.txt from Salt for additional information
 *
 * LICENCE
 *   This File is licensed under EUPL 1.1 or later
 *   written Jan 2010 by derRaphael for Salt 1.0
 *
 */
ModuleSkeletonAutoExecute:
	; Initialize Globale Module Variables:
	Author  := "derRaphael"
	Version := "1.0"
	Purpose := "This module demonstrates how to write additional modules and how to attach these into Mesh"
	Licence := "EUPL 1.1 or later"
	i18n    := false
	
	ModuleRequiresMesh    := "EqualOrLater:0.5.2010-01-03"
	ModuleRequiredModules := "fs:EqualOrLater:1.0"
	
	; After Registration, the above variables are stored in the SaltModuleInfo functions
	; and the global variables are deleted
	mHelper_RegisterModule()
	
Return

; My Custom Module Action

; The <ModuleName>LABEL style is not neccessary here, but it avoids errors and leads to a cleaner
; style of programming

ModuleSkeletonDemoAction:
	; Just a demo
	MsgBox This is the ModuleSkeleton-Script Action Demo
Return

; If <ModuleName>Menu Exists, it will be automatically included in the GUI's Modules Menu
ModuleSkeletonMenu:
	; Of course we're not limited to a single Menu here ...
	Menu, MenuModuleSkeleton, Add, ModuleSkeletonDemoAction
Return

; If <ModuleName>About Exists, it will be automatically called from GUIs about Modules page
ModuleSkeletonAbout:
	; Replace with whatever you like
	mHelper_AboutModule( "ModuleSkeleton" )
Return

; If <ModuleName>OnExit Exists, it will be automatically called whenever the script exits
ModuleSkeletonOnExit:
	; Your ExitAction Stuff goes here...
;~ 	MsgBox Module Skeleton ExitAction
Return