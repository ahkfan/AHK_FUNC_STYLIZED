#Persistent
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%

	gosub, FirstDeclare		;1.声明全局变量
	GUI_Cre()				;2.创建GUI
	showFightUI()			;4.显示战斗UI及role角色元素
	return



;声明变量
FirstDeclare:
	global pic_Path := % A_WorkingDir "\pic"	;设定图像路径
	global isFighting	;是否在战斗状态
	
	global backG	;背景图片_初始背景
	global role		;主控制角色
	return
	
;创建GUI	
GUI_Cre() {
	isFighting := 0
	Gui, Destroy
	pic_add("backG", 0, 0, 720, -1, "start.jpg")
	gui, -SysMenu -Caption
	Gui, show, h720 w720, Hexagon
	KeyWait, enter, D		;3.等待enter键被按下	
}

;在战斗UI下
showFightUI() {
	pic_add("role", 329, 335, 60, -1, "UI圆角六边形元素.png")
	pic_instead("backG", "fightUI.jpg")
	
	isFighting := 1
}


;增加图片元素
pic_add(picVname, x, y, w, h, picFileName) {
	gui,add, picture, BackgroundTrans  v%picVname% x%x% y%y% w%w% h-1, % pic_Path "\" picFileName
}

;图片替换
pic_instead(picV, insteadpicName) {
	GuiControl, , % picV, % pic_Path "\" insteadpicName
}
pic_move() {
	
}

~Esc::
		ExitApp

/*
在战斗中启用789456快捷键：
	7为左上移动
	8为向上移动
	9为右上移动
	4为坐下移动
	5为向下移动
	6为右下移动
*/
#if !isFighting

	
	
#if isFighting 
/*
	numpad7::
		
	return
	numpad8::
	numpad9::
	numpad4::
	numpad5::
	numpad6::
*/


