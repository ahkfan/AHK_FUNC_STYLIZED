
基础暴击 := 201
基础伤害 := 200
tt := 0
Gui, add, edit, readonly, % "基础伤害:"  基础伤害
Gui, add, edit, readonly, 暴击伤害: x * 2
Gui, add, edit, hwnd@bj, % 基础暴击 / 10
gui, add, button, g伤害, 攻击
Gui, add, listbox, hwnd@gethurt h200 w150
Gui, show
return
伤害:

	随机伤害 := floor(基础伤害 * 0.2)
	random, 随机, % -(随机伤害), % 随机伤害

	实际伤害 := 随机 + 基础伤害

	Random, xx, 0, 1000
	GuiControl, , % @gethurt, % "骰子: " xx "`n" "基础暴击: " 基础暴击
	if (xx > 基础暴击)
		GuiControl, , % @gethurt, % "造成伤害: " 实际伤害
	else
		GuiControl, , % @gethurt, % "造成暴击伤害: " (实际伤害 * 2)
	tt += 1
	GuiControl, Choose, % @gethurt,  % tt * 2
return