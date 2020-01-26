
/*
m_move(int: x, int: y)
m_move_compare(int: x, int: y)
m_move_bezier()
m_down(str: witch:= "L")
m_up(str: witch:= "L")
m_click()
m_drag()
m_get_pos()
m_get_win_hwnd()
m_get_winop_classNN()
m_get_winop_hwnd()
m_get_pixel()
m_pmsg_nc_move(str: witch:="L", int: hwnd)
m_pmsg_nc_down(str: witch:="L", int: hwnd)
m_pmsg_nc_up(str: witch:="L", int: hwnd)
m_pmsg_nc_click(str: witch:="L", int: hwnd)
*/

m_move(-1, -1)



m_move(x, y, slep := 0)
{
	/*
	简介: 移动鼠标
	参1: 省
	参2: 省
	参3: type(int) 可舍, 移动之后休眠时间, 默认0

	示例:
		loop, 30
			p := a_index * 10	, m_move(p, p, 10)
		loop, 30
			p -= (A_Index = 1) ? 0 : 10 , m_move(p, p, 10)
	*/
	MouseMove, % x, % y, 0
	Sleep, % slep
}

m_move_relative(x, y, slep := 0)
{
	/*
	简介: 相对当前鼠标位置移动
	参1: 省
	参2: 省
	参3: type(int) 可舍, 移动之后休眠时间, 默认0
	*/
	MouseMove, x, y, 0, R
	Sleep, % slep

}

m_move2(x, y, mode := "s", speed := 0, compare := "")
{	;~ todo
	/*
	简介:

	参1: 省

	参2: 省

	参3: type(char) 可舍, 默认全屏
		"s" 相对全屏
		"w" 相对激活窗口的整体窗口
		"c" 相对激活窗口的客户区

	参4: type(int) 可舍, 默认最快
		速度, 数值越低越快

	参5: type(char) 可舍, 默认

	*/
}


