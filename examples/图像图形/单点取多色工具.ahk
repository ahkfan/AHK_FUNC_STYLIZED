/*
#SingleInstance force
#include 1.ahk
setkeydelay, -1, -1

return
r::
	if obj.get() {
		send, 12345
	} else {
		send, 67
	}
return

SendDelay(key, SelptDown, SleptUp) {
	send, % "{" key " down}"
	sleep, % SelptDown
	send, % "{" key " up}"
	sleep, % SleptUp
}

SendStr(str, SelptDown, SleptUp) {
	loop, parse, str
		SendDelay(A_LoopField, SelptDown, SleptUp)
}

*/

#SingleInstance force
Gui, +alwaysontop
Gui, add, edit, readonly hwnd@pos w100 , % "0,0"
Gui, add, listbox, w100 h200 hwnd@color g#pos
Gui, add, button, w100 h30 g#clear, 清空
gui, add, button, w100 h30 g#copy, 复制
Gui, show, , getColor

CoordMode, mouse, window
CoordMode, pixel, window

global x:=0, y:=0, theColor, colorDict := {}

return

guiclose() {
	ExitApp
	return
}

#clear() {
	global @color
	colorDict := {}
	GuiControl, , % @color, % " "
	GuiControl, , % @color, % "|"
	MsgBox, % "已清空所有颜色"
}

#copy() {
	rtStr := "objName := new ColorGet(" x ", " y "`n"
	for key, var in colorDict
		rtStr .= "`n`t`t`t`t, "  key
	rtStr .= ")"
	Clipboard := ""
	Clipboard := rtStr
	ClipWait
	MsgBox, % "已复制到剪切板"
}

class ColorGet {
	__new(x, y, colorLs*) {
		local i, v
		this.dict := {}
		this.x := x
		this.y := y
		for i, v in colorLs
			(this.dict)[v] := ""
	}

	setdict(dict) {
		this.dict := dict
	}

	Get() {
		local theColor
		PixelGetColor, theColor, % x, % y, RGB
		if this.dict.HasKey(theColor)
			return true
		return false
	}


}

#pos(hwnd) {
	if (a_guievent = "doubleclick") {
		GuiControlGet, thekey, , % hwnd
		colorDict.delete(thekey)
		GuiControl, , % hwnd, % "|"
		for key, var in colorDict
			GuiControl, , % hwnd, % key "||"
	}
}


f1::
	MouseGetPos, x, y
	GuiControl, , % @pos, % x ", " y
return

f2::
	while (getkeystate("f2", "p")) {
		PixelGetColor, theColor, % x, % y, RGB
		if not (colorDict.HasKey(theColor)) {
			colorDict[theColor] := ""
			GuiControl, , % @color, % theColor "||"
		}
	}
return

f3::
	a := new colorget(x, y)
	a.setdict(colorDict)
	MsgBox, % a.get()
return