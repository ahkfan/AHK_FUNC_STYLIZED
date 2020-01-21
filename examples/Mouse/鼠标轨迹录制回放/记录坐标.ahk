#SingleInstance force
#NoEnv
CoordMode, mouse, Screen
	hisPath_Str := A_ScriptDir . "\history"
	fileName_str := hisPath_Str . "\" . A_Now . A_MSec . ".his"
	if not FileExist(hisPath_Str)
		FileCreateDir, % hisPath_Str
return

F1::gosub, % (开 := !开) ? "启动记录" : "结束记录"

启动记录:
	左键记录 := true
	文件对象 := FileOpen(fileName_str, "a")
	TrayTip, 开始记录, 1
return

结束记录:
	左键记录 := false
	文件对象.close()
	文件对象 := 
	TrayTip, 结束记录, 1
return

#if 左键记录

~lbutton::
	MouseGetPos, x1, y1
	临时列表 := []
	临时列表.Insert([x1, y1])
	x2 := x1, y2 := y1
	while (GetKeyState("LBUTTON", "P")) {
		MouseGetPos, x1, y1
		if not ((x1 = x2) && (y1 = y2))
		{
			临时列表.Insert([x1, y1])
			x2 := x1, y2 := y1
		}
	}
	临时字符串 := 
	for i, poslist_ls in 临时列表
	{
		if (i = 1)
			临时字符串 .= poslist_ls[1] . "-" . poslist_ls[2]
		else
			临时字符串 .= "|" poslist_ls[1] . "-" . poslist_ls[2]
	}
	文件对象.Write(临时字符串 . "`r`n")
return