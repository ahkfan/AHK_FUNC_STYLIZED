FileEncoding, utf-8

loop
{
	fileread, abc, % "·��"

	if (errorlevel)
		continue
	ls := []

	Loop, parse, abc, `n, `r
	{
		s := A_LoopField
		if (SubStr(s, -2) = ",ʧ��")
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
		MsgBox, δ���ִ����ļ�
	}

	sleep 500	;~  ��д�ļ�Ƶ�ʱ�̫��
}

return

guiEdit(text)
{
	Gui, destroy
	Gui, add, edit, w300 h50 ReadOnly, % text
	Gui, show, , ErrorInAFileShowEdit
}

