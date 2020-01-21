/*	示例 1
VarSetCapacity(data, 128 * 1024, 0)
len := data_FileWriteHexStr("abcde", data, "ff ff ff 12 55 ab")
MsgBox, % data_FileReadHexStr("abcde", data, len)
*/


/* 示例 2
VarSetCapacity(data, 128 * 1024, 0)
len := data_WriteHexStr(data, "ab ff 22 10 0 12 cc aa dd")	;~ 写入并获取写入长度
MsgBox, % "写入长度" len
MsgBox, % "data中数据为: " data_read2HexStr(data, len)		 ;~ 验证读取该数据
obj := FileOpen("abc", "w")									;~ 创建文件对象
obj.RawWrite(data, len)										;~ 写入数据到文件
obj.close()
obj := ""

Sleep 500
VarSetCapacity(data, 128 * 1024, 0)							;~ 刷新该内存
obj := FileOpen("abc", "r")
obj.RawRead(data, len)
obj.close()
obj := ""
MsgBox, % "data中数据为: " data_read2HexStr(data, len)		 ;~ 验证
return
*/

/* 示例 3
global __dataBoxLen := 1024 * 128
global __dataBox
VarSetCapacity(__dataBox, __dataBoxLen, 0)
dict := {"abc": 123, "bbb":555}
data_FileWriteDict(A_ScriptDir "\dict.dict", dict)
data_FileReadDict(A_ScriptDir "\dict.dict")
return
*/


data_FileReadDict(file, readStart := 6) {
	ret := {}

	obj := FileOpen(file, "r")
	obj.RawRead(__dataBox, readStart + 8)
	datalen 	:= NumGet(__dataBox, readStart, "UInt")
	dictLen := NumGet(__dataBox, readStart + 4, "UInt")
	;MsgBox, % "数据长:" datalen
	;MsgBox, % "字典长:" dictLen
	pos := readStart + 8
	;~ 实际数据载体 buff
	if (len > __dataBoxLen)
	{
		VarSetCapacity(buff, len, 0)
	}	
	else
	{
		VarSetCapacity(buff, __dataBoxLen, 0)
	}
		
	obj.pos := 0
	obj.RawRead(buff, datalen)

	obj.close()
	obj := ""

	loop %dictLen% 
	{
		keylen := NumGet(buff, pos, "UInt")
		pos += 4
		key := StrGet(&buff + pos, keylen)
		ret[key] :=
		;MsgBox, % data_read2HexStr(buff, keylen, pos)
	}

}

;------------------------------------------
data_FileWriteDict(file, dictObj, writeStart := 6) 
{
	buffWidth := __dataBoxLen
	VarSetCapacity(buff, buffWidth, 0)
	pos := writeStart
	pos += 4
	numput(dictObj.count(), buff, pos, "UInt")
	pos += 4
	for key, var in dictObj
	{
		;~ 1. 写入键:
			;~ 1.1 键长		UInt 	4Byte
			;~ 1.2 键内容	String	...

		data_FileWriteDict_WriteStr(key, buff, buffWidth, pos)

		;~ 2. 写入值:
			;~ 2.1 值类型 	UChar	1Byte		0>字符串 1>对象
			;~ 2.2 为字符串时, 写入 值长度	为对象时, 写入对象键值对数量, UInt		4Byte
			;~ 2.3 写入内容 ...
		data_FileWriteDict_WriteVar(var, buff, buffWidth, pos)

	}

	NumPut(pos, buff, writeStart, "UInt")
	data_fileWriteData(file, buff, pos)
	VarSetCapacity(foo, 0, 0)	;~ 释放内存
	foo := ""
}

;------------------------------------------
data_FileWriteDict_WriteStr(str, byref buff, byref buffWidth, byref pos) 
{
	slen := StrPut(str) * 2
	ToTalLen := pos + 4 + slen
	if (ToTalLen > buffWidth) 
	{
		buffWidth := ToTalLen + __dataBoxLen
		data_ReSetMem(buff, buffWidth, 0)
	}
	NumPut(slen, buff, pos, "Uint")
	pos += 4
	StrPut(str, &buff + pos, slen)
	pos += slen

}



