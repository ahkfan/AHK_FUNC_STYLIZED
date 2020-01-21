;~ 获取激活的Excel Com对象, 似乎只针对当前激活窗口的打开的表
excel := ComObjActive("Excel.Application")
return

f1::
	/*
	;----------------------------------------------
	try {										;~ 打开工作簿, 不知名原因报错, 但生效
		excel.Workbooks.Open("C:\Users\CUSong\Desktop\123.xlsx")
	}

	excel.Workbooks.close()						;~ 关闭当前工作簿, 生效

	;----------------------------------------------
	excel.Rows(5).Select						;~ 选中第5行

	;----------------------------------------------
	excel.Columns(1).Select						;~ 选中第1列


	;----------------------------------------------
	excel.Range["B1"].Value := "111111111111"	;~ 修改当前表格 B1 单元格的值

	a := excel.Range["A1"]						;~ 取得 A1 单元格 对象
	Loop, 20
	{
		a.Value :=  A_Index
		sleep, 200
	}

	;----------------------------------------------
	excel.selection.Value := "abcehgasdfh"		;~ 选择项某个单元格的值

	;----------------------------------------------
	excel.Range("A:C").columnwidth := 30		;~ 调整列宽

	;----------------------------------------------
	try {										;~ 创建新的工作表, 此方法会报错, 但生效,  故try
		excel.Workbooks.add
	}

	;----------------------------------------------
	MsgBox, % excel.selection.Value				;~ 获取选中的单元格的值


	;----------------------------------------------
	arr := excel.Range["A2:B30"].value			;~ 此非ahk数组
	arr.MaxIndex(1)   ; 总行数: 29  	(2 ~ 30)
	arr.MaxIndex(2)   ; 总列数: 2		(A + B)

	MsgBox, % arr[1, 2]

	*/

return


GuiClose:	; 表示当窗口关闭时脚本应自动退出.
ExitApp

