/* ;~脚本进程
ahk().method()

ahk().GetAllProcess()
ahk().MsgControl(title, command)


*/
#include __warning.ahk

ahk := ahk()

ahk.abc := 123

ahk()
{
	__Class_AHK.base := AHKFS_WARNING()
	return __Class_AHK
}

class __ClASS_AHK
{
	static file := "ahk.ahk"
	;-----------------------------------
	GetAllProcess()
	{
		;process信息 详细结构参考: https://docs.microsoft.com/zh-cn/windows/desktop/CIMWin32Prov/win32-process
		lsAllProcess := []
		for process in ComObjGet("winmgmts:").ExecQuery("Select Autohotkey from Win32_Process")
			lsAllProcess.push({   "Name":		process.Name
								, "PID":		process.ProcessId
								, "ParentPID":	process.ParentProcessId
								, "Path":		process.ExecutablePath
								, "CMD": 		process.CommandLine		})
		return lsAllProcess
	}

	;-----------------------------------
	MsgControl(title, command)
	{
		static WM_COMMAND := 0x111
		static cmdDict := {"pause" 			: 65403
						,  "suspend" 		: 65404
						,  "edit" 			: 65401
						,  "reload"			: 65400
						,  "exit"			: 65405
						,  "viewhistory"	: 65406
						,  "viewvariables"	: 65407
						,  "viewhotkeys"	: 65408}

		if not cmdDict.HasKey(command)
		{
			Throw Exception(this.file " warning!:`ncommand: " command " dose not exist!`n")
		}
		PostMessage, % WM_COMMAND, % cmdDict[command], , , % title
	}

	msg()
	{
		MsgBox, 123
	}
}
