﻿; LIB OF PROGRAM ENV 

prog()
{
    return __CLASS_AHKFS_PROGRAM
}

class __CLASS_AHKFS_PROGRAM
{

    EnvGet(EnvVarName)
    {
        EnvGet, OutputVar, % EnvVarName
        Return OutputVar
    }
    ;--------------------------------------
    EnvSet(EnvVar, Value)
    {
        EnvSet, % EnvVar, % Value
        if ErrorLevel == 1
            Throw, Exception("Set environment failed")
    }
    
    ;--------------------------------------
    EnvUpdate()
    {
        EnvUpdate
    }
    
    ;--------------------------------------
    Run(Target , WorkingDir := "", Options := "")
    {
        if Options
            Run, % Target , % WorkingDir, % Options, OutputVarPID
        else
            Run, % Target , % WorkingDir, , OutputVarPID

        return OutputVarPID
    }

    ;--------------------------------------
    RunWait(Target , WorkingDir := "", Options := "")
    {
        if Options
            RunWait, % Target , % WorkingDir, % Options, OutputVarPID
        else
            RunWait, % Target , % WorkingDir, , OutputVarPID

        return OutputVarPID
    }

    ;--------------------------------------
    RunAs(User, Password, Domain)
    {
        if User == "" And Password == "" And Domain == ""
            RunAs
        else
            RunAs, % User, % Password, % Domain
    }

    ;--------------------------------------
    SetWorkingDir(DirPath)
    {
        if DirPath == ""
            Throw Exception("DirPath should not be empty", -1)
        else if not Instr(FileExist(DirPath), "D")
            Throw Exception("DirPath does not exist:`n[" DirPath "]", -1)
        SetWorkingDir, % DirPath
    }
}

