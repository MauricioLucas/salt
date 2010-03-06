; This Script is part of the mesh moduleManager
; GuiStuff goes here
/**
 *
 */
ModuleManagerGuiInit:
	mConst_RegisterGui( "ModuleManagerGui" )
Return

/**
 * Builds the Gui and adds all neccessary controls
 */
ModuleManagerGuiBuild:
	; Destroy old GUI before building the new one
	Gosub, ModuleManagerGuiClose
	; Build the GUI
	Gui, %ModuleManagerGui%: Default
	Gui,Add,ListView,w500 h300 vModuleManagerListView, Icon|Name of the Module|Version|Author
	Gui,Add,Statusbar
Return

/**
 * Finally show the gui
 */
ModuleManagerGuiShow:
	; Shows the Modulemanager GUI
	Gui, %ModuleManagerGui%: Default
	Gui, Show,, % "ModuleManager " mCore_get( "ModuleManager" Version )
	
	mm_getSourceInformation( "ModuleManager" )
Return

/**
 * Gui gets closed action
 */
ModuleManagerGuiClose:
	Gui, %ModuleManagerGui%: Default
	; Destroy the gui
	Gui, Destroy
Return

/**
 * User hits Escape while window active action
 */
ModuleManagerGuiEscape:
	Gosub, ModuleManagerGuiClose
Return

/**
 * Resize action
 */
ModuleManagerGuiSize:
	Gui, %ModuleManagerGui%: Default
Return