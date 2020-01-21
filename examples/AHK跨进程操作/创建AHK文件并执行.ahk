/* 示例代码:
f1::
cmd = send, 111;send, 222
onelines_pro(cmd)
return
 */

onelines_pro(fullcmd_str,subfileName_str := "subscript") {
	/* 基本函数说明：
	 *   多行命令作单行用，无返回值，将在当前脚本同级目录下创建文件
	 *   已知bug，在写入中文时乱码
	 *   无返回值
	 */
	;~ 设定子脚本路径
	lspath_str := % a_scriptdir "\" subfileName_str ".ahk"
	;~ 替换命令中的;注释符为`r`n换行符
	StringReplace, fullcmd_str,fullcmd_str, % ";", % "`r`n", a
	;~ 在行首加上识别标签
	thistime_int := % ";" A_Now
	fullcmd_str := % thistime_int "`r`n" fullcmd_str
	;~ 写入文件
	subfile_obj := FileOpen(lspath_str, "w")
	subfile_obj.Encoding := "UTF-8"
	subfile_obj.Write(fullcmd_str)
	subfile_obj.Close()
	subfile_obj :=
	;~ 确认文件
	Loop {
		if fileexist(lspath_str)
		{
			FileReadLine, firstline, %lspath_str% , 1
			if (firstline = thistime_int)
				break
		}
	}
	;~ 待程序执行完毕函数结束
	RunWait, % lspath_str
}