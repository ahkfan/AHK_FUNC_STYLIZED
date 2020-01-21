;~ example 1

dhw := A_DetectHiddenWindows
DetectHiddenWindows On
Run "%ComSpec%" /k,, Hide, pid
while !(hConsole := WinExist("ahk_pid" pid))
	Sleep 10
DllCall("AttachConsole", "UInt", pid)
DetectHiddenWindows %dhw%
objShell := ComObjCreate("WScript.Shell")
objExec := objShell.Exec("cmd /c ping -n 3 -w 1000 www.google.com")
While !objExec.Status
    Sleep 100
strLine := objExec.StdOut.ReadAll() ;read the output at once
msgbox % strLine
DllCall("FreeConsole")
Process Exist, %pid%
if (ErrorLevel == pid)
	Process Close, %pid%
return


;~ example 2
DllCall("AllocConsole")
hConsole := DllCall("GetConsoleWindow")
WinWait % "ahk_id " hConsole
WinHide
objShell := ComObjCreate("WScript.Shell")
objExec := objShell.Exec("cmd /c ping -n 3 -w 1000 www.google.com")
While !objExec.Status
    Sleep 100
strLine := objExec.StdOut.ReadAll() ;read the output at once
msgbox % strLine
DllCall("FreeConsole")
return