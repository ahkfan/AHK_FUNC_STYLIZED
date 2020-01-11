
time_s(mSec, byref t, byref t0 := 0)
{
	/*
	简介: 用于循环体中的休眠, 参2 参3 变量 可用于循环体中

	参1:	mSec  	type(uInt)
		: 要休眠的毫秒数

	参2: 	t 		type(var byref)
		: 传址引用, 记录到期时间, 在函数域中设为 static 变量, 初始传入必须<=0

	参3: 	t0		type(var byref) 可省
		: 传址引用, 记录剩余毫秒数


	返回值: 执行到期返回false, tm值设还为0, 未到期返回true

	示例:

		;~ ex 1.

		t := 0
		while (time_s(5000, t, t0))
		{
			;ToolTip, % "剩余: " t0 " 毫秒"
			;ToolTip, % "剩余: " format("{:.3f}", t0 / 1000) " 秒"
			ToolTip, % "剩余: " t0 // 1000 + 1 " 秒"
		}
		MsgBox, % t

	*/

	if (not t > 0)
	{
		t := A_TickCount + mSec
	}

	if ((t0 := t - A_TickCount) <= 0)
	{
		return false, t := 0
	}
	else
	{
		return true
	}
}

time_suning()
{
	/*
	简介: 获取苏宁网络时间

	参数: 无

	返回值: A_Now 格式的时间戳

	示例:

		MsgBox, % time_suning()

	*/

	local whr, gTime
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "http://quan.suning.com/getSysTime.do", true)
	whr.Send()
	whr.WaitForResponse()
	gTime := whr.ResponseText
	RegExMatch(gTime, "sysTime1.{3}(\d+)", rtTime)
	return rtTime1
}