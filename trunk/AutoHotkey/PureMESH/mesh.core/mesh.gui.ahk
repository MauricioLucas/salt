/**
 * MESH GUI
 * version 1.0
 *
 * This Script provides basic functionality of the Gui. It is not intended to show a 
 * gui, just to register its labels and provide either override or pre/post execution
 * extensions.
 * The Apps Gui itself is to be included as a module. See modules.available\BaseGui.ahk 
 * for more information.
 *
 *   written Jan-2010 by derRaphael
 *   Distributed under the EUPL 1.1 or later
 *
 * see the ReadMe.txt of MESH for more informations
 */
 
MeshGuiAutoExec:
	mHelper_OverrideOrPreExec()

	; Register Final MeshGui
	mConst_RegisterGui( "MeshGui" )
	; Assign GuiVariables
	
	Gosub, GlobalGuiInit
	Gui, %MeshGui%:Default
	
	mHelper_PostExec()
Return

MeshGuiShow:
	mHelper_OverrideOrPreExec()

	Gui, %MeshGui%:Default
	Gui, Show,, Mesh %MeshVersion%
	
	mHelper_PostExec()
Return

MeshGuiMenu:
	mHelper_OverrideOrPreExec()
	
	AvailModules := mCore_get( "AvailModules" )
	Loop,Parse,AvailModules,`n
	{
		If ( IsLabel( A_LoopField "Menu" ) )
		{
			Gosub, % A_LoopField "Menu"
			Menu, % "Menu" A_LoopField, Add
		}
		if ( mCore_get( A_LoopField "extAttr" ) != "noMenu" && mCore_get( A_LoopField "extType" ) != "core" )
		{
			Menu, % "Menu" A_LoopField, Add, About "%A_LoopField%"
				, % ( IsLabel( A_LoopField "About" ) ) ? A_LoopField "About" : "GenericModuleAbout"
			Menu, MeshModules, Add, % A_LoopField,  % ":Menu" A_LoopField
		}
	}
	If ( StrLen( AvailModules ) )
	{
		Menu, MeshMenu, Add, &Modules, :MeshModules
	}
	mHelper_PostExec()
Return

MeshGuiMenuAttach:
	mHelper_OverrideOrPreExec()
		
	If ( StrLen( mCore_get( "AvailModules" ) ) != 0 )
	{
		Gui, Menu, MeshMenu
	}
	
	mHelper_PostExec()
Return

MeshGuiDefaultInit:
	mHelper_OverrideOrPreExec()
		
	; Initialite Gui
	Gosub, MeshGuiAutoExec
	; Initialize Menus for Mesh
	Gosub, MeshGuiMenu
	; Attach Menus to Mesh's GUI
	Gosub, MeshGuiMenuAttach
	; Show the base Gui
	Gosub, MeshGuiShow
	
	mHelper_PostExec()
Return

; The following subroutine allow dynamically add Guis, without bothering about their ID
; all is needed is to call mHelper_RegisterGui( Name ) which will create a global
; variable name which stores the gui number
; so in order to add a new gui, the following calls are neccessary:

; > mHelper_RegisterGui( "MyGuiName" )
; > Gui, %MyGuiName%: Default
; > .. normal GuiCreation goes here
; > Return

; Since the following will also Create a GuiLabel "MyGuiName" all Subroutines such as 
; GuiEscape, GuiClose, GuiSize etc need to be name accordingly. In this example:

; > MyGuiNameClose:
; > ... close stuff
; > Return
; > MyGuiNameEscape:
; > ... Escape stuff
; > Return

; and so on.

GlobalGuiInit:
	mHelper_OverrideOrPreExec()
	
	Guis := mCore_get( "Guis" )
	Loop,Parse,Guis,`n
	{
		%A_LoopField% := A_Index
		Gui, % A_Index ":+Label" A_LoopField
	}

	mHelper_PostExec()
Return

GenericModuleAbout:
	ModuleName := ""
	
	if ( RegExMatch( A_ThisMenuItem, """(?P<Name>[^""]+)""", Module ) )
	{
		mHelper_AboutModule( ModuleName )
	}
Return

; The following SubRoutines are not meant to contain any other calls as the ones
; provided. All extra functionality is delivered by modules.

MeshGuiDropFiles:
	mHelper_OverrideOrPreExec()
	mHelper_PostExec()
Return

MeshGuiContextMenu:
	mHelper_OverrideOrPreExec()
	mHelper_PostExec()
Return

MeshGuiSize:
	mHelper_OverrideOrPreExec()
	mHelper_PostExec()
Return

MeshGuiEscape:
	mHelper_OverrideOrPreExec()
	mHelper_PostExec()
Return

MeshGuiClose:
	mHelper_OverrideOrPreExec()
	mHelper_PostExec()
	ExitApp
Return