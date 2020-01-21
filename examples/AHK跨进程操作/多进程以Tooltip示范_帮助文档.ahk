#Persistent
FollowTootip("这个将跟`n随至2秒", 2, false)		;~ 参数3为true时等待消失
return

FollowTootip(msg, times, Wait:=true) 
{
	msg := RegExReplace(msg, "\n", "``n")
	code=
	(
		#SingleInstance off
		times = %times%
		stop := A_Tickcount + times * 1000
		Loop {
			ToolTip, %msg%
			Sleep, 1
		} until ((A_Tickcount - stop) > 0)
		Exitapp
		return
	)

    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("AutoHotkey.exe /ErrorStdOut *")
    exec.StdIn.Write(code)
    exec.StdIn.Close()
    if (Wait)
        return exec.StdOut.ReadAll()
}
