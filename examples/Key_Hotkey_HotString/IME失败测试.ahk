/*
	此示例无用
	win32api关于输入法接口的探究

*/
#Persistent

hkbd := getCrtHKBd()
ToolTip, % hkbd
return

f1::
	SetKBd(hkbd)
	ToolTip,  % "++" hkbd
return




;----------------------------------------
;~ 获取输入法列表详情
getKBdInfoAll() {
	size := 256
	retDict := []
	for i, hKBd in getKBdList() {
		VarSetCapacity(buff, size, 0)

		DllCall("imm32.dll\ImmGetDescriptionW", "Int", hKBd
											  , "Ptr", &buff
											  , "Int", size
											  , "Int")
		retDict.push({"name": StrGet(&buff, size), "hKBd" : hKBd})
	}
	return retDict
}

;----------------------------------------
;~ 获取输入法句柄列表
getKBdList() {
	size := 256
	VarSetCapacity(buff, size, 0)
	DllCall("GetKeyboardLayoutList", "Int", 25, "Ptr", &buff, int)
	retIntLs := []
	Loop, % size / 4
	{
		result := NumGet(buff, (A_Index - 1) * 4, "Int") & 0xffffffff

		if (IsKBd(result) && result <> 0)
			retIntLs.push(format("0x{1:x}", result))
		else
			break
	}

	VarSetCapacity(buff, 0)
	return retIntLs
}

;----------------------------------------
;~ 获取当前活动输入法句柄
getCrtHKBd() {
	return Dllcall("GetKeyboardLayout", "UInt", 0,"UInt")
}


;----------------------------------------
;~
getCrtHKBdNameW(hKbd) {
	size := 256
	VarSetCapacity(buff, size)
	result := Dllcall("GetKeyboardLayoutNameW", "Ptr", &buff, "Int")
	retDict := {"result": result, "name": StrGet(&buff, size)}
	VarSetCapacity(buff, 0)
	return retDict
}


;----------------------------------------
;~ 是否为输入法
IsKBd(hKbd) {
	return dllcall("imm32.dll\ImmIsIME", "int", hKbd, "int")
}

;----------------------------------------
;~ 从键盘布局句柄通过注册表寻找输入法名称
getKBdNameFromKBd(hKbd) {
	RegRead, ret, % "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\Keyboard Layouts\" . format("{1:x}", hKbd), Layout Text
	return ret
}

;----------------------------------------
;~ 获取当前输入法名称
getCrtKBdName() {
	return getKBdNameFromKBd(getCrtHKBd())
}

;----------------------------------------
;~ 激活输入法
ActiveKBd(hKBd, flag) {
	return DllCall("ActivateKeyboardLayout", "UInt", hKBd, "Uint", flag, "UInt")
}

;----------------------------------------
;~ 设置输入法
SetKBd(hKBd) {
	size := 256
	VarSetCapacity(buff, size)
	DllCall("ActivateKeyboardLayout", "UInt", hKBd, "Uint", 0, "UInt")
	result := Dllcall("GetKeyboardLayoutNameW", "Ptr", &buff, "Int")
	;MsgBox, % StrGet(&buff, 256)
	curkeylayout := DllCall("LoadKeyboardLayoutW", "AStr", StrGet(&buff, 256), "Int", 8, "UInt")
	RETURN RESULT := DllCall("ActivateKeyboardLayout", "UInt", curkeylayout, "Uint", 0, "UInt")
}



data_read2HexStr(byref data, len, start := 0) {	;~ 将内存中数据读取为16进制字符串
	local rt := ""
	for i, v in data_read2HexLs(data, len, start)
		rt .= ((StrLen(v) = 1) ? ("0" . v) : v ) . " "
	StringTrimRight, rt, rt, 1
	return rt
}
data_read2HexLs(byref data, len, start := 0) {	;~ 将内存中数据读取为16进制字符串 列表
	ls := []
	Loop, % len
		ls.push(format("{1:x}", NumGet(data, start + A_Index - 1, "UChar")))
	return ls
}