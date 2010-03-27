;start script as a cmd instance
;ahklerner - http://www.autohotkey.com/forum/topic30759.html
Console_Alloc(){
if (!instr(Process_GetModuleFileNameEx(Process_GetCurrentParentProcessID()),GetFileName(COMSPEC))){
		If (A_IsCompiled){
		  Run %comspec% /c ""%A_ScriptFullPath%"", , Hide	
		}else{
			Run %comspec% /c ""%A_AhkPath%" "%A_ScriptFullPath%"", , Hide
		}
		ExitApp
	}
   DllCall("AllocConsole")
}

Console_Write(txt){
   FileAppend, %txt%, con
}

Console_GetUserInput(){
   FileReadLine, l, con, 1
   return l
}
   
GetFileName(pFile){
Loop %pFile%
   Return A_LoopFileName
   }


