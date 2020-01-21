#SingleInstance force
/* 说明:
	当进程存在时, 运行路径下的 脚本
	当进程不存在时, 关闭所有该路径下的 同名脚本
*/
	ls := []
	;~ 参1为进程名称, 参2要判断的脚本完整路径
	ls.push(new RnC("UE4Editor.exe", "D:\我的文件\ue4.ahk"))
	Loop {
		for i, obj in ls
			obj.check()
		Sleep, 200		;~ 若判断过快可能导致启动多个脚本
	}
return


class RnC {
	__New(name, AhkFile) {
		this.process := name
		this.path := AhkFile
	}

	check() {
		pidLs := this.__GetLsPid()
		Process, Exist, % this.process
		if (Errorlevel) {	;~ 进程存在时, 打开ahk
			if not pidLs.MaxIndex()
				Run, % this.path
		} else {
			for i, iPid in pidLs
				p_close(iPid)
		}
	}

	__GetLsPid() {
		rtLs := []
		for i, obj in p_DictAHK()
			if (obj["path"] = this.path)
				rtLs.push(obj["pid"])
		return rtLs
	}
}

p_close(pidorName) {
	Loop {
		Process, close, % pidorName
		process, Exist , % pidorName
	} until not Errorlevel
}

p_DictAHK() {									;~ 获取所有所有执行中的ahk进程信息, 单位为字典的列表
	;获取所有ahk进程信息, 默认执行最后关闭隐藏窗口搜索
	lsAHK := []	;"name" : ,"path:" , "pid" : , "hwnd" :
	sExDetect := A_DetectHiddenWindows
	DetectHiddenWindows, on
	WinGet, id, list, ahk_class AutoHotkey
	loop, % id
	{
		WinGetTitle, sTitle, % "ahk_id " id%A_Index%
		if (RegExMatch(sTitle, "(.+) - AutoHotkey v[\d\.]+$", sFilePath)) {
			WinGet, iPID, pid,	% "ahk_id " id%A_Index%
			SplitPath, sFilePath1, sName
			lsAHK.push(object("hwnd", id%A_Index%,"path", sFilePath1, "pid", iPID,"name", sName))
		}
	}
	DetectHiddenWindows, % sExDetect
	return lsAHK
}