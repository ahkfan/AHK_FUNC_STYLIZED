CoordMode, Mouse, Screen	;设定全屏定点
#Persistent
#SingleInstance force
;~设定启用功能按键
startkey_str = F1				
Hotkey, if, true	;不可舍
Hotkey, %startkey_str% , start_lable, on
MainPic_W := 534
MainPos_X := (A_ScreenWidth - MainPic_W) / 2
MainPos_Y := 50

;~首要声明
tagGUIID_list := []
clickPos_list := []				;记录点击位置的列表，首位为拖行起点

dragspeed_int := 0			;拖行速度，越低越快
msmvspeed_int := 0			;返回原点速度,默认最快
backsleep_int := 0					;拖行后返回原点的休憩时间
isnowjob_bool := false		;判定是否启动工作
return

#if true		;默认始终执行
start_lable:
	;启动或关闭工作
	if (isnowjob_bool := !isnowjob_bool)	{
		;当前为工作状态时
		newgui_dir := picOnlyAlphaGUI_rtStr(, A_ScriptDir "\1.png", [MainPos_X,MainPos_Y], 200) 
	}
	else {
		;当前退出工作状态时
		gosub, Exitalltag_lable
	}
	return

Exitalltag_lable:
	;* 退出工作功能

	clickPos_list := []
	
	isnowjob_bool := false
	;* 关闭所有小标签窗口
	traytip, , 退出当前拖行工作, 1
	if (tagGUIID_list.MaxIndex())
	{
		for i in tagGUIID_list
		{
			thisGUI := tagGUIID_list[i]
			gui, %thisGUI%:Destroy
		}
	}	
	tagGUIID_list := []
	;* 销毁当前脚本的窗口
	theName_str := newgui_dir["name"]
	if WinExist(theName_str)
		gui, %theName_str%:Destroy
	return

#if isnowjob_bool	;isnowjob_bool该值判断是否启用标签

esc::
	;* 此处esc仅用于判断关闭
	gosub, Exitalltag_lable
	return
;1::
LButton up::
	;* 鼠标弹起时记录选取范围
	MouseGetPos, xx, yy
	nowclicklist := [xx, yy]
	clickPos_list.Insert(nowclicklist)
	thisTagName := % "workingtagGui" . clickPos_list.MaxIndex()
	tagGUIID_list.insert(thisTagName)
	tagPos_x := % xx - 10
	tagPos_y := % yy - 10
	if (clickPos_list.MaxIndex() = 1)
		picOnlyAlphaGUI_rtStr(thisTagName, A_ScriptDir "\A.png", [tagPos_x,tagPos_y] , 200)
	else
		picOnlyAlphaGUI_rtStr(thisTagName, A_ScriptDir "\B.png", [tagPos_x,tagPos_y], 200) 
	nowclicklist := 
	;* 创建标签,以列表长度判断，首位为起始标签，其后为小标签
	
	return

