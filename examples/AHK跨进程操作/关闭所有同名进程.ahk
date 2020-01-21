#SingleInstance force
ProExit("AutoHotkey.exe")
ExitApp
return

ProExit(proName) 
{	;关闭所有同名进程
	loop
	{
		Process, Exist, % proName
		if ErrorLevel
			Process, Close, % proName
		else
			break
	}
}
