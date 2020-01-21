#SingleInstance force
#NoEnv
SetMouseDelay, 0
SetDefaultMouseSpeed, 0
CoordMode, mouse, screen
	gui, +toolwindow +AlwaysOnTop
	gui	, add, listbox, w100 h150 vlsb
	gui	, add, button, w100 g刷新列表, 刷新列表	
	gui	, add, button, w100 g复现坐标轨迹, 轨迹复现
	gosub, 刷新列表	
	gui	, show, % "x" . (A_ScreenWidth - 200) " y" . (150) 
return
刷新列表:
	GuiControl, , lsb, |
	loop, % A_SCRIPTDIR "\history\*.his"
		guicontrol, , lsb, %a_loopfilename%
return
复现坐标轨迹:
	GuiControlGet, 文件名, , lsb
	BlockInput, on
	所有轨迹 := []
	if 文件名
	{
		loop, read, % a_scriptdir "\history\" 文件名
		{
			NOWLOOPLINE := A_LoopReadLine
			global 临时轨迹 := []
			Loop, Parse, NOWLOOPLINE, |
				FoundPos := RegExMatch(A_LoopField, "(\d+)-(\d+)(?Cfavor)")
			所有轨迹.Insert(临时轨迹)
		}
	}
	拖行次数 := 0
	移动次数 := 0
	起始时间 := A_Now
	for i, list2 in 所有轨迹
	{
		拖行次数 += 1
		for ij, list3 in list2
		{
			if (ij = 1) {
				lsmousemove(list3)
				send, {lbutton down}
				移动次数 += 1
				;sleep 1
				}
			else {
				移动次数 += 1
				lsmousemove(list3)
			}
		}
		send, {lbutton up}
	}
	BlockInput, Off
	当前时间 := A_Now
	当前时间 -= 起始时间, s
	MsgBox, 本次工作共:`n执行 %拖行次数% 次拖行`n经过 %移动次数% 个坐标`n耗时%当前时间%秒
return
	
favor(M) {
	临时列表 := [m1, m2]
	临时轨迹.Insert(临时列表)
}

lsmousemove(THELIST) {
	MouseMove, % THELIST[1], % THELIST[2]
}