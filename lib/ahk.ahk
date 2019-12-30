;~脚本进程

ahk_get_all()
{
	;process信息 详细结构参考: https://docs.microsoft.com/zh-cn/windows/desktop/CIMWin32Prov/win32-process
	lsAllProcess := []
	for process in ComObjGet("winmgmts:").ExecQuery("Select Autohotkey.exe from Win32_Process")
		lsAllProcess.push({   "Name":		process.Name
							, "PID":		process.ProcessId
							, "ParentPID":	process.ParentProcessId
							, "Path":		process.ExecutablePath
							, "CMD": 		process.CommandLine		})
	return lsAllProcess
}

ahk_post_msg()
{

}