#SingleInstance force

Gui, font, s10, 黑体
Gui, Add, Edit, x6 y47 w270 h220 hwnd@id_测试文本 HScroll, 文本黏贴位置`n或将文件拖行至该处
Gui, Add, ListBox, x286 y47 w240 h220 hwnd@id_lb, 列表结果输出框

Gui, font, s15
Gui, Add, Edit, x6 y7 w520 h30 hwnd@id_reg g#reg_ctrl, 请输入正则表达式, 无需引号

GuiControl, focus, % @id_reg
Gui, Show, w535 h273, 正则测试工具
return

GuiClose:
ExitApp

#reg_ctrl:

	GuiControlGet, 表达式, , % @id_reg
	if !(表达式) {
		GuiControl, , % @id_lb, |
		return
	}
	表达式 := "i)(" 表达式 ")(?C#regout)"

	GuiControlGet, 匹配文本, , % @id_测试文本
	GuiControl, , % @id_lb, |
	found_times := 0
	get_pos := -1
	RegExMatch(匹配文本, 表达式)
return

#regout(m, num, fp) {
	global
	if (fp = get_pos) or (fp = (get_pos + 1)) {
		get_pos := fp
		return 1
	}
	else
		GuiControl, , % @id_lb, % "[" (found_times += 1) "]" "[" fp "]" m
	get_pos := fp
    return 1
}

GuiDropFiles:
	filename := A_GuiEvent
	FileRead, s_content, % filename
	GuiControl, , % @id_测试文本, % s_content
	GuiControl, focus, % @id_reg
return