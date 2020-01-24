; LIB OF PROGRAM ENV 

prog_EnvGet(EnvVarName)
{
    EnvGet, OutputVar, % EnvVarName
    Return OutputVar
}

prog_EnvSet(EnvVar, Value)
{
    EnvSet, % EnvVar, % Value
    if ErrorLevel == 1
        Throw, Exception("Set environment failed")
}

prog_EnvUpdate()
{
    EnvUpdate
}

prog_Run(Target , WorkingDir := A_WorkingDir, Options := "", OutputVarPID)
{
    if Options
        Run, Target , WorkingDir, Options, OutputVarPID
    else
        Run, Target , WorkingDir, , OutputVarPID
}

prog_RunWait(Target , WorkingDir := A_WorkingDir, Options := "", OutputVarPID)
{
    if Options
        RunWait, Target , WorkingDir, Options, OutputVarPID
    else
        RunWait, Target , WorkingDir, , OutputVarPID
}

prog_RunAs(User, Password, Domain)
{
    if User == "" And Password == "" And Domain == ""
        RunAs
    else
        RunAs, User, Password, Domain
}

prog_SetWorkingDir(DirName := A_WorkingDir)
{
    if DirName == ""
        Throw Exception("DirName should not be empty", -1)
    SetWorkingDir, DirName
}