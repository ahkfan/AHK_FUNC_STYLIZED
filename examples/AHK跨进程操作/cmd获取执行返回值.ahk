ld_cmd_Ret(cmd){
    local objShell, objExec
    DllCall("AllocConsole")
    objShell := ComObjCreate("WScript.Shell")
    objExec := objShell.Exec(cmd)
    While (NOT(objExec.Status))
        Sleep 1
    strLine := objExec.StdOut.ReadAll() ;read the output at once

    DllCall("FreeConsole")
    objShell := ""
	objExec := ""
    return strLine
}