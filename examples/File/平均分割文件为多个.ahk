FDiv.bySize(A_Desktop "\a", A_Desktop, 4)

/* 静态方法说明
;----------------------------------------

FDiv.bySize()

	简介:  根据尺寸分割文件

	参1: 要切割的文件
	参2: 输出的目录
	参3: 切割的部分最大尺寸, 单位bytes
	参4: 可舍, 是否输出合并文件的bat
	参5: 在分割的文件尾部添加的字符串

	返回值:
		0, 分割成功
		1, 源文件不存在
		2, 目标文件夹不存在
		3, 此路径下可能已有相关的被分割过文件, 只检测第一个
		4, 分割尺寸大于源文件尺寸

;~ 示例:
FDiv.bySize("C:\Users\CUSong\Desktop\installer_r24.4.1-windows.exe"
			, A_Desktop "\切割"
			, 32 * 1024 * 1024
			, true
			, ".z")

;----------------------------------------

FDiv.byNum()

	简介: 设定分割数量直接分割文件

	参1: 要切割的文件
	参2: 输出的目录
	参3: 切割成多少个文件
	参4: 可舍, 是否输出合并文件的bat
	参5: 在分割的文件尾部添加的字符串

	返回值:
		0, 分割成功
		1, 源文件不存在,
		2, 目标文件夹不存在
		3, 此路径下可能已有相关的被分割过文件, 只检测第一个
		4, 输出数量不得 小于或等于 1

;~ 示例:
FDiv.byNum("C:\Users\CUSong\Desktop\installer_r24.4.1-windows.exe"
			, A_Desktop
			, 5
			, true
			, ".z")

*/

class FDiv {

	;~ 程序默认的缓冲区尺寸, 默认 12MB
	static buffSize := 12 * 1024 * 1024

	;----------------------------------------
	setBuffSize(newSize) {
		this.buffSize := size
	}

