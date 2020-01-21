#SingleInstance force
SetMouseDelay, -1
CoordMode, mouse, screen

mRange := 1			;~ 历次位移距离
speed := 800		;~ 越低越快
dragDis := 300		;~ 位移距离

return

f2::ExitApp

rbutton::
	MouseGetPos, x1, y1
	y2 := y1

	send, {lbutton down}

	while (getkeystate("rbutton", "p")) {

		if (mod(A_Index, speed) = 0) {

			y2 -= mRange
			MouseMove, 0, -%mRange%, 0, R
			if (y1 - y2  >= dragDis) {
				y2 := y1
				send, {lbutton up}
				MouseMove, %x1%, %y1%
				send, {lbutton down}
			}
		}

	}
	send, {lbutton up}
return

