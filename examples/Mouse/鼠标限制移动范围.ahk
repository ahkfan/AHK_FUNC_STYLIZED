/*
	限制鼠标移动范围
*/
CapsLock::
	CoordMode, mouse, screen
	MouseGetPos, , my
	my := (my <= 0) ? (1) : (my)
	m_limits(1, 1, my, A_ScreenWidth, my + 1)
	KeyWait, capslock
	m_limits(0)
return


m_limits(switch := true, x1 := 0, y1 := 0, x2 := 0, y2 := 0) 
{
	if (not switch) 
	{
		dllcall("ClipCursor", "ptr", 0x0)
		return
	}

	VarSetCapacity(rect_mouse, 16)

	numput(x1, &rect_mouse + 0, "UInt")
	numput(y1, &rect_mouse + 4, "UInt")
	numput(x2, &rect_mouse + 8, "UInt")
	numput(y2, &rect_mouse + 12, "UInt")

	dllcall("ClipCursor", "ptr", &rect_mouse)
}


