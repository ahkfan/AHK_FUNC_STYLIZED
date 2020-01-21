MsgBox, % "当前网络时间:" getTime()
iTime := 20190627210800
try {
	iTime -= getTime(), s
} catch {
	MsgBox, 网络无法连接
	ExitApp
	return
}

MsgBox, 剩余可用时间%iTime%秒
return

getTime() {
	local whr, gTime
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "http://quan.suning.com/getSysTime.do", true)
	whr.Send()
	whr.WaitForResponse()
	gTime := whr.ResponseText
	RegExMatch(gTime, "sysTime1.{3}(\d+)", rtTime)
	return rtTime1
}