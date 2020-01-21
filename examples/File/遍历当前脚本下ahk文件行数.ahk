
loop, % A_ScriptDir "\*.ahk", 0, 1
{
	;此行为单个ahk文件行数
	Num_validLine := 0
	loop, read, % A_LoopFileLongPath
	{
		if % A_LoopReadLine
			Num_validLine += 1
	}

	if !Num_Line
		Num_Line := % Num_validLine
	else
		Num_Line += Num_validLine
}
msgbox, % Num_Line
return