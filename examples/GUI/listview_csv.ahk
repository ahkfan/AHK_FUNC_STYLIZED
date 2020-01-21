Gui, add, listview, w200 h500 , 姓名|学号|身份证号
gui, show
FileRead, a,  % "C:\Users\Administrator\Desktop\新建文本文档.txt"
a := RegExReplace(a, "`r", "")
Loop, parse, a, % "`n"
	lv_add("", StrSplit(A_LoopField,",")*)
