/*
需求: 做一个获取年份的GUI, 且可以调整日期, 做了这个简单模型

使用说明:
	1. 按f1显示窗口
	2. ↑ ↓ 按钮调整日期
	3. 单击年份显示弹窗

date: 2019/10/24
*/

;~ 必须在自动执行段写上init()
YearGui.init()
return

f1::
	;~ YearGui.get() 方法会阻塞流程, 返回选择的年份, 若窗口不因为选择年份被关闭, 返回空值
	year := YearGui.get(100, 100)
	if (year)
		msgbox, % "选取年份: " year
	else
		msgbox, 你未做选择
return

class YearGui {

	init() {
		static ran := false
		if (ran)
			return
		ran := true

		YearGui.start := 2019
		YearGui.hwndLs := []
		YearGui.count := 12

		YearGui.name := "YearGui"

		Gui, % YearGui.name ":+toolwindow +AlwaysOnTop +hwnd@main"
		YearGui.hwnd := @main

		;~ 创建按钮
		loop, 2
			Gui, % YearGui.name ":add", button, gYearGui_ButtonEvent, % (A_Index = 1) ? "↑" : "↓"


		;~ 创建文本控件并绑定事件, 保存控件句柄到列表, 用于更改内容
		Loop, % YearGui.count
		{
			Gui, % YearGui.name ":add", text, gYearGui_EditEvent hwnd@y, % YearGui.start + A_Index -1
			YearGui.hwndLs.push(@y)
		}

		Gui, % YearGui.name ":show", hide
	}
	get(x := 10, y := 10) {
		YearGui.getYear := ""
		Gui, % YearGui.name ":show", % "x" x " y" y
		ex := A_DetectHiddenWindows
		DetectHiddenWindows, off
		loop {
		} until not winexist("ahk_id " YearGui.hwnd)
		DetectHiddenWindows, % ex
		return YearGui.getYear
	}


	hide() {
		Gui, % YearGui.name ":hide", hide
	}

}

YearGuiGuiClose() {
	YearGui.hide()
}

YearGui_EditEvent(hwnd) {
	guicontrolget, year, , % hwnd
	YearGui.getYear := year
	YearGui.hide()
}
YearGui_ButtonEvent() {
	YearGui.start += (A_GuiControl = "↑") ? 12 : -12
	Loop, % YearGui.count
		GuiControl, , % YearGui["hwndLs"][A_Index], % YearGui.start + A_Index -1
}

