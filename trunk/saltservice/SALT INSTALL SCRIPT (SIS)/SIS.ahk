/*********************************************************
SIS SALT Install Skript
**********************************************************
*/

SIS_COMMAND_LIST	:= "#copy,#regwrite"


; SALT_INSTALL_SCRIPT as SIS

;###############################################################################
; START TESTING STUB
if("" = (err := SIS_COMPILE("install.sis", SIS_COMPILED))){
		MsgBox,64,compilation successfull, SIS compiled with no errors:`n`n%SIS_COMPILED%
		SIS_INSTALL(SIS_COMPILED)
}else{
		MsgBox,16,compilation fail, There are some errors:`n`n%err%`n`n-----------------------`n`n%SIS_COMPILED%
}
ExitApp

; END TESTING STUB
;##############################################################################





/********************************************************************

"Compiles" a SI Script, which mean error handling and path expansion
*********************************************************************
*/
SIS_COMPILE(SIS_INSTRUCTIONS_PATH, ByRef COMPILED_SCRIPT){
global 	SIS_COMMAND_LIST
	COMPILE_RESULT	:= ""
	COMPILED_SCRIPT	:= ""
	
	if("" = FileExist(SIS_INSTRUCTIONS_PATH)){
		Return, "Can't find SIS file!: '" SIS_INSTRUCTIONS_PATH "'"
	}
	FileRead,SIS_INSTRUCTIONS, % SIS_INSTRUCTIONS_PATH
	if(ErrorLevel){
		Return, "Can't read SIS file!: '" SIS_INSTRUCTIONS_PATH "'"
	}

	SplitPath,SIS_INSTRUCTIONS_PATH,,SIS_SOURCE_DIR
	if(SIS_SOURCE_DIR = ""){
		SIS_SOURCE_DIR := A_WorkingDir
	}
	SIS_SOURCE_DIR	.= "\data"
	if("" = FileExist(SIS_SOURCE_DIR)){
		Return, "Can't find source folder!: '" SIS_SOURCE_DIR "'"
	}
	
	Loop, Parse, SIS_INSTRUCTIONS, `n,`r
	{
		SIS_LINE := RegExReplace(a_loopfield,"([\t, ]//.*)")
		SIS_LINE := RegExReplace(SIS_LINE,"(^//.*)")
		if(RegExMatch(SIS_LINE,"(#.*?) *,",cmd)){
			StringSplit,param,SIS_LINE,`,
			if cmd1 in % SIS_COMMAND_LIST
			{
				if(cmd1 = "#copy"){
					source_copy_path := SIS_SOURCE_DIR . strclean(param2)
					if(FileExist(source_copy_path) = ""){
						;// source data not found!
						COMPILE_RESULT .= "{" a_index "}  source data not found! " source_copy_path  "`n"
					}else if (InStr(FileExist(source_copy_path), "D")){
						; its a folder... we have to explode it :)
						loop, %Source_copy_path%\*.*,0,1
						{
							if(instr(A_LoopFileFullPath,".svn")){	; // Little hack to omit svn hidden folders o.0
								Continue
							}
							StringReplace,source_data,A_LoopFileFullPath,%SIS_SOURCE_DIR%,,ALL
							param3 := strclean(param3), param3 := (param3 = "\") ? "" : param3
							COMPILED_SCRIPT .= cmd1 ", " source_data ", " strclean(param3) "\" A_LoopFileName "`n"
						}
					}Else{
						;its a single file
						COMPILED_SCRIPT .= SIS_LINE	"`n" ; we let that line as is.
					}
				}Else{
					COMPILED_SCRIPT .= SIS_LINE "`n"
				}
			}else{
				COMPILE_RESULT .= "{" a_index "} unknown command: " cmd1  "`n"
			}
		}else{
			if(SIS_LINE != ""){
				COMPILE_RESULT .= "{" a_index "} wrong syntax " SIS_LINE  "`n"
			}
		}
	}
	return, COMPILE_RESULT
} ;*********************************************************************

/***********************************************************************
strclean(str)
removoes leading/ending spaces and tabs
*************************************************************************
*/
strclean(str){
	str := RegExReplace(str,"(^[\t, ]*)")
	str := RegExReplace(str,"([\t, ]*$)")
	Return, str
} ;**********************************************************************




/************************************************************************

*************************************************************************
*/
SIS_INSTALL(SIS){
	;SIS_COMPILE(SIS, SIS)
	Loop, Parse, SIS, `n,`r
	{
		if(A_LoopField = ""){
			Continue
		}
		MsgBox % A_LoopField
	}

} ;**********************************************************************