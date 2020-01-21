FileEncoding, utf-8


;~ 改以下3个路径
logFile := "C:\Users\CUSong\Desktop\thread_worker\thread_worker.log"

srcDir := ""	;~ 源文件最顶层路径文件夹

desDir := ""	;~ 复制到的文件夹

FileRead, logText, % logFile
pathDict:= {}
Loop, parse, logText, `n, `r
{
	If RegExMatch(A_LoopField, "恢复文件：(.+)\,失败$", ret)
	{
		pathDict[ret1] := ""
	}
}

errorText := ""
Loop, files, % srcDir "\*", FR
{
	if pathDict.HasKey(A_LoopFileName)
	{
		;~ FileCopy 1 为复制时覆盖已有的文件, 0 忽略

		copyWith(A_LoopFileLongPath, desDir, A_LoopFileName)
		errorText .= A_LoopFileLongPath "`r`n"
	}
}
FileAppend, % errorText, % logFile . "-" . A_Now . A_MSec ".txt"
return

copyWith(srcPath, des, fileName)
{
	ls := StrSplit(srcPath, "\")

	dir := ls[ls.length() - 1]

	dir2 := des "\" dir

	while not FileExist(dir2)
		FileCreateDir, % dir2

	FileCopy, % srcPath, % dir2 "\" fileName, 0

}




