

SetBatchLines, -1

/*
b := A_TickCount
Loop 100 {
	bezier2(120, 210, 120, 700, 300, 500, 80)
}
MsgBox, % "压缩后" . (A_TickCount - b)	;~ 97, 未最高速时, 94: 最高速时

b := A_TickCount
Loop 100 {
	bezier(120, 210, 120, 700, 300, 500, 80)
}
MsgBox, % "压缩前" (A_TickCount - b)		;~ 438: 未最高速时, 141: 最高速时
*/



f1::
	ls := bezier2(120, 210, 120, 700, 300, 500, 80)
	MouseMove, % ls[1, 1], % ls[1, 2]
	MsgBox, % ls_dbg(ls)
	ls.removeat(1)
	Send, {Lbutton down}
	for i, v in ls
		MouseMove, % v[1], % v[2]
	Send, {Lbutton up}
return

ls_dbg(ls) {								;~ 将列表内容返回为 [123, "aaa", ["123", 666]]样式的字符串, 适用于多维列表
	local rtStr := "", i, v
	if not isobject(ls) {
		if ls is number
			rtStr := ls
		else if (ls = "")
			rtStr = ""
		else
			rtStr = "%ls%"
	} else {
		rtStr := "["
		for i, v in ls
			rtStr .= ls_dbg(v) . ","
		if ls.count()
			StringTrimRight, rtStr, rtStr, 1
		rtStr .= "]"
	}
	return rtStr
}

bezier(sx, sy, ex, ey, cx, cy, pCounts) {
	/*
		sx	起点x
		sy	起点y
		ex	终点x
		ey	终点y
		cx	控制点x
		cy	控制点y
		pCounts	生成路径点数量: 最终
	*/
	pLs := [[sx, sy]]
	;~ 起始点到控制点的x和y每次的增量
	changeX1 := (cx - sx) / pCounts
	changeY1 := (cy - sy) / pCounts
	;~ 控制点到结束点的x和y每次的增量
	changeX2 := (ex - cx) / pCounts
	changeY2 := (ey - cy) / pCounts
	loop, %pCounts% {
		;~ 计算两个动点的坐标
		i := A_Index
		qx1 := sx + changeX1 * i
		qy1 := sy + changeY1 * i
		qx2 := cx + changeX2 * i
		qy2 := cy + changeY2 * i

		;~ 计算得到此时的一个贝塞尔曲线上的点坐标
		bx := qx1 + (qx2 - qx1) * i / pCounts
		by := qy1 + (qy2 - qy1) * i / pCounts
		pLs.Push([format("{:d}", bx), format("{:d}", by)])
	}
	return pLs
}

;~ 仅对bezier函数进行了压缩
bezier2(sx, sy, ex, ey, cx, cy, pCounts) {
	/*
		sx	起点x
		sy	起点y
		ex	终点x
		ey	终点y
		cx	控制点x
		cy	控制点y
		pCounts	生成路径点数量: 最终
	*/
	pLs := [[sx, sy]]
	loop, %pCounts% {
		qx1 := sx + ((cx - sx) / pCounts) * A_Index, qy1 := sy + ((cy - sy) / pCounts) * A_Index
		pLs.Push([format("{:d}", qx1 + ((cx + ((ex - cx) / pCounts) * A_Index) - qx1) * A_Index / pCounts), format("{:d}", qy1 + ((cy + ((ey - cy) / pCounts) * A_Index) - qy1) * A_Index / pCounts)])
	}
	return pLs
}
