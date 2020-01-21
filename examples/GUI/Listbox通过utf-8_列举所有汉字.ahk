Gui, add, listbox, hwnd@lb w120 h300
Gui, show
a := ""
Loop, 20928
	GuiControl, , % @lb, % A_Index "-" chr(0x4e00 + a_index - 1)
return