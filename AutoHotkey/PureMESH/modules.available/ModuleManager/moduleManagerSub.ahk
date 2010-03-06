; moduleManager subroutines

; Initialization for GUI Startup
; eg prepare neccessayr folder and populate ListView
ModuleManagerInit:
	
	; Discover the BasePath Folder and store it in mCore
	mm_discoverModuleFolder()
	; Init all RegExNeedles and store these in mCore
	mm_setRegExNeedles()
	
Return