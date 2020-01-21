#SingleInstance force
#Persistent
#NoEnv
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

searchingrange_list := [388, 115, 1135, 724] 	;搜索范围
picYellow1_obj := new img("黄1.png", searchingrange_list)
picGreen1_obj := new img("绿1.png", searchingrange_list)
picBrown1_obj := new img("棕1.png", searchingrange_list)
return

F1::
	maxsearchingloop := 5				;最大循环搜索次数
	allFound_Bool := false
	YRSTpos_list := false
	GRSTpos_list := false
	BRSTpos_list := false
	loop %maxsearchingloop% 
	{
		;若为空，则搜索
		if !YRSTpos_list
			YRSTpos_list := picYellow1_obj.GotPos_List() 
		if !GRSTpos_list
			GRSTpos_list := picGreen1_obj.GotPos_List() 
		if !BRSTpos_list
			BRSTpos_list := picBrown1_obj.GotPos_List() 
		
		;三处皆找到时
		if (YRSTpos_list && GRSTpos_list && BRSTpos_list) 
			allFound_Bool := true
	}

	if allFound_Bool {
		;三处皆找到时
		toAllx_int := BRSTpos_list[1] + 13
		
		
		
		
		Ynewyit_int1 := % YRSTpos_list[2] + 37
		Gnewyit_int1 := % GRSTpos_list[2] + 37

		YStartpos_list := [YRSTpos_list[1] + 123, Ynewyit_int1]
		GStartpos_list := [GRSTpos_list[1] + 48, Gnewyit_int1]

		toB_1_list := [toAllx_int, BRSTpos_list[2]  + 37]
		toB_2_list := [toAllx_int, BRSTpos_list[2]  + 87]
		toB_3_list := [toAllx_int, BRSTpos_list[2]  + 114]

		draglstols_pro(YStartpos_list, toB_1_list, 30) 
		draglstols_pro(GStartpos_list, toB_2_list, 30) 
		draglstols_pro(GStartpos_list, toB_3_list) 
		ToolTip, dragOver！
		Sleep 1000
	}
	else {
		ToolTip, nothingFound！
		Sleep 1000
	}
	tooltip
	return

draglstols_pro(pos1_list, pos2_list, slept_int := 10) {
	;将两个坐标列表进行拖行
	MouseClickDrag, L, % pos1_list[1], % pos1_list[2] , % pos2_list[1], % pos2_list[2], 0
	Sleep, % slept_int
}

Class miximg {
	__New(objs_list) {
		this.imgobjlist := []
		for i in objs_list
		{
			objofnowloop_obj := objs_list[i]
			this.imgobjlist.Insert(objofnowloop_obj)
		}
	}
	
	
	
}


Class img {
	__New(NameOrPath_str, searchrange_list, searchN_int := 10 , searchTC_str := false) {
		;图片路径
		if (!FileExist(NameOrPath_str) ) {
			MsgBox, % NameOrPath_str "`n图片不存在,脚本将退出"
			ExitApp
		}
		this.imgpath := NameOrPath_str
		
		this.lastGotpos_list := false			;上一次找到的坐标列表
		;搜索范围
		this.x1 := searchrange_list[1]
		this.y1 := searchrange_list[2]
		this.x2 := searchrange_list[3]
		this.y2 := searchrange_list[4]
		
		if searchN_int
		{
			this.SN := (" *" . searchN_int . " ")
		}
		else
			this.SN := " "
		
		if searchTC_str
			this.TC :=  (" *Trans" . searchTC_str . " ")
		else
			this.TC := ""
		
	}
	GotPos_List() {
		;搜图返回坐标
		ImageSearch, posx_int, posy_int, % this.x1, % this.y1, % this.x2 , % this.y2, % this.SN  this.TC this.imgpath
		if (!ErrorLevel) {
			this.lastGotpos_list := [posx_int, posy_int]
			return this.lastGotpos_list 
		}
		else
			return false
	}
}