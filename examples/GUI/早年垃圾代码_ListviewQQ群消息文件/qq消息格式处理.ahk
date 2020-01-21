#SingleInstance force
#NoEnv

dfwd_int := A_ScreenWidth / 2
dfhe_int := A_ScreenHeight / 3 * 2
dfx_int := A_ScreenWidth  - dfwd_int - 150
dfy_int := A_ScreenHeight - dfhe_int - 150

gui, font, , 微软雅黑
gui, +MaximizeBox +AlwaysOnTop +Hwnd此窗口的id
gui, add, ListView, w%dfwd_int% h%dfhe_int% gthelistview_control Grid vmsglist_control , No.|间隔|昵称|消息内容|时间|QQ号|	;
gui, add, Text,vthetext1 ,注1：将qq消息导出的txt文件拖入该程序窗口 `n注2：消息为倒序显示`n注3：shift + 左键多选按ctrl + c复制消息内容`n注4：双击行复制qq号
gui, show,x%dfx_int% y%dfy_int% , QQ消息文本处理工具v1.0 - Author: CUSong    QQID: 365947335
此窗口的id := % "ahk_id " 此窗口的id
return

GuiClose:
	ExitApp

GuiSize:
	wd := A_GuiWidth  - 20
	he := A_GuiHeight - 100
	y2 := A_GuiHeight - 90
	GuiControl, Move, msglist_control, w%wd% h%he%
	GuiControl, Move, thetext1, y%y2%
	return
	
#If WinActive(此窗口的id)
^c::
	Clipboard := 
	RowNumber = 0  ; 这样使得首次循环从列表的顶部开始搜索.
	nowclipmsg_list := []
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(Text, RowNumber)
		;MsgBox The next selected row is #%RowNumber%, whose first field is "%Text%".
		nowclipmsg_list.Insert(Text)
	}
	if (nowclipmsg_list.MaxIndex()) {
		lssort_rtLs(nowclipmsg_list)	; 排序获取的序号
		nowqq_itstr := 
		for i in nowclipmsg_list
		{
			if (i = 1) {
				nowqq_itstr := totalmsg_list[nowclipmsg_list[i]]["qqnum"]
				strneed_now := % ">>> " totalmsg_list[nowclipmsg_list[i]]["name"] "<<<"
				strneed_now := % strneed_now "`n" mklstostr_rtStr(totalmsg_list[nowclipmsg_list[i]]["msg"], "`r`n") 
			}
			else
			{
				if (totalmsg_list[nowclipmsg_list[i]]["qqnum"] = nowqq_itstr)
					strneed_now := % strneed_now "`r`n" mklstostr_rtStr(totalmsg_list[nowclipmsg_list[i]]["msg"], "`r`n") 
				else
				{
					nowqq_itstr := totalmsg_list[nowclipmsg_list[i]]["qqnum"]
					strneed_now := % strneed_now "`r`n`r`n>>> " totalmsg_list[nowclipmsg_list[i]]["name"] "<<<"
					strneed_now := % strneed_now "`r`n" mklstostr_rtStr(totalmsg_list[nowclipmsg_list[i]]["msg"], "`r`n") 
					
				}
			}
		}
		Clipboard := strneed_now
		ClipWait, 0.5
		if Clipboard
		{
			TrayTip, , 信息已复制到剪切板, 0.5
			sleep 500
		}
	}
	return

thelistview_control:
	;列表控件事件
	if (a_guievent == "DoubleClick") {
		LV_GetText(numofcli_int, A_EventInfo , 6)	;~ qq号
		LV_GetText(nameofcli_int, A_EventInfo , 3)	;~ qq昵称
		clipboard := 
		clipboard := numofcli_int
		ClipWait, 1
		TrayTip, , % nameofcli_int "`n的qq号已经复制到粘贴板"
	}
	return

