
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Run, runme.ahk, %A_ScriptDir%
Run, %comspec% /c runme.ahk, %A_ScriptDir%
exitapp