;------------------------------------------
;~ 写入字典到文件子函数
data_FileWriteDict_WriteVar(var, byref buff, byref buffWidth, byref pos) {

	if (buffWidth - pos <= 9)
		data_ReSetMem(buff, buffWidth + __dataBoxLen)

	if not isobject(var) {

		NumPut(0, buff, pos, "UChar")
		pos += 1

		data_FileWriteDict_WriteStr(var, buff, buffWidth, pos)

	} else {
		;~ 写入 类型
		NumPut(1, buff, pos, "UChar")
		pos += 1

		;~ 字典 长度
		NumPut(var.count(), buff, pos, "UInt")
		pos += 4

		for key, var2 in var
		{
			;~ 写入键
			data_FileWriteDict_WriteStr(key, buff, buffWidth, pos)
			;~ 写入值
			data_FileWriteDict_WriteVar(var2, buff, buffWidth, pos)
		}
	}
}


;------------------------------------------
;~ 重置临时内存的尺寸
data_SetBoxSize(len) 
{
	if (len > __dataBoxLen) 
	{
		VarSetCapacity(__dataBox, len, 0)
		__dataBoxLen := len
		return true
	} 
	else 
	{
		return false
	}
}


;------------------------------------------
data_ReSetMem(byref buff, len, start := 0) 
{
	if (start >= len)
	{
		return false
	}
	ls := data_read2DecLs(buff, len, start)
	VarSetCapacity(buff, len, 0)
	data_WriteDecLs(buff, ls, len - start, start)
	ls := ""
	return true
}

;------------------------------------------
data_Move(byref dataFrom, len1, start1, byref toData, len2, start2)
{
	return data_WriteDecLs( toData
					, data_read2DecLs(dataFrom, len1, start1)
					, len2
					, start2)
}

;------------------------------------------
data_PutBoxStr(str) 
{
	len := StrPut(str) * 2
	if (len > __dataBoxLen)
		data_SetBoxSize(len)
	StrPut(str, __dataBox)
	return len
}


;~ 将字符串 写入到一个内存变量 中, 若空间不足, 将拓宽变量宽度

;=============================
;========== 写入文件 ==========
;=============================



data_FileWriteDecLs(file, byref buff, lsDec, len := 0, start := 0) 
{
	dataLen := data_WriteDecLs(buff, lsDec, len, start)
	if not dataLen
		return false
	return data_fileWriteData(file, buff, dataLen + start)
}

data_FileWriteHexLs(file, byref buff, lsHex, len := 0, start := 0) 
{
	dataLen := data_WriteHexLs(buff, lsHex, len, start)
	if not dataLen
		return false
	return data_fileWriteData(file, buff, dataLen + start)
}

data_FileWriteDecStr(file, byref buff, strDec, len := 0, start := 0) 
{
	dataLen := data_WriteDecStr(buff, strDec, len, start)
	if not dataLen
		return false
	return data_fileWriteData(file, buff, dataLen + start)
}

data_FileWriteHexStr(file, byref buff, strHex, len := 0, start := 0) 
{
	dataLen := data_WriteHexStr(buff, strHex, len, start)
	if not dataLen
		return false
	return data_fileWriteData(file, buff, dataLen + start)
}


data_fileWriteData(file, byref buff, len) 
{
	obj := FileOpen(file, "w")
	obj.RawWrite(buff, len)
	obj.close()
	obj := ""
	return len
}

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~读取文件

data_FileReadDecLs(file, byref buff, len, start := 0) 
{
	data_FileReadData(file, buff, start + len)
	return data_read2DecLs(buff, len, start)
}

