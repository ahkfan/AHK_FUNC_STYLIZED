#SingleInstance force
global aStrInfo					; - 存放字符串的信息
VarSetCapacity(aStrInfo, 8, 0)	; - 前4位字符串的指针, 后4位字符串的长度

w := 200

Gui, add, Edit, w%w% ReadOnly, % dllcall("GetCurrentProcessId", "Int")


Gui, add, Edit, w%w% ReadOnly hwnd@t0, % &aStrInfo		; - 存放字符串信息的edit控件
Gui, add, Text, w%w% hwnd@t1					; - 存放字符串指针
Gui, add, Text, w%w% hwnd@t2					; - 存放字符串长度

Gui, add, Edit, w%w% h300 hwnd@tt				; - 存放字符串内容
Gui, add, Button, w%w% gsetString, 刷新字符串内容					; - 刷新字符串内容
Gui, show, x200, memSet
return




setString() {
	global
	GuiControlGet, putIntoStr, , % @tt
	if (putIntoStr != "") {

		getLen := StrPut(putIntoStr) * 2
		VarSetCapacity(stringMain, getLen, 0)

		StrPut(putIntoStr, &stringMain)

		NumPut(&stringMain, aStrInfo, 0, "UInt")
		NumPut(getLen , aStrInfo, 4, "UInt")

		GuiControl, , % @t1, % &stringMain
		GuiControl, , % @t2, % getLen
	}
	GuiControl, , % @t0, % &aStrInfo
}

