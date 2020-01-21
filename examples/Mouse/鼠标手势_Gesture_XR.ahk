/* 注释:
;~ 这个是鼠标手势, 个人感觉精度还凑合
;~ 为了不吃性能的亏, 努力压缩了代码, 虽然写得还是不太精简
;~ 本人数学不太好, 角度那一段看了请别笑0.0
;~ 在拐角处可以稍微停顿提高精度

;~ 函数说明:
	1. GetGesture(MinRecord, MSecFresh)	;~ 获取手势数字
		;~ 参1 最短判断角度距离
		;~ 参2 停顿判定
	2. TransGesture(key)							;~ 将获取的手势数字字符串转换为方向符号字符串
	3. Angle(x1, y1, x2, y2)						;~ 取两个坐标的夹角, 区间[0, 360]
	4. Angle2Key(a)									;~ 将夹角转换为单个数字, 取值 789 46 123, 表方向


;~ 定义热键说明:
	RButton:: 右键 执行, 显示手势结果
	Space::	  空格 挂起热键

;~	Author: 虚荣		date: 2019/09/07
*/

#SingleInstance Force
#NoEnv
#InstallKeybdHook
#InstallMouseHook
#Persistent
SetDefaultMouseSpeed,0
return

RButton::
	key := GetGesture_RButton(100, 300)
	ToolTip, % "手势键表: " key "`n图型字符: " TransGesture(key)
return

space::Suspend

GetGesture_RButton(MinRecord, MSecFresh) 
{
	/*
	Key_WaiUp 键弹起之前记录鼠标方向, 返回一串数字表方向, 789 46 123 这 8 个数字
		7	8	9

		4	5	6

		1	2	3
	*/
	local x1, y1, x2, y2
	local result := ""
	local exKey := ""
	local key := ""
	local t := A_TickCount

	MouseGetPos, x1, y1
	Loop {
		MouseGetPos, x2, y2
		if (x1 <> x2 && y1 <> y2)  
		{
			if (floor(Sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)) >= MinRecord) 
			{
				key := Angle2Key(Angle(x1, y1, x2, y2))
				if (exKey <> key)
				{
					exKey := key, result .= key
				}	
				x1 := x2, y1 := y2, t := A_TickCount
			}
		}
		if result && (A_TickCount - t >= MSecFresh)
		{
			x1 := x2, y1 := y2, t := A_TickCount
		}
	} until not GetKeyState("RButton", "P")
	return result
}

Angle2Key(a) 
{
	;~ 将角度转换为方向键
	if (a >= 0 && a <= 22) or (a >= 338 && a <= 360)
		return 8	;~ 上
	else if (a >= 23 && a <= 67)
		return 9	;~ 右上
	else if (a >= 68 && a <= 112)
		return 6	;~ 右
	else if (a >= 113 && a <= 157)
		return 3	;~ 右下
	else if (a >= 158 && a <= 202)
		return 2	;~ 下
	else if (a >= 203 && a <= 247)
		return 1	;~ 左下
	else if (a >= 248 && a <= 292)
		return 4	;~ 左
	else if (a >= 293 && a <= 337)
		return 7	;~ 左上
}


Angle(x1, y1, x2, y2) 
{
	;~ 返回x2 y2 相对 x1 y1 的角度, 由x1 y1为原点的 y正轴 为起点, 区间[0, 360]
	;~ 返回 -1 为两坐标相等
	y := abs(y1 - y2)
	a := floor(180 / (3.14159 / acos(y / Sqrt(abs(x1 - x2) ** 2 + y ** 2))))
	if (x2 <> x1 && y2 <> y1)
		return (x2 > x1) ? (y2 < y1 ? a : 180 - a) : (y2 < y1 ? 360 - a : 180 + a)
	else if (x2 = x1) && (y1 = y2)
		return -1
	else if (y2 = y1)
		return (x2 > x1) ? 90 : 270
	else if (x2 = x1)
		return (y1 > y2) ? 180 : 0
}


TransGesture(key) 
{
	;~ 将数字键 转换为 方向字符
	static dict := {8: "↑",9: "↗",6: "→",3: "↘",2: "↓",1: "↙",4: "←",7: "↖"}
	local i, v, k := ""
	for i, v in StrSplit(key)
		k .= dict[v]
	return k
}