GuiDropFiles:
	;~拖行文件至窗口时生效
	LV_Delete()
	;一般消息格式{"time" : 时间戳_int, "qqnum" : qq号_int, "name" : 名字_str, "msg" : 按行分列表_list}
	totalmsg_list := gotqqmsginfo_rtLs(A_GuiEvent)	;~ 获取字典列表
	
	列表长 := totalmsg_list.MaxIndex()
	当前qq号 := 
	完成检索qq号列表 := []
	for 序号 in totalmsg_list
	{
		当前序号 := 列表长 - 序号 + 1
		当前qq号 := totalmsg_list[当前序号]["qqnum"]
		
		if (isvarinlist_rtBool(当前qq号, 完成检索qq号列表))	;~ 若已在检索列表中,跳过
			continue
		else
			完成检索qq号列表.Insert(当前qq号)
		
		;~ 未经历检索时
		
		当前名称 := totalmsg_list[当前序号]["name"]
		
		可用名称 := 
		loop, %当前序号%
		{
			当前倒序点 := (列表长 - (列表长 - 当前序号) - A_Index + 1)
			当前循环至qq号 := totalmsg_list[当前倒序点]["qqnum"]
			if (当前循环至qq号 != 当前qq号)
				;~ 若当前qq号不等于需要遍历的qq,跳过
				continue
				
			当前循环至qq名 := totalmsg_list[当前倒序点]["name"]
			if (!InStr(当前循环至qq名, 当前qq号) && 当前循环至qq名)
			{
				可用名称 := 当前循环至qq名
				break
			}
		}
		if (!可用名称)
			可用名称 := 当前qq号
		for i, d in totalmsg_list
		{
			如此qq号 := d["qqnum"]
			if (如此qq号 = 当前qq号)
				totalmsg_list[i]["name"] := 可用名称
		}
	}
	
	doneqq_list :=
	for i in totalmsg_list
	{
		i := 列表长 - i + 1
		序号 := i
		if (i = 1)
			消息间隔 := 0
		else {
			本次消息时间 := totalmsg_list[i]["time"]
			上次消息时间 := totalmsg_list[i - 1]["time"]
			本次消息时间 -= 上次消息时间, s
			消息间隔 := sectimetoF_rtStr(本次消息时间)
		}
		
		
		昵称 := % totalmsg_list[i]["name"]
		
		消息内容 := totalmsg_list[i]["msg"]
		消息内容 := mklstostr_rtStr(消息内容, "</>")
		
		时间 := totalmsg_list[i]["time"]
		
		QQ号码 := totalmsg_list[i]["qqnum"]
		
		LV_Add(, 序号, 消息间隔, 昵称, 消息内容, 时间, QQ号码)
	}
	LV_ModifyCol(1, "Integer Center AutoHdr")
	LV_ModifyCol(2, "Center AutoHdr")
	LV_ModifyCol(3, "right AutoHdr")
	LV_ModifyCol(4, "left 800")
	LV_ModifyCol(5, "Integer Center AutoHdr")
	LV_ModifyCol(6, "Center AutoHdr")
	return

lssort_rtLs(listName_list, mode_sort := 1) {
	;~ 	原始按从小到大排序
	for i in listName_list
	{
		loopnum := (listName_list.MaxIndex() - i)
		loop, %loopnum%
		{
			asdf := listName_list[i]
			abnad := listName_list[A_Index + i]
			if (mode_sort ? (asdf > abnad) : (asdf < abnad))
			{
				at := listName_list[i]
				listName_list[i] := listName_list[A_Index + i]
				listName_list[A_Index + i] := at
			}
		}
	}

}
isvarinlist_rtBool(var, listName_list) {
	;~ 判断元素是否在列表中
	if (listName_list.maxindex()) {
		for i in listName_list
		{
			if (listName_list[i] = var)
				return 1
		}
	}
	return 0
}