	;----------------------------------------
	byNum(src, toDir, divNum, outBat := true, endStr := "") {

		if ("" = FileExist(src))
			return 1

		if not instr(FileExist(toDir), "D")
			return 2

		if (SubStr(toDir, -0, 1) = "\")
			toDir := SubStr(toDir, 1, -1)

		if instr(src, ":")
			SplitPath, src, srcName
		else
			srcName := src

		Loop, files, % toDir . "\FD*" . srcName, F
			return 3

		if (divNum <= 1)
			return 4

		fSrc 		:= FileOpen(src, "r")
		srcSize   	:= fSrc.Length
		buffSize 	:= this.buffSize
		divSize  	:= Ceil(srcSize / divNum)
		VarSetCapacity(buff, buffSize)

		if (divSize <= buffSize) {

			s   := srcSize
			Loop, % divNum
			{

				fTo := FileOpen(toDir . "\FD" . divNum . "-" . A_Index . "-" . srcName . endStr, "w")

				if (s >= divSize) {
					fSrc.RawRead(&buff, divSize)
					fTo.RawWrite(&buff, divSize)
				} else {
					fSrc.RawRead(&buff, s)
					fTo.RawWrite(&buff, s)
				}
				fTo.close()
				s -= divSize
			}

		} else {	;~ 分割部分 大于 缓冲区尺寸

			s   := srcSize
			Loop, % divNum
			{
				fTo := FileOpen(toDir . "\FD" . divNum . "-" . A_Index . "-" . srcName . endStr, "w")
				s2 := (s >= divSize) ? divSize : s

				Loop {
					if (s2 >= buffSize) {
						fSrc.RawRead(&buff, buffSize)
						fTo.RawWrite(&buff, buffSize)
					} else {
						fSrc.RawRead(&buff, s2)
						fTo.RawWrite(&buff, s2)
					}
					s2 -= buffSize
				} until (s2 <= 0)

				fTo.close()
				s -= divSize
			}
		}

		fSrc.close()

		if (outBat)
			this.batMaker(toDir, divNum, srcName, endStr)

		return 0
	}


	;----------------------------------------
	bySize(src, toDir, divSize, outBat := true, endStr := "") {

		if ("" = FileExist(src))
			return 1

		if not instr(FileExist(toDir), "D")
			return 2

		if (SubStr(toDir, -0, 1) = "\")
			toDir := SubStr(toDir, 1, -1)

		if instr(src, ":")
			SplitPath, src, srcName
		else
			srcName := src

		Loop, files, % toDir . "\FD*" . srcName, F
			return 3

		fSrc 		:= FileOpen(src, "r")
		buffSize 	:= this.buffSize
		srcSize   	:= fSrc.Length

		if (srcSize <= divSize) {
			fSrc.close()
			return 4
		}

		divNum := srcSize // divSize + (Mod(srcSize, divSize) ? 1 : 0)
		VarSetCapacity(buff, buffSize)

		if (divSize <= buffSize) {

			s := srcSize
			loop, % divNum
			{
				fDiv := FileOpen(toDir . "\FD" . divNum . "-" . A_Index . "-" . srcName . endStr, "w")
				s2 := (s >= divSize) ? divSize : s

				fSrc.RawRead(&buff, s2)
				fDiv.RawWrite(&buff, s2)
				s -= divSize
				fDiv.close()
			}

		} else {

			s := srcSize
			loop, % divNum
			{
				fDiv := FileOpen(toDir . "\FD" . divNum . "-" . A_Index . "-" . srcName . endStr, "w")
				s2 := (s >= divSize) ? divSize : s
				Loop {
					if (s2 >= buffSize) {
						fSrc.RawRead(&buff, buffSize)
						fDiv.RawWrite(&buff, buffSize)
					} else {
						fSrc.RawRead(&buff, s2)
						fDiv.RawWrite(&buff, s2)
					}
					s2 -= buffSize
				} until (s2 <= 0)

				s -= divSize
				fDiv.close()
			}
		}
		fSrc.close()

		if (outBat)
			this.batMaker(toDir, divNum, srcName, endStr)

		return 0
	}

	;----------------------------------------
	batMaker(toDir, divNum, srcName, endStr) {
		static yh := """"	;~ 单个双引号
		fBat := FileOpen(toDir . "\FD" . divNum . "-" . 0 . "-" . srcName . ".bat", "w")
		batText := ""
		Loop, % divNum
		{
			batText .= yh . "FD" . divNum . "-" . A_Index . "-" . srcName . endStr . yh . "+"
		}
		batText := SubStr(batText, 1, -1)
		batText := "copy /b " . batText . " " . yh . srcName . yh
		fBat.Write(batText)
		fBat.Close()
	}


	;----------------------------------------
	join(divPartPath, toDir) {

		if (not(FileExist(divPartPath)))
			return 1

		divPartPath :=  Instr(divPartPath, ":") ? divPartPath : (A_WorkingDir "\" divPartPath)

		SplitPath, divPartPath, divName, divDir

		isDived := RegExMatch(divName, "^FD(\d+)\-\d+\-(.+)$", r)

		if (not(isDived))
			return 2

		divNum  := r1			;~ 被分割数量
		srcName := r2		;~ 输出的文件名
		fSrcPath := toDir . "\" . srcName

		lsDivPath := []
		loop, % divNum
		{
			divPath := divDir . "\FD" . divNum . "-" . A_Index . "-" . srcName

			if FileExist(divPath)
				lsDivPath.push(divPath)
			else
				return 3
		}

		if not instr(FileExist(toDir), "D")
			return 4

		if FileExist(fSrcPath)
			return 5

		buffSize := this.buffSize
		VarSetCapacity(buff, buffSize)

		fOut := FileOpen(fSrcPath, "w")

		for i, divPath in lsDivPath
		{
			fDiv := FileOpen(divPath, "r")

			if (fDiv.Length <= buffSize) {

				fDiv.RawRead(&buff, fDiv.Length)
				fOut.RawWrite(&buff, fDiv.Length)

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