/**
 * MESH BaseGui
 *
 * SYNOPSIS
 *   The BaseGui provides a Basic Gui for MESH 1.0
 *   It also shows how to extend the Mesh-Script with custom pre and post Execute Extensions
 *
 * See ReadMe.txt from Mesh for additional information
 *
 * LICENCE
 *   This File is licensed under EUPL 1.1 or later
 *   written Jan 2010 by derRaphael for Mesh 1.0
 *
 */
BaseGuiAutoExecute:
	; Initialize Globale Module Variables:
	Author  := "derRaphael"
	Version := "1.0"
	Purpose := "The BaseGui-Script provides a Basic Gui for Mesh 1.0. It also shows how "
			 . "to extend the Framework with custom pre and post Execute Extensions"
	Licence := "EUPL 1.1 or later"
	i18n    := false
	
	ModuleRequiresMesh := "EqualOrLater:1.0.2010-01-23"
	
	; After Registration, the above variables are stored in the MeshModuleInfo functions
	; and the global variables are deleted
	mHelper_RegisterModule()
	
	; Since this module is being executed prior to any other Gui Action, we may
	; define custome modules and simply extend the baseCallers with a defined priority
	mConst_RegisterPostExec( "MeshGuiAutoExec", "BaseGuiInit" )
	
	; Register Menus
	Gosub, BaseGuiAdditionalMenus
	
	; The PreExec attaches the FileMenu
	mConst_RegisterPreExec( "MeshGuiMenu", "BaseGuiMenuPreExec" )
	; The PostExec attaches the ExitMenu
	mConst_RegisterPostExec( "MeshGuiMenu", "BaseGuiMenuPostExec" )
	
Return

BaseGuiMenuPreExec:
	mHelper_OverrideOrPreExec()
	
	Menu, MeshMenu, Add, &File, :BaseGuiFileMenu
	
	mHelper_PostExec()
Return

BaseGuiMenuPostExec:
	mHelper_OverrideOrPreExec()
	
	Menu, MeshMenu, Add, &Exit, :BaseGuiExitMenu
	
	mHelper_PostExec()
Return

; This function will be called when main GUI initializes as a postExec function
BaseGuiInit:
	mHelper_OverrideOrPreExec()
	
	Gui, %MeshGui%: Default
	Gui, Add, Tab2, hwndTabs w400 h250, TODO
	Gui, Tab, 1
	Gui, Add, Edit, w380 h180 vTODO, %TODO%
	Gui, Tab
	
	; This call invokes the subroutine BaseInit to Script's Main
	; AutoExecute Section
	mConst_RegisterPostExec( "AutoExecute", "BaseInit" )
	
	mHelper_PostExec()
Return

BaseInit:
	TODO := fs_FileGetContent( A_ScriptDir "\..\TODO.txt" )
	GuiControl,,TODO, % TODO
Return

BaseGuiAdditionalMenus:
	mHelper_OverrideOrPreExec()
	
	Menu, BaseGuiFileMenu, Add, Open, BaseGuiOpenFile
	Menu, BaseGuiFileMenu, Add, Save, BaseGuiSaveFile
	
	Menu, BaseGuiExitMenu, Add, Exit, MeshGuiClose
	
	mHelper_PostExec()
Return

BaseGuiOpenFile:
	mHelper_OverrideOrPreExec()
	
	MsgBox BaseGUIFileOpen
	
	mHelper_PostExec()
Return

BaseGuiSaveFile:
	mHelper_OverrideOrPreExec()
		
	MsgBox BaseGUIFileSave
	
	mHelper_PostExec()
Return

; If <ModuleName>OnExit Exists, it will be automatically called whenever the script exits
BaseGuiOnExit:
	; Your ExitAction Stuff goes here...
Return
