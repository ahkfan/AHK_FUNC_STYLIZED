
/*
m_move(int: x, int: y)
m_move_compare(int: x, int: y)
m_move_bezier()
m_down(str: witch:= "L")
m_up(str: witch:= "L")
m_click()
m_drag()
m_get_pos()
m_get_win_hwnd()
m_get_winop_classNN()
m_get_winop_hwnd()
m_get_pixel()
m_pmsg_nc_move(str: witch:="L", int: hwnd)
m_pmsg_nc_down(str: witch:="L", int: hwnd)
m_pmsg_nc_up(str: witch:="L", int: hwnd)
m_pmsg_nc_click(str: witch:="L", int: hwnd)
*/
ms().RClick(DUDelay := 0)

ms()
{
	return __Class_AHKFS_Mouse
}

class __Class_AHKFS_Mouse
{
	
	;------------------------------------------------------
	SetRelative(option)
	{
		/*
			screen / window / client
		*/
		CoordMode, Mouse, % option
	}

	SetDelay(delay := -1)
	{
		SetMouseDelay, % delay
	}

	;------------------------------------------------------

	move(x, y, speed := 0)
	{
		MouseMove, % x, % y, % speed
	}

	moveR(x, y, speed := 0)
	{
		MouseMove, % x, % y,  % Speed, R
	}

	;------------------------------------------------------

	Click(DUDelay := 0)
	{
		MouseClick, L, % x, % y, 1, 0, D
		Sleep, % DUDelay
		MouseClick, L, % x, % y, 1, 0, U
	}
	
	Down()
	{
		MouseClick, L, , , 1, 0, D
	}

	Up()
	{
		MouseClick, L, , , 1, 0, U
	}

	;------------------------------------------------------

	RDown()
	{
		MouseClick, R, , , 1, 0, D
	}

	RUp()
	{
		MouseClick, R, , , 1, 0, U
	}

	RClick(DUDelay := 0)
	{
		MouseClick, R, % x, % y, 1, 0, D
		Sleep, % DUDelay
		MouseClick, R, % x, % y, 1, 0, U
	}

}


