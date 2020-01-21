p := DragPos()
MsgBox, % "x1: " p.1
		. "y1: " p.2
		. "x2: " p.3
		. "y2: " p.4
return


DragPos() {		;~ 一次性取得鼠标拖行(按下至弹起的坐标)
	Static RtPos := [], GetUp, x, y
	GetUp := false
	Hotkey, Lbutton, DragPos_Down
	Hotkey, Lbutton Up, DragPos_Up
	Loop {
	} Until (GetUp)
	return RtPos
	DragPos_Down:
		RtPos := []
		MouseGetPos, x, y
		RtPos.push(x, y)
	return
	DragPos_Up:
		MouseGetPos, x, y
		RtPos.push(x, y)
		Hotkey, Lbutton, Off
		Hotkey, Lbutton Up, Off
		GetUp := true
	return
}