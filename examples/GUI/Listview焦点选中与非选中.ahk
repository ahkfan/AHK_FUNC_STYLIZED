#SingleInstance force

;Gui, add, listview, w300 h200 -Multi, 列1|列2
Gui, add, listview, w300 h200 , 列1|列2
Gui, show
Loop, 5
	LV_Add("", "foo", "bar")

return

;~ 此热键将焦点置于上一行
f1::
	;~ 取当前行行号
	i := LV_GetNext(0)

	;~ 若listview 中含有 -Multi 选项, 该取消焦点命令可以省略
	LV_Modify(i, "-select -Focus")

	;~ 设置焦点到上一行
	LV_Modify(i - 1, "select Focus")
return


;~ 此热键取消所有选中行, 若listview创建命令没有 -Multi 选项, 按 f1 将多选而非切换焦点
f2::
	i := 0
	Loop {
		i := LV_GetNext(i)
		if not i
			break
		LV_Modify(i, "-select -Focus")
	}
return