data_FileReadDecStr(file, byref buff, len, start := 0) 
{
	local rt := "", i, v
	for i, v in data_FileReadDecLs(file, buff, len, start)
	{
		rt .= v . " "
	}
	StringTrimRight, rt, rt, 1
	return rt
}

data_FileReadHexLs(file, byref buff, len, start := 0) 
{
	data_FileReadData(file, buff, start + len)
	return data_read2HexLs(buff, len, start)
}

;------------------------------------------

data_FileReadHexStr(file, byref buff, len, start := 0) {
	local rt := "", i, v
	for i, v in data_FileReadHexLs(file, buff, len, start)
	{
		rt .= v . " "
	}
	StringTrimRight, rt, rt, 1
	return rt
}


;------------------------------------------
data_FileReadData(file, byref buff, len) 
{
	obj := FileOpen(file, "r")
	obj.RawRead(buff, len)
	obj.close()
	obj := ""
}


;-----------------------------------
data_WriteDecLs(byref data, lsDec, len := 0,start := 0) 
{
	local i, v
	if (len = 0) 
	{
		for i, v in lsDec
		{
			if not (v <> ("") && v >= 0 && v <= 255)
			{
				return false
			}
			NumPut(v, data, start + i - 1, "UChar")
		}
		i := lsDec.MaxIndex()
	} 
	else 
	{
		for i, v in lsDec 
		{
			if (i > len)
			{
				break
			}
			if not (v <> ("") && v >= 0 && v <= 255)
			{
				return false
			}
			NumPut(v, data, start + i - 1, "UChar")
		}


		lsLen := lsDec.MaxIndex()
		if (len > lsLen) 
		{
			i := len - lsLen
			Loop, % i
			{
				NumPut(0, data, lsLen + A_Index - 1, "UChar")
			}
		}
		i := len
	}
	return i
}

data_WriteHexLs(byref data, lsHex, len := 0,start := 0) 
{	;~ 将16进制列表写入内存
	local i, v
	ls := []
	for i, v in lsHex
		ls.push(format("{1:i}", "0x" v))
	return data_WriteDecLs(data, ls, len, start)
}

data_WriteDecStr(byref data, DecStr, len := 0,start := 0) 
{	;~ 将10进制字符串写入内存
	ls := []
	DecStr := RegExReplace(DecStr, "\s+", " ")
	Loop, parse, DecStr, % " "
		if (A_Loopfield <> "")
			ls.push(A_Loopfield)
	return data_WriteDecLs(data, ls, len, start)
}

data_WriteHexStr(byref data, HexStr, len := 0,start := 0) 
{	;~ 将16进制字符串写入内存
	ls := []
	HexStr := RegExReplace(HexStr, "\s+", " ")
	Loop, parse, HexStr, % " "
		if (A_Loopfield <> "")
			ls.push(A_Loopfield)
	return data_WriteHexLs(data, ls, len, start)
}

;-----------------------------------
data_read2DecLs(byref data, len, start := 0) 
{	;~ 将内存中数据读取为十进制列表
	ls := []
	Loop, % len
	{
		ls.push(NumGet(data, start + A_Index - 1, "UChar"))
	}
	return ls
}

data_read2DecStr(byref data, len, start := 0) 
{	;~ 将内存中的数据读取为十进制数
	local rt := ""
	for i, v in data_read2DecLs(data, len, start)
		rt .= v " "
	StringTrimRight, rt, rt, 1
	return rt
}

data_read2HexLs(byref data, len, start := 0) 
{	;~ 将内存中数据读取为16进制字符串 列表
	ls := []
	Loop, % len
		ls.push(format("{1:x}", NumGet(data, start + A_Index - 1, "UChar")))
	return ls
}

data_read2HexStr(byref data, len, start := 0) 
{	;~ 将内存中数据读取为16进制字符串
	local rt := ""
	for i, v in data_read2HexLs(data, len, start)
		rt .= v " "
	StringTrimRight, rt, rt, 1
	return rt
}