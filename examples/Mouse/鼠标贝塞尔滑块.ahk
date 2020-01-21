CoordMode, mouse, screen

f1::Drag_Bezier([94, 571], [464, 567], 1000)


Drag_Bezier(sPos, ePos, EndSlept) {

	cPos := bezier_RandCP(sPos, 60, 30, ePos, 30, 20)
	ls := bezier(sPos[1], sPos[2], ePos[1], ePos[2], cPos[1], cPos[2], 80)

	;MsgBox, % ls_dbg(ls) "`n`n" ls_dbg(bezier2(sPos[1], sPos[2], ePos[1], ePos[2], cx, cy,50))

	MouseMove, % ls[1][1], % ls[1][2], 0
	dm.MoveTo(ls[1][1], ls[1][2])
	Sleep, 200

	send, {Lbutton down}
	ls.removeat(1)

	RandAll(ls, 3)
	RandDel(ls, 3)
	RandAddLast(ls)

	startSlept := 135
	Sub := 3
	minSlept := rand(10, 25)
	for i, v in ls {
		mousemove, % v[1], % v[2]

		if (A_Index < 100)
			s :=  ((startSlept -= Sub) >= minSlept) ? startSlept : minSlept
		else
			s := % rand(30, 90)
		Sleep, % s
	}

	Sleep, % Rand(1000, 2500)
	send, {lbutton up}
	Sleep, % EndSlept
}

RandAddLast(ls) {
	;~ 最后的点
	pLast := ls[ls.MaxIndex()]
	p := [pLast[1] + rand(20, 10), pLast[2]]
	e := bezier_RandCP(pLast, 15, 3, p, 10, 3)
	for i, v in bezier(pLast[1], pLast[2], p[1], p[2], e[1], e[2], 30)
		ls.InsertAt(ls.MaxIndex(), [v[1], v[2]])


	p2 := [pLast[1] - rand(30, 15), pLast[2]]
	e := bezier_RandCP(p, 15, 3, p2, 10, 3)
	for i, v in bezier(p[1], p[2], p2[1], p2[2], e[1], e[2], 30)
		ls.InsertAt(ls.MaxIndex(), [v[1], v[2]])

	e := bezier_RandCP(p2, 5, 2, pLast, 6, 2)
	for i, v in bezier(p2[1], p2[2], pLast[1], pLast[2], e[1], e[2], 30)
		ls.InsertAt(ls.MaxIndex(), [v[1], v[2]])
}

RandDel(ls, tms) {
	Loop, % tms
		ls.removeat(rand(2, ls.MaxIndex() - 60), rand(1, 5))
}

RandAll(ls, randTmin := 2, randTmax := 5, randNum := 2) {
	j := 0
	nextRand := rand(randTmin, randTmax)
	for i, v in ls {
		j += 1
		if (j >= nextRand) {
			j := 0
			nextRand := rand(randTmin, randTmax)
			ls[i][1] := v[1] + rand(-randNum, randNum)
			ls[i][2] := v[2] + rand(-randNum, randNum)
		}
	}
}

RadomPos(i, c, range) {
	c := Mod(A_Sec, 2) ? (c) : (-c)
	i += c + rand(-range, range)
	return i
}

rand(min, max) {
	static ex
	local out := false
	loop {
		Random, rt, % min, % max
		if (rt <> ex) {
			out := true
			ex := rt
		}
	} until (out)
	return rt
}

bezier(sx, sy, ex, ey, cx, cy, pCounts) {
	/*	返回贝塞尔曲线
		sx	起点x
		sy	起点y
		ex	终点x
		ey	终点y
		cx	控制点x
		cy	控制点y
		pCounts	生成路径点数量: 最终
	*/
	;pLs := [[sx, sy]]
	pLs := [[sx, sy]]

	loop, %pCounts% {
		qx1 := sx + ((cx - sx) / pCounts) * A_Index, qy1 := sy + ((cy - sy) / pCounts) * A_Index
		pLs.Push([format("{:d}", qx1 + ((cx + ((ex - cx) / pCounts) * A_Index) - qx1) * A_Index / pCounts), format("{:d}", qy1 + ((cy + ((ey - cy) / pCounts) * A_Index) - qy1) * A_Index / pCounts)])
	}
	return pLs
}

bezier_RandCP(sPos, iDistance1, Range1, ePos, iDistance2, Range2) {
	ls := [RadomPos(format("{:d}", ((sPos[1] + ePos[1]) / 2)), iDistance1, Range1)
		,  RadomPos(format("{:d}", ((sPos[2] + ePos[2]) / 2)), iDistance2, Range2)]
	return ls
}