#SingleInstance force

方块文件夹 := % A_ScriptDir "\分块参数配置"
初始配置项目 := [10, 10, 3, 1, 0]
Cre_EpFd(方块文件夹)

文件夹非空 := 0
Loop, % 方块文件夹 "\*.txt"
	文件夹非空 := A_Index
if !文件夹非空
	lsWriteToFile(初始配置项目, 方块文件夹 "\初始配置项目.txt" )

GUI, 参数修改: NEW
GUI, 参数修改: +toolwindow +AlwaysOnTop

编辑框宽 := 133

GUI, 参数修改: add, ListBox, g项目盒子 v项目盒子 h230, |
GUI, 参数修改: add, Text, , 双击修改项目名称
GUI, 参数修改: add, button, g添加项目 h50 w%编辑框宽%, 添加方块项目
GUI, 参数修改: add, button, g删除项目 w%编辑框宽%, 删除选中项目

GUI, 参数修改: add, Text, , 项目名称:
GUI, 参数修改: add, Edit, ReadOnly w%编辑框宽%  v项目名称

GUI, 参数修改: add, Text, , 横向方块数:
GUI, 参数修改: add, Edit, ReadOnly w%编辑框宽%  v横块, % 方块函数参数列表[1]
GUI, 参数修改: add, Text, , 纵向方块数:
GUI, 参数修改: add, Edit, ReadOnly w%编辑框宽%  v纵块, % 方块函数参数列表[2]
GUI, 参数修改: add, Text, , 方块间隔半像素:
GUI, 参数修改: add, Edit, ReadOnly w%编辑框宽%  v间数, % 方块函数参数列表[3]
GUI, 参数修改: add, Text, , 拖行速度:
GUI, 参数修改: add, Edit, ReadOnly w%编辑框宽%  v移速, % 方块函数参数列表[4]
GUI, 参数修改: add, Text, , 拖行间隔时长:
GUI, 参数修改: add, Edit, ReadOnly w%编辑框宽%  v拖间, % 方块函数参数列表[5]

GUI, 参数修改: add, button, g启/禁用更改, F12启动/上传参数更改

参数窗口x位置 := % A_ScreenWidth - 300
参数窗口Y位置 := % A_ScreenHeight - 700
GUI, 参数修改: show, x%参数窗口x位置% y%参数窗口Y位置%

global 左上起点x
global 左上起点y
global 右下终点x
global 右下终点y
gosub, 完善项目盒子列表
return

完善项目盒子列表:
	guicontrol, , 项目盒子, |
	Loop, % 方块文件夹 "\*.txt"
	{
		if (A_Index == 1) 
			guicontrol, , 项目盒子, % "|" 获取无后缀的文件名(A_LoopFileName) "||"
		else
			guicontrol, , 项目盒子, % 获取无后缀的文件名(A_LoopFileName)
		}
	gosub, 刷新编辑控件
	return

