; i18n.ahk
/**
 * SALT Module Skeleton
 *
 * SYNOPSIS
 *   This Script provides internationalization capabilities for ModuleUsage in Salt
 *
 * See ReadMe.txt from Salt for additional information
 *
 * LICENCE
 *   This File is licensed under EUPL 1.1 or later
 *   written Jan 2010 by derRaphael for Salt 1.0
 *
 */
i18nAutoExecute:
	; Initialize Globale Module Variables:
	Author  := "derRaphael"
	Version := "1.0"
	Purpose := "This module enables i18n for each script and module used in the salt framework."
			 . "See modules\BaseGui.ahk or modules\ModuleManager.ahk for usage details"
	Licence := "EUPL 1.1 or later"
	i18n    := true
	
	ModuleRequiresSalt := "EqualOrLater:1.1.2010-01-23"
	
	; After Registration, the above variables are stored in the SaltModuleInfo functions
	; and the global variables are deleted
	SaltHelper_RegisterModule()
	
Return

; If <ModuleName>OnExit Exists, it will be automatically called whenever the script exits
i18nSkeletonOnExit:
	; Your ExitAction Stuff goes here...
;~ 	MsgBox Module Skeleton ExitAction
Return

i18nGetModulesList:
Return

i18nReadTranslations:
Return


; Translator function
__( Module_i18nToken )
{
	culture := mCore_set( "UserDefaultCulture", "en-US" )
	
	return % ( RegExMatch( Module_i18nToken, "^(?P<Name>[^:]+):(?P<Token>.+)$", Module ) )
		   ? mCore_get( "i18n_" ModuleName "_" ModuleToken )
		   : Module_i18nToken
}
