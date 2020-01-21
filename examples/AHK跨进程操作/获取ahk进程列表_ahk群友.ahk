DetectHiddenWindows, on
/*
 * 窗口消息功能

WM_COMMAND := 0x111
ID_EditScript := 65401
ID_ReloadScript := 65400
ID_PauseScript := 65403
ID_SuspendScript := 65404
ID_ExitScript := 65405
ID_ViewHistory := 65406
ID_ViewVariables := 65407
ID_ViewHotkeys := 65408

for i,v in getahk()
{
	if (v.hwnd != A_ScriptHwnd)
		PostMessage , %WM_COMMAND%, %ID_ExitScript%,,, % "ahk_id " v["hwnd"]
}
return
 */

getahk() {
	;获取所有ahk进程信息, 默认执行最后关闭隐藏窗口搜索
	list_ahk := []	;{ "name" : ,"path:" , "pid" : , "hwnd" :}
	exd := A_DetectHiddenWindows
	DetectHiddenWindows, on
	WinGet, id, list, ahk_class AutoHotkey
	loop, % id
	{
		WinGetTitle, this_title, % "ahk_id " id%A_Index%
		if (RegExMatch(this_title, "(.+) - AutoHotkey v[\d\.]+$", this_filelongpath)) {
			WinGet, this_pid, pid,	% "ahk_id " id%A_Index%
			SplitPath, this_filelongpath1, this_name
			list_ahk.push(object("hwnd", id%A_Index%,"path", this_filelongpath1, "pid", this_pid,"name", this_name))
		}
	}
	DetectHiddenWindows, % exd
	return list_ahk
}