刷新编辑控件:
	gui,submit,nohide
	方块函数参数列表 := readFileLineLs(方块文件夹 "\" 项目盒子 ".txt")
	GuiControl, , 项目名称, % 项目盒子
	guicontrol, , 横块, % 方块函数参数列表[1]
	guicontrol, , 纵块, % 方块函数参数列表[2]
	guicontrol, , 间数, % 方块函数参数列表[3]
	guicontrol, , 移速, % 方块函数参数列表[4]
	guicontrol, , 拖间, % 方块函数参数列表[5]
	return

添加项目:
	新文件名 := 
	InputBox,  新文件名, 请输入新项目名称, 留空放弃修改	
	if 新文件名
		{
		if fileexist(方块文件夹 "\" 新文件名 ".txt") {
			msgbox, 该项目：%新文件名%`n已存在！`n请修改或删除原始文件
			return
			}
		else {
			FileAppend, % "10`r`n10`r`n3`r`n1`r`n0", % 方块文件夹 "\" 新文件名 ".txt"
			sleep 100
			guicontrol, , 项目盒子, 新文件名||
			}
		gosub, 完善项目盒子列表
		}
	return
	
删除项目:
	gui,submit,nohide
	Del_Fil(方块文件夹 "\" 项目盒子 ".txt")
	gosub, 完善项目盒子列表
	return

项目盒子:
	gosub, 刷新编辑控件
	if (a_guievent == "DoubleClick") {
		原始文件名 := 项目盒子
		新文件名 := 
		InputBox,  新文件名, 请输入新项目名称, 原始项目名称：%原始文件名%`n留空放弃修改
		if (新文件名) {
			FileMove, % 方块文件夹 "\" 原始文件名 ".txt", % 方块文件夹 "\" 新文件名 ".txt" , 1
			gosub, 完善项目盒子列表
			}
		return
		}
	return
	
F12::
启/禁用更改:
	if (启禁控件 := !启禁控件) {
		GuiControl, -readonly, 横块
		GuiControl, -readonly, 纵块
		GuiControl, -readonly, 间数
		GuiControl, -readonly, 移速
		GuiControl, -readonly, 拖间
		}
	else {
		gui,submit,nohide
		方块函数参数列表 := [横块, 纵块, 间数, 移速, 拖间]
		lsWriteToFile(方块函数参数列表, 方块文件夹 "\" 项目盒子 ".txt")
		GuiControl, +readonly, 横块
		GuiControl, +readonly, 纵块
		GuiControl, +readonly, 间数
		GuiControl, +readonly, 移速
		GuiControl, +readonly, 拖间
		}
	return

f2::
	CoordMode, mouse, screen
	等待按下超时 := 1
	等待弹起超时 := 10
	
	ToolTip, 等待按下鼠标左键`n1秒后超时
	keywait, lbutton, DT%等待按下超时%
	if errorlevel {
		ToolTip
		return
		}
	mousegetpos, 左上起点x, 左上起点y
	
	ToolTip, 长按鼠标移动至选取范围右下角
	keywait, lbutton, T%等待弹起超时%
	if errorlevel {
		traytip, , 超时未选取`n功能失效, 1
		ToolTip
		return
		}
	mousegetpos, 右下终点x, 右下终点y
	
	ToolTip
	gosub, 创建范围
	return

创建范围:
	global 大矩形宽 := % 右下终点x - 左上起点x
	global 大矩形高 := % 右下终点y - 左上起点y
	Gui, 子窗口: new
	Gui, 子窗口: color, 000000, 000000
	GUI, 子窗口: ADD, text, cffffff,Enter回车执行创建小矩形`nEsc退出`n拖行中按下esc退出循环
	Gui, 子窗口: +hwndtheID_FANWEI -Caption +AlwaysOnTop
	Gui, 子窗口: show, x%左上起点x% y%左上起点y% w%大矩形宽% h%大矩形高% NA, 显示范围
	WinSet, trans, 100, % "ahk_ID " theID_FANWEI
	WinSet, ExStyle, +0x20, % "ahk_ID " theID_FANWEI
	return
	
执行创建功能:
	if (!方块函数参数列表.MaxIndex())
		拖行试验()
	else
		拖行试验(方块函数参数列表[1], 方块函数参数列表[2], 方块函数参数列表[3], 方块函数参数列表[4], 方块函数参数列表[5])
	return
	

拖行试验(横向方块数 := 50, 纵向方块数 := 1, 方块半间隔长像素 := 3, 拖行速度 := 1, 拖行休憩间隔 := 0) {
	;大范围坐标列表 := [左上x, 左上y, 右下x, 右下y]  
	CoordMode, mouse, screen
	x坐标起点表 := []
	y坐标起点表 := []
	
	x坐标终点表 := []
	y坐标终点表 := []
	
	Loop %横向方块数% {
		x坐标起点表.insert(左上起点x + (大矩形宽 /横向方块数) * (A_Index - 1) - 方块半间隔长像素)
		x坐标终点表.insert(左上起点x + (大矩形宽 /横向方块数) * A_Index + 方块半间隔长像素)
		}

	loop %纵向方块数% {
		y坐标起点表.insert(左上起点y + (大矩形高 /纵向方块数) * (A_Index - 1) - 方块半间隔长像素)
		y坐标终点表.insert(左上起点y + (大矩形高 /纵向方块数) * A_Index + 方块半间隔长像素 )
		}
	
	loop %横向方块数%  {
		横值位 := A_Index
		loop, % 纵向方块数
		{
			if getkeystate("esc")
				return
			纵值位 := A_Index
			MouseClickDrag, L, % x坐标起点表[横值位], % y坐标起点表[纵值位], % x坐标终点表[横值位], % y坐标终点表[纵值位], % 拖行速度
			sleep %拖行休憩间隔%
			sendsleep("d", 100)
			sendsleep("{enter}", 100)
			}
		}
	CoordMode, mouse, window
	return
	}

获取无后缀的文件名(theFileName) {
	RegExMatch(theFileName, "(*UCP)^(.+)\.\w{1,5}$", 搜寻块)
	return % 搜寻块1
	}

sendsleep(str, slept) {
	;发送并休眠间隔
	send, % str
	sleep, % slept
	}

Cre_EpFd(fodLP) { 
	;创建空白  文件夹  ，若存在文件夹，则不动作
	IfNotExist, % fodLP
	{
		FileCreateDir, % fodLP
		Loop {
			IfExist, % fodLP
				Break
			}
		}
	}

readFileLineLs(filLP) {
	;将文件行返回列表
	empls := []
	Loop, read, % filLP
		empls.insert(A_LOOPREADLINE)
	if empls
		return % empls
	else
		return 0
	}

lsWriteToFile(THELS, filLP) {
	;列表写入覆盖文件
	Del_Fil(filLP)
	for i in THELS
		{
		if (i = 1)
			临时字符串 := THELS[i]
		else
			临时字符串 := % 临时字符串 "`r`n" THELS[i]
		}
	文件对象 := FileOpen(filLP, "w")
	文件对象.Write(临时字符串)
	文件对象.Close()
	}

Del_Fil(filLP) { ;删除文件直到区确定无该文件
	Loop {
		IfExist, % filLP
			FileDelete, % filLP
		IfNotExist, % filLP
			break
		}
	}

Cre_EpFi(filLP) { ;创建空白  文件  ,若存在文件，不动作
	IfNotExist, % filLP
		{
		FileAppend, , % filLP, UTF-8
		Loop {
			IfExist % filLP
				break
			}
		}
	}

#IfWinExist 显示范围
Enter::
	keywait, enter
	Gui, 子窗口: DESTROY
	gosub, 执行创建功能
	return
	
esc::
	Gui, 子窗口: DESTROY
	return