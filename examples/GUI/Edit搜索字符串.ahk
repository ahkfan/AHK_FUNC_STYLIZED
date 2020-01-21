abc := {"腾讯qq" : "c:\xxxx"
		, "奇虎360" : "d:\xxxx"
		, "鸡儿360" : "e:\xxxx"}

Gui, add, edit, g#edit1 	hwnd@id_edit   w150
Gui, add, edit, 			hwnd@id_edit2  w150 h100 readonly
Gui, show
return

#edit1:
	GuiControlGet, get_input, , %  @id_edit
	if (!get_input) {
		GuiControl, , % @id_edit2, % ""
		return
	}

	is_nothing := 1
	out_put := ""
	for key, var in abc
	{
		if instr(key, get_input) {
			is_nothing := 0
			out_put .= key . ">>" . var "`n"
			GuiControl, , % @id_edit2, % key "`n" var
		}
	}
	GuiControl, , % @id_edit2, % is_nothing ? ("") : (out_put)
return
