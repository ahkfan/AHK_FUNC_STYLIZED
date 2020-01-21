#SingleInstance force
global strInfo
VarSetCapacity(strInfo, 8, 0)

w := 200

Gui, add, edit, hwnd@tt w%w% h300
Gui, add, button, w%w% gGetMem, Get
Gui, show
return


GetMem() {
	global
	ControlGettext, memPid, Edit1, memSet
	ControlGettext, memInfoPtr, Edit2, memSet
	pHandle := DllCall("OpenProcess", "UInt", 0x0010, "Int", 0, "UInt", memPid, "Int")
	DllCall("ReadProcessMemory", "Uint", pHandle, "UInt", memInfoPtr, "UInt", &strInfo, "UInt", 8, "Int", 0)

	strPtr := NumGet(strInfo, 0, "UInt")
	len :=  NumGet(strInfo, 4, "UInt")

	VarSetCapacity(thisStr, len, 0)

	DllCall("ReadProcessMemory", "Uint", pHandle, "UInt", strPtr, "UInt", &thisStr, "UInt", len, "Int", 0)

	GuiControl, , % @tt, % strget(&thisStr)

}