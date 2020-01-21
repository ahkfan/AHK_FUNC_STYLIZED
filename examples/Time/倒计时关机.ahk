#SingleInstance force


inputbox, closeIt, 多久后关机, 单位为分, , , 150
if (closeIt) {

	Gui, +alwaysontop -caption -sysmenu +hwnd@main
	Gui, color, 0x000000, 0x000000
	Gui, font, s80 c0xFFDB49, 微软雅黑
	gui, add, edit, x0 y390 w%A_ScreenWidth% Disabled Center hwnd@edit,123
	gui, show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%
	WinSet, trans, 150, % "ahk_id " @main
	关机秒数 := closeIt * 60
	起始时间 := A_Now
	loop {
		当前时间 := A_Now
		当前时间 -= 起始时间, s
		GuiControl, , % @edit, % "Shutdown for " (关机秒数 - 当前时间)  " seconds."
		if (当前时间 >= 关机秒数)
			Shutdown, 1
	}
}
return

#If, winactive("ahk_id " @main)
!f4::
GuiClose:
	ExitApp
return
#If


