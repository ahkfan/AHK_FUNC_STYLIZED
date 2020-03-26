/* ;~脚本进程
ahk().method()

ahk().GetAllProcess()
ahk().MsgControl(title, command)


*/


fsahk()
{
    return __Class_AHK, __ClASS_AHK.base := AHKFS_WARNING()
}

class __ClASS_AHK
{
    static file := "ahk.ahk"
    ;-----------------------------------
    GetAllAHKProcess()
    {
        /*
            简介: 获取当前所有活动的ahk进程信息

            参数: 无

            返回值: type(Array [AHKProcessObj1, AHKProcessObj2...])

                AHKProcessObj := { name: String
                                ,  path: String
                                ,  Pid:  Int
                                ,  hwnd: Int}

            ;~ 另外可参考
            lsAllProcess := []
            for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process WHERE Name LIKE 'Autohotkey%'")
            {
                lsAllProcess.push({   "Name":		process.Name
                                , "PID":		process.ProcessId
                                , "ParentPID":	process.ParentProcessId
                                , "Path":		process.ExecutablePath
                                , "CMD": 		process.CommandLine		})
                }
            }
        */
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

    ;-----------------------------------
    MsgControl(title, command)
    {
        static WM_COMMAND := 0x111
        static cmdDict := {"pause"           : 65403
                        ,  "suspend"         : 65404
                        ,  "edit"            : 65401
                        ,  "reload"          : 65400
                        ,  "exit"            : 65405
                        ,  "viewhistory"     : 65406
                        ,  "viewvariables"   : 65407
                        ,  "viewhotkeys"     : 65408}

        if not cmdDict.HasKey(command)
        {
            Throw Exception(this.file " warning!:`ncommand: " command " dose not exist!`n")
        }
        PostMessage, % WM_COMMAND, % cmdDict[command], , , % title
    }

}