Enter::
	;开始拖行
	IF (clickPos_list.MaxIndex() <= 1)  {
		;* 没有拖行工作列表时
		TrayTip, ,尚未选取工作区域`n退出当前拖行工作, 1
		gosub, Exitalltag_lable
		return
	}
	for i in clickPos_list
	{
			IF (clickPos_list.MaxIndex() = i) 
				break
			if backsleep_int
				Sleep % backsleep_int
			;* 关闭当前移动至的子标签窗口
			MouseMove, % clickPos_list[1][1], % clickPos_list[1][2], %msmvspeed_int%
			MouseClickDrag, l, % clickPos_list[1][1], % clickPos_list[1][2], % clickPos_list[i + 1][1], % clickPos_list[i + 1][2], %dragspeed_int%
			
			thisdelGuiName := % "workingtagGui" . (i + 1)
			;Click, 1198, 178
			if WinExist(thisdelGuiName)
				Gui, %thisdelGuiName%:Destroy
			if (thishotkey_str() == "esc")
				break
	}
	gosub, Exitalltag_lable
	return

thishotkey_str() {
	nowit_str := A_ThisHotkey
	nowit_str .= " "
	StringTrimRight, nowit_str, nowit_str, 1
	return nowit_str
	}

lstostr_rtStr(lsName) {
	;传入参数为0或空,返回0,
	;为真非数组返回-1
	;为数组时返回带括号的字符串
	if !lsName				;为假或为空时
		return 0
	if !islist_rtBool(lsName) 	;为真，非数组时
		return -1
	临时字符串 := 
	for i in lsName
		{
		if (i = 1)
			临时字符串 := lsName[i]
		else
			临时字符串 := % 临时字符串 . ", " . lsName[i]
		}
	临时字符串 := % "[" 临时字符串 "]"
	return 临时字符串
	}
	
	islist_rtBool(lsName) {
	;判断是否为列表，是列表返回1，否则返回0
	lsName.insert(1)
	if (!lsName.MaxIndex())
		return 0
	else {
		lsName.Remove(lsName.MaxIndex())
		return 1
		}
	}
	
picOnlyAlphaGUI_rtStr(guiName_str :=  "picOnlyAlphaGUI", picLP_str := false, guiPos_list := false, alphaV_int := false ,guicolorTrans_str := "ffffff",guiDisable_bool := true) {
	global
	;创建带透明度的纯图片GUI
	;参1：gui名称，取变量名同等名称
	;参2 : 唯一图片长路径
	;参3 : gui位置列表, 如[0, 0]
	;参4 : 透明度, 默认无透明度,优先于颜色透明
	;参5: 设定某颜色为透明 ,默认白色
	;参6 : 是否禁用窗口且点击穿透,默认禁用
	
	if !WinExist(guiName_str) {
		syswinadwid_int := 6
		syswinadhei_int := 26
		Gui, %guiName_str%:new
		;GUI选项
		Gui, %guiName_str%: +AlwaysOnTop   +ToolWindow +Hwnd%guiName_str%_ID ;+Disabled
		if  (picLP_str) && fileexist(picLP_str){
			;存在图片时
			Gui, %guiName_str%:Add, Picture, v%guiName_str%picName x0 y0, %picLP_str%
			GuiControlGet, %guiName_str%picName, Pos
		}
		else {
			;不存在图片时
			MsgBox, picture doesnt exist！`ngui will being Destroy
			gui, %guiName_str%:Destroy
			return false
		}
		;此为图片宽高获取
		__PICWW := % guiName_str "picNameW"
		__PICHH := % guiName_str "picNameH"
		__PICWW := % %__PICWW% 
		__PICHH := % %__PICHH% 
		if not guiPos_list 
			;无设定坐标时, 居中
			Gui, %guiName_str%: Show,  % " w" .  __PICWW " h" .  __PICHH " Center NA", %guiName_str%
		else {
			;有设定坐标时，不居中
			__GUIXXX := guiPos_list[1]
			__GUIYYY := guiPos_list[2]
			guiGpos_str := % " x" __GUIXXX " y" __GUIYYY  " w" .  __PICWW " h" .  __PICHH " NA"
			Gui, %guiName_str%: Show,  %guiGpos_str%, %guiName_str%
		}
		;此为新窗口id
		__theid2 := % guiName_str . "_ID"
		__theid := % "ahk_ID " %__theid2%
		;透明度参数

		;取消边框，调整窗口位置
		gui, %guiName_str%: -caption -toolwindow
		__PICWW += syswinadwid_int
		
		if (guiPos_list = false) 
			Gui, %guiName_str%: Show,  % " w" .  __PICWW " h" .  __PICHH " Center NA", %guiName_str%
		else
			Gui, %guiName_str%: Show,  % guiGpos_str, %guiName_str%
		if guicolorTrans_str
			WinSet, TransColor, % guicolorTrans_str , %guiName_str%
		if alphaV_int
			winset, Transparent, %alphaV_int%, % __theid
		
		;设定点击穿透
		if guiDisable_bool {
			Gui, %guiName_str%: +Disabled
			WinSet, ExStyle, +0x20, % __theid
			}
	}
	;返回gui名称和可用窗口id
	return  % { "name" : guiName_str, "id" : __theid}
}