sectimetoF_rtStr(sectime_int, sec_str := "秒", min_str := "分",  hour_str := "时", day_str := "天") {
	;将秒数转换为时分秒天的格式
	thissec_str := % Mod(sectime_int, 60) sec_str
	if (!(sectime_int // 60))
		;~ 剩余分钟数无余
		return % thissec_str
	
	lastmin_int := sectime_int // 60
	thismin_str := % Mod(lastmin_int, 60) min_str
	if (!(lastmin_int // 60))
		;~ 剩余小时数无余
		return % thismin_str thissec_str

	lasthour_int := lastmin_int // 60
	thishour_str := % Mod(lasthour_int, 24) hour_str
	if (!(lasthour_int // 24))
		return % thishour_str thismin_str thissec_str
	
	lastday_int := lasthour_int // 24
	thisday_str := % lastday_int day_str
	return % thisday_str thishour_str thismin_str thissec_str
	
}

gotqqmsginfo_rtLs(fileLP_str) {
	/*  将qq列表信息转化为字典元素单位的列表
	  *  一般消息格式{"time" : 时间戳_int, "qqnum" : qq号_int, "name" : 名字_str, "msg" : 按行分列表_list}
	  */
	  
	;~ 将文件中所有行数转为列表
	TotalLine_list := filelinetols(fileLP_str)
	;~ 删除列表中空行
	lsdelnone_rtBool(TotalLine_list) 
	;~ 最终输出列表
	qqmsgdict_list := []
	;~ 文件中所有行数
	lsmaxIndex_int := TotalLine_list.MaxIndex()
	;~ 下一轮消息坐标
	nextStarHead_int := false
	for I in TotalLine_list
	{
		if ((!nextStarHead_int) || (nextStarHead_int && (nextStarHead_int = i))) {
			nowline_str := TotalLine_list[I]
			if RegExMatch(nowline_str, "(*UCP)^\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{2}:\d{2}\s.*[\(,<].+[\),>]$") {
				;~ mHeadPos_int 消息头坐标 
				mHeadPos_int := i
				;~ dicttime_str 获得消息时间戳
				RegExMatch(nowline_str, "(*UCP)^(\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{2}:\d{2})\s.*[\(,<].+[\),>]$", nowTT_str)
				dicttime_str := clearqqmsgtime_rtInt(nowTT_str1)
				if (StrLen(dicttime_str) = 13) {
					LSIT := mkstrtols_rtLs(dicttime_str)
					LSIT.Insert(9, "0")
					dicttime_str := mklstostr_rtStr(LSIT)
				}
				;~ dictQnum_int 获得qq号
				RegExMatch(nowline_str, "(*UCP)^\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{2}:\d{2}\s.*[\(,<](.+)[\),>]$", nowQQnum_int)
				dictQnum_int := nowQQnum_int1
				;~ dictname_str 获得昵称
				if RegExMatch(nowline_str, "(*UCP)^\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{2}:\d{2}\s(.*)[\(,<].+[\),>]$", NAME_int)
					dictname_str := NAME_int1
				else
					dictname_str := ""
				
				msgNow_ls := []
				loop {
					;~ 获取信息字符串
					nowIndexFromMsg_int := I + A_Index
					nowSearchingLine_str := TotalLine_list[nowIndexFromMsg_int]
					if RegExMatch(nowSearchingLine_str, "(*UCP)^\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{2}:\d{2}\s.*[\(,<](.+)[\),>]$") 
					{	;~ r若当前行为消息头，跳过
						nextStarHead_int := nowIndexFromMsg_int
						break
					}
					else
						msgNow_ls.insert(nowSearchingLine_str)
					if (nowIndexFromMsg_int >= (lsmaxIndex_int - 1))
						;~ 如果当前到达列表末尾，退出
						break
				}
				;组成字典信息
				qqmsgdict_list.Insert({"time" : dicttime_str,"qqnum" :  dictQnum_int, "name" :  dictname_str, "msg" :  msgNow_ls})
			}
		}
	}

	return qqmsgdict_list
}

mklstostr_rtStr(input_ls, deli_str := "") {
	;将列表拼接为字符串
	if input_ls.MaxIndex() {
		ddstr := ""
		if deli_str {
			for i in input_ls
			{
				if (i = 1)
					ddstr .= input_ls[i]
				else
					ddstr := % ddstr deli_str input_ls[i]
			}
		}
		else {
			for i in input_ls
				ddstr .= input_ls[i]
		}
		return ddstr
	}
	return false
}

mkstrtols_rtLs(inputstr_str) {
	;将字符串解析为列表
	strls_ls := []
	Loop, Parse, inputstr_str
		strls_ls.Insert(A_LoopField)
	if strls_ls.MaxIndex()
		return strls_ls
	else
		return false
}

clearqqmsgtime_rtInt(InputVar) {
	InputVar := RegExReplace(InputVar, "-" )
	InputVar := RegExReplace(InputVar, ":" )
	InputVar := RegExReplace(InputVar, "\s" )
	return InputVar
}

lsdelnone_rtBool(lsName) {
	;删除列表中所有空值元素
	lsLen_int:= lsName.MaxIndex()
	loop, % (lsLen_int) 
	{
		nowIndex_int := (lsLen_int - A_Index + 1)	;当前查找
		nowLoopVar := lsName[nowIndex_int]		;当前查找
		if ((!nowLoopVar) && (nowLoopVar != 0)) {
			lsName.Remove(nowIndex_int)
			existNone_Bool := 1
			}
	}
	ToolTip
	return existNone_Bool
}

filelinetols(fileLP) {
	nowls := []
	loop, read, % fileLP
		nowls.insert(A_LoopReadLine)
	return nowls
}

