;wjm = %1%  ;取拖放文件尺寸
;fgdx := 99 * 1024 * 1024 ;设置分割大小
;FileGetSize, wjcc, %wjm% ;获取分割文件大小
;fgsl := (wjcc//fgdx) + 1 ;判断分割份数

wjm = %1%
fgdx := 99 * 1024 * 1024 ;设置分割大小
FileGetSize, wjcc, %wjm% ;获取分割文件大小
fgsl := (wjcc//fgdx) + 1 ;判断分割份数

SplitPath, wjm, name ;取文件名称
bat = copy /b ;批处理变量
cs := fgsl - 1 ;循环次数减1
Loop, %cs% ;循环输出到批处理变量
{
bat = %bat% "FD%fgsl%-%A_Index%-%name%"+
}
bat = %bat%"FD%fgsl%-%fgsl%-%name%" "%name%"
FileAppend,
(
)%bat%,%A_ScriptDir%\%name%.bat ;输出批处理


FDiv.byNum( wjm ;进行分割
					, A_ScriptDir
					, fgsl)

/* 示例
;~ 分割
MsgBox, % FDiv.byNum(A_Desktop "\Xshell.zip"
					, A_Desktop
					, 5)

;~ 合并
MsgBox, % FDiv.join("FD5-5-Xshell.zip"
					, "C:\Users\CUSong\Desktop\合并后")


*/

class FDiv {
	;~ 程序默认的最大缓冲区尺寸, 默认 12MB
	static buffSize := 99 * 1024 * 1024

	setBuffSize(newSize) {
		this.buffSize := size
	}

	__getFileName(src) {

		if instr(src, ":")
			SplitPath, src, fName
		else
			fName := src

		return fName
	}

	byNum(src, toDir, num) {

		/* 将文件平均分割成有限数量
			参1: 源文件
			参2: 保存到的路径
			参3: 分隔的数量
			返回值: 	0, 分割成功
					1, 源文件不存在,
					2, 目标文件夹不存在
					3, 此路径下可能已有相关的被分割过文件, 只检测第一个
		*/
		local fSrc, fTo
		, fName
		, buff, buffSize
		, l, pl, prl, nowl, ll, nl

		if ("" = FileExist(src))
			return 1

		if not instr(FileExist(toDir), "D")
			return 2

		if (SubStr(toDir, -0, 1) = "\")
			toDir := SubStr(toDir, 1, -1)

		fName := this.__getFileName(src)

		Loop, files, % toDir . "\FD*" . fName, F
			return 3


		fSrc 		:= FileOpen(src, "r")

		buffSize 	:= this.buffSize

		l   		:= fSrc.Length

		pl  		:= Ceil(l / num)

		prl 		:= pl // buffSize

		VarSetCapacity(buff, buffSize)

		loop, % num
		{
			fTo := FileOpen(toDir . "\FD" . num . "-" . A_Index . "-" . fName, "w")
            
			ll := l - fSrc.pos
			ll := (ll < pl) ? ll : pl	;~ 每块长度

			if (prl) {	;~ 被分割文件尺寸大于缓冲区尺寸

				Loop, % prl
				{
					nl := (ll >= buffSize) ? buffSize : ll
					fSrc.RawRead(&buff, nl)
					fTo.RawWrite(&buff, nl)
					ll -= buffSize

				}

				if (ll) {
					fSrc.RawRead(&buff, ll)
					fTo.RawWrite(&buff, ll)
				}

			} else {	;~ 被分割文件尺寸小于缓冲区尺寸

				fSrc.RawRead(&buff, ll)
				fTo.RawWrite(&buff, ll)
			}

			fTo.close()
		}

		fSrc.close()
	}

	bySize(src, toDir, perSize) {
		/* 将文件分割为指定长度

		*/

	}

	join(src, toDir) {
		/* 将分割过的文件全部合并输出到toDir, 文件名在部分中

			参1: 被分割的文件, 任意一个部分, 要保证目录下有所有的文件部分
			参2: 输出的文件夹

			返回值:
				0 成功
				1 src文件不存在
				2 不是有效的分割文件(文件名不是 FD数n-数i- 这样的格式为非法, 数n 为 总分割数量, 数i 为 序号)
				3 分割文件存在缺失
				4 输出的文件夹不存在
				5 输出文件在toDir目录下已存在
		*/
		local isDived, ls, path, dFName, dDir, buff


		if (not(FileExist(src)))
			return 1

		path :=  Instr(src, ":") ? src : (A_WorkingDir "\" src)

		SplitPath, path, dFName, dDir

		isDived := RegExMatch(dFName, "^FD(\d+)\-\d+\-(.+)$", r)

		if (not(isDived))
			return 2

		l     := r1		;~ 被分割数量
		fName := r2		;~ 输出的文件名
			:= toDir . "\" . fName

		ls := []
		loop, % l
		{
			iDiv := dDir . "\FD" . l . "-" . A_Index . "-" . fName
			if FileExist(iDiv)
				ls.push(iDiv)
			else
				return 3
		}

		if not instr(FileExist(toDir), "D")
			return 4

		if FileExist(fPath)
			return 5

		buffSize := this.buffSize
		VarSetCapacity(buff, buffSize)

		fOut := FileOpen(fPath, "w")

		for i, path in ls
		{
			fDiv := FileOpen(path, "r")

			if (fDiv.Length <= buffSize) {

				fl := fDiv.Length
				fDiv.RawRead(&buff, fl)
				fOut.RawWrite(&buff, fl)

			} else {
				l := fDiv.Length
				Loop, % fDiv.Length // buffSize
				{
					fDiv.RawRead(&buff, buffSize)
					fOut.RawWrite(&buff, buffSize)
					l -= buffSize
				}
				if (l) {
					fDiv.RawRead(&buff, l)
					fOut.RawWrite(&buff, l)
				}
			}

			fDiv.close()
		}
		fOut.close()
		return 0
	}
}