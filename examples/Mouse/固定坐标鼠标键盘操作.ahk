/* 距离区间内固定坐标的鼠标移动

#SingleInstance force
a := new KBD_MsList(ms_RangeL([20, 39], [351, 39], 7)*)
return

right::a.right()
left::a.left()
up::a.up()
down::a.down()

*/



class KBD_MsList 
{

	__new(lsPos*) 
	{			;~ 取一个二维数组
		this.pos := lsPos
		this.focus := 0
	}
	right() 
	{
		i := this.focus + 1
		this.focus := (i >= this.pos.MaxIndex()) ? 1 : i
		this.__move()
	}
	left() 
	{
		i := this.focus - 1
		this.focus := (i <= 0) ? this.pos.MaxIndex() : i
		this.__move()
	}

	up() 
	{
		this.focus := 1
		this.__move()
	}
	down() 
	{
		this.focus := this.pos.MaxIndex()
		this.__move()
	}

	__move() 
	{
		MouseMove, % (this.pos)[this.focus][1], % (this.pos)[this.focus][2], 0
	}
}

ms_RangeL(pLs1, pLs2, rgNum) {			;~ 根据两个坐标取直线内所有坐标
	rtLs := []
	disTx := (pLs2[1] - pLs1[1]) / (rgNum - 1)
	disTy := (pLs2[2] - pLs1[2]) / (rgNum - 1)
	loop, % rgNum
		rtLs.push([pLs1[1] + RegExReplace((A_Index - 1) * disTx, "\..+"),pLs1[2] + RegExReplace((A_Index - 1) * disTy, "\..+")])
	return rtLs
}