
/*

m_get_pos()

m_pmsg_nc_move(str: witch:="L", int: hwnd)
m_pmsg_nc_down(str: witch:="L", int: hwnd)
m_pmsg_nc_up(str: witch:="L", int: hwnd)
m_pmsg_nc_click(str: witch:="L", int: hwnd)
*/


ms()
{
	return __Class_AHKFS_Mouse
}

class __Class_AHKFS_Mouse
{
	;------------------------- default config about mouse -------------------------
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

	;------------------------- mouse move -------------------------
	move(x, y, speed := 0)
	{
		MouseMove, % x, % y, % speed
	}
	moveR(x, y, speed := 0)
	{
		MouseMove, % x, % y,  % Speed, R
	}

	x[]
	{
		get {
			MouseGetPos, x
			return x
		}
		set {
			MouseGetPos, , y
			MouseMove, % value, % y, 0
		}
	}

	y[]
	{
		get {
			MouseGetPos, , y
			return y
		}
		set {
			MouseGetPos, , x
			MouseMove, % x, % value, 0
		}		
	}

	pos[]
	{
		set {
			
		}

		get {

		}
	}

	;------------------------- mouse left button event -------------------------
	ClickOn(x, y, DUDelay := 0)
	{
		MouseClick, L, % x, % y, 1, 0, D
		Sleep, % DUDelay
		MouseClick, L, % x, % y, 1, 0, U
	}
	Click(DUDelay := 0)
	{
		MouseClick, L, , , 1, 0, D
		Sleep, % DUDelay
		MouseClick, L, , , 1, 0, U
	}
	Down()
	{
		MouseClick, L, , , 1, 0, D
	}
	Up()
	{
		MouseClick, L, , , 1, 0, U
	}

	;------------------------- mouse right button event -------------------------
	RClickOn(x, y, DUDelay := 0)
	{
		MouseClick, R, % x, % y, 1, 0, D
		Sleep, % DUDelay
		MouseClick, R, % x, % y, 1, 0, U
	}
	RClick(DUDelay := 0)
	{
		MouseClick, R, , , 1, 0, D
		Sleep, % DUDelay
		MouseClick, R, , , 1, 0, U
	}	
	RDown()
	{
		MouseClick, R, , , 1, 0, D
	}
	RUp()
	{
		MouseClick, R, , , 1, 0, U
	}

	;------------------------- pixel under mouse -------------------------
	GetPixelRGB()
	{
		local X, Y, ret
		MouseGetPos, X, Y
		PixelGetColor, ret, % X, % Y, RGB
		return ret
	}
	GetPixelBGR()
	{
		local X, Y, ret
		MouseGetPos, X, Y
		PixelGetColor, ret, % X, % Y
		return ret		
	}
	GetPixelRGBEx()
	{
		local ex1, ex2, X, Y
		ex1 := A_CoordModeMouse
		ex2 := A_CoordModePixel
		CoordMode, Mouse, Screen
		CoordMode, Pixel, Screen
		MouseGetPos, X, Y
		PixelGetColor, ret, % X, % Y, RGB
		CoordMode, Mouse, % ex1
		CoordMode, Pixel, % ex2
		return ret
	}
	GetPixelBGREx()
	{
		local ex1, ex2, X, Y
		ex1 := A_CoordModeMouse
		ex2 := A_CoordModePixel
		CoordMode, Mouse, Screen
		CoordMode, Pixel, Screen
		MouseGetPos, X, Y
		PixelGetColor, ret, % X, % Y
		CoordMode, Mouse, % ex1
		CoordMode, Pixel, % ex2
		return ret		
	}

	;------------------------- get window and window control under mouse -------------------------
	GetWinHwnd()
	{
		local ret
		MouseGetPos, , , ret
		return ret
	}
	GetWinopClassNN()
	{
		local ret
		MouseGetPos, , , , ret
		return ret
	}
	GetWinopHwnd()
	{
		local pHwnd, classNN, ret
		MouseGetPos, , , pHwnd, classNN
		ControlGet, ret, Hwnd, , % classNN,  % "ahk_id " pHwnd
		return ret
	}

	;------------------------- mouse background event -------------------------

}