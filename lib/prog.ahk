; LIB OF PROGRAM ENV 


prog()
{
    return __CLASS_AHKFS_PROGRAM
}

class __CLASS_AHKFS_PROGRAM
{
    ;------------------------- CMD environment variable -------------------------
    EnvGet(EnvVarName)
    {
        EnvGet, OutputVar, % EnvVarName
        Return OutputVar
    }

    EnvSet(EnvVar, Value)
    {
        EnvSet, % EnvVar, % Value
        if ErrorLevel == 1
            Throw, Exception("Set environment failed")
        return this
    }
    
    EnvUpdate()
    {
        EnvUpdate
        return this
    }

    SetWorkingDir(DirPath)
    {
        if DirPath == ""
            Throw Exception("DirPath should not be empty", -1)
        else if not Instr(FileExist(DirPath), "D")
            Throw Exception("DirPath does not exist:`n[" DirPath "]", -1)
        SetWorkingDir, % DirPath
        return this
    }

    ;------------------------- run program -------------------------
    Run(Target , WorkingDir := "", Options := "")
    {
        WorkingDir := WorkingDir == "" ? A_ScriptDir : WorkingDir
        if Options
            Run, % Target , % WorkingDir, % Options, OutputVarPID
        else
            Run, % Target , % WorkingDir, , OutputVarPID

        return OutputVarPID
    }

    RunWait(Target , WorkingDir := "", Options := "")
    {
        WorkingDir := WorkingDir == "" ? A_ScriptDir : WorkingDir
        if Options
            RunWait, % Target , % WorkingDir, % Options, OutputVarPID
        else
            RunWait, % Target , % WorkingDir, , OutputVarPID
        return OutputVarPID
    }

    ;------------------------- run as administrator -------------------------
    RunAs(User, Password, Domain)
    {
        if User == "" And Password == "" And Domain == ""
            RunAs
        else
            RunAs, % User, % Password, % Domain
        return this
    }

    ;------------------------- get process info -------------------------
    GetAll()
    {
        lsAllProcess := []
        for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
            lsAllProcess.push({   "name":		process.Name
                                , "PID":		process.ProcessId
                                , "parentPID":	process.ParentProcessId
                                , "path":		process.ExecutablePath
                                , "CMD": 		process.CommandLine		})
        return lsAllProcess
    }
    GetSelfPID()
    {
        process, exist
        return ErrorLevel
    }

    Exist(NameOrPID)
    {
        if (NameOrPID == "")
            Throw Exception("NameOrPID should not be empty", -1)

        Process, exist, % NameOrPID
        return ErrorLevel
    }

    ;------------------------- Priority -------------------------
    SetPriority(NameOrPID, Level)
    {
        ;~ 优先级由低到高
        static allowDict := { "L" : ""
                            , "B" : ""
                            , "N" : ""
                            , "A" : ""
                            , "H" : ""
                            , "R" : ""}
        if not allowDict.HasKey(Level)
            Throw Exception("func prog.SetPriority() warning! param [Level] can not be : " Level, -1)
        if (NameOrPID == "")
            Throw Exception("func prog.SetPriority() warning! NameOrPID should not be empty", -1)
        Process, Priority, % PIDOrName, % Level
        return ErrorLevel
    }

    ;------------------------- Close -------------------------
    Close(NameOrPID)
    {
        Process, Close , % PIDOrName
        return ErrorLevel
    }

    CloseAllByName(Name, OverTimeMsec := 0)
    {
        if (OverTime)
            OverTime := A_TickCount + OverTime

        while(this.exist(Name))
        {
            this.close(Name)
            if (OverTime)
                if (A_TickCount >= OverTime)
                    return false
        }
        return true
    }

    ;------------------------- wait -------------------------
    WaitExist(Name, OverTimeSec := 0)
    {
        Process, Wait , % Name, % OverTimeSec ? OverTimeSec : ("")
        return ErrorLevel   ;~ 返回新进程 pid 或 超时为0
    }

    WaitClose(NameOrPID, OverTimeSec := 0)
    {
        Process, WaitClose, %  NameOrPID, % OverTimeSec ? OverTimeSec : ("")
        return ErrorLevel   ;~ 返回原进程 pid 或 超时为0
    }




}


