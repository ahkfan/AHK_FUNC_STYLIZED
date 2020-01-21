a := new TextGUI(A_YYYY "年" A_MM "月" A_DD "日")

return

f1::a.stop()
f2::a.go()
f3::a.speedAdd(20)

class TextGUI {
	static objs := []
	__New(textInto, fontSize := 60, x := 0, y := 0, w := 800, textX := 0,theTextColor := "red", bColor := "0x000000",goSpeed := 3000, DefaultFont := "黑体") {
		TextGUI.objs.push(this)
		this.text := textInto
		this.screenX := x
		this.screenY := y
		this.textX := 0
		this.showWidth := w
		this.textColor := theTextColor
		this.bgTransColor := bColor
		guiName := "TextGUI" . ((len := TextGUI.objs.MaxIndex()) ? (1) : (len + 1))
		this.guiName := guiName
		gui, %guiName%: +Alwaysontop -Caption -SysMenu +hwnd@main
		gui, %guiName%:color, % bColor, % bColor
		gui, %guiName%:font, s%fontSize% c%theTextColor%, % DefaultFont
		gui, %guiName%:add, text,x%textX% y0  hwnd@text,% textInto
		GuiControlGet, cp, pos, % @text
		Gui, %guiName%:show, x%x% y%y% w%w% h%cph%
		WinSet, transcolor, % bColor, % "ahk_id " @main
		this.guiID := @main
		this.id := TextGUI.objs.MaxIndex()
		this.textID := @text
		this.goSpeed := goSpeed
		this.isGoing := true
	}
	go() {
		this.isGoing := true
		loop {
			if not mod(A_Index, this.goSpeed)
				GuiControl, Move, % this.textID , % "x" . (((this.textX -= 1) < (-this.showWidth)) ? (this.textX := this.showWidth) : (this.textX))
		} until not this.isGoing
		return
	}
	stop() {
		this.isGoing := false
	}
	speedAdd(num) {
		theNum := this.goSpeed, theNum -= num
		if (theNum < 0)
			theNum := 0
		this.goSpeed := theNum
	}


}

