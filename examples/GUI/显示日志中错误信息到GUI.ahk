FileEncoding, utf-8

loop
{
	fileread, abc, % "路径"

	if (errorlevel)
		continue
	ls := []

	Loop, parse, abc, `n, `r
	{
		s := A_LoopField
		if (SubStr(s, -2) = ",失败")
		{
			ls.push(s)
		}
	}

	if ls.Length()
	{
		ss := ""

		for i, v in ls
			ss .= "v" . "`n"

		guiEdit(ss)

		DetectHiddenWindows, off

		Loop {
		} until not (winexist("ErrorInAFileShowEdit"))

		Gui, destroy

	}
	else
	{
		MsgBox, 未发现错误文件
	}

	sleep 500	;~  读写文件频率别太高
}

return

guiEdit(text)
{
	Gui, destroy
	Gui, add, edit, w300 h50 ReadOnly, % text
	Gui, show, , ErrorInAFileShowEdit
}

