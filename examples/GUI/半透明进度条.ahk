#SingleInstance force
SetWinDelay, 0
winProgress(3)

winProgress(showSecs, x := 100, y := 100, gColor := "005649", iTrans := 150, iWidth := 300, iHeight := 30) {
	static @__Progress := createGui()
	showSecs := showSecs * 1000
	theStart := A_Tickcount
	Gui, __Progress:color, % gColor
	Gui, __Progress:show , NoActivate w%iWidth% h%iHeight% x%x% y%y%

	WinSet	, trans
			, % iTrans
			, % "ahk_id " @__Progress

	WinSet	, ExStyle
			, +0x20
			, % "ahk_ID " @__Progress
	loop {
		thisLen := iWidth * (thieC := ((A_Tickcount - theStart) / showSecs))
		WinMove, % "ahk_id " @__Progress, , , , % iWidth - Ceil(thisLen)
	} until (thieC > 1)
	Gui, __Progress:hide
}

createGui() {
	Gui, __Progress:Destroy
	Gui, __Progress:+alwaysontop -sysmenu -caption +hwnd@__Progress
	return @__Progress
}


