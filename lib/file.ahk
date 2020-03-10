; LIB OF FILE

fsfile()
{
    return __CLASS_AHKFS_FILE
}

class __CLASS_AHKFS_FILE
{
    Append(Text, Filename:="", Options:="")
    {
        local EOL, Encoding
        Encoding := A_FileEncoding
        EOL := "*"
        Loop Parse, Options, % " `t"
        {
            if (A_LoopField = "`n")
                EOL := ""
            else if (A_LoopField ~= "i)^(UTF-|CP)")
                Encoding := A_LoopField
        }
        FileAppend %Text%, %EOL%%Filename%, %Encoding%
        return !ErrorLevel
    }
    Copy(Source, Dest, Flag:=0)
    {
        FileCopy %Source%, %Dest%, %Flag%
        return !ErrorLevel
    }
    CreateShortcut(Target, LinkFile, WorkingDir:="", Args:="", Description:="", IconFile:="", ShortcutKey:="", IconNumber:="", RunState:=1)
    {
        FileCreateShortcut %Target%, %LinkFile%, %WorkingDir%, %Args%, %Description%, %IconFile%, %ShortcutKey%, %IconNumber%, %RunState%
        return !ErrorLevel
    }
    Delete(FilePattern)
    {
        FileDelete %FilePattern%
        return !ErrorLevel
    }
    Encoding(Encoding:="")
    {
        FileEncoding %Encoding%
    }
    GetAttrib(Filename:="")
    {
        local OutputVar
        FileGetAttrib OutputVar, %Filename%
        if !ErrorLevel
            return OutputVar
    }
    GetShortcut(LinkFile, ByRef OutTarget:="", ByRef OutDir:="", ByRef OutArgs:="", ByRef OutDescription:="", ByRef OutIcon:="", ByRef OutIconNum:="", ByRef OutRunState:="")
    {
        FileGetShortcut %LinkFile%, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
        return !ErrorLevel
    }
    GetSize(Filename:="", Units:="")
    {
        local OutputVar
        FileGetSize OutputVar, %Filename%, %Units%
        if !ErrorLevel
            return OutputVar
    }
    GetTime(Filename:="", WhichTime:="M")
    {
        local OutputVar
        FileGetTime OutputVar, %Filename%, %WhichTime%
        if !ErrorLevel
            return OutputVar
    }
    GetVersion(Filename:="")
    {
        local OutputVar
        FileGetVersion OutputVar, %Filename%
        if !ErrorLevel
            return OutputVar
    }
    Install(Source, Dest, Flag:=0)
    {
        FileCopy %Source%, %Dest%, %Flag%
        return !ErrorLevel
    }
    Move(SourcePattern, DestPattern, Flag:=0)
    {
        FileMove %SourcePattern%, %DestPattern%, %Flag%
        return !ErrorLevel
    }
    Read(Filename, Options:="")
    {
        local OutputVar, Options2
        Loop Parse, Options, % " `t"
        {
            if (SubStr(A_LoopField, 1, 1) = "m")
                Options2 .= "*" A_LoopField " "
            else if (A_LoopField = "`n")
                Options2 .= "*t "
            else if (SubStr(A_LoopField, 1, 2) = "CP")
                Options2 .= "*" SubStr(A_LoopField, 2) " "
            else if (SubStr(A_LoopField, 1, 5) = "UTF-8")
                Options2 .= "*P65001 "
            else if (SubStr(A_LoopField, 1, 6) = "UTF-16")
                Options2 .= "*P1200 "
        }
        FileRead OutputVar, %Options2%%Filename%
        if !ErrorLevel
            return OutputVar
    }
    Recycle(FilePattern)
    {
        FileRecycle %FilePattern%
        return !ErrorLevel
    }
    RecycleEmpty(DriveLetter:="")
    {
        FileRecycleEmpty %DriveLetter%
        return !ErrorLevel
    }
    Select(Options:=0, RootDir_Filename:="", Prompt:="", Filter:="")
    {
        local OutputVar
        FileSelectFile OutputVar, %Options%, %RootDir_Filename%, %Prompt%, %Filter%
        if !ErrorLevel
            return OutputVar
    }
    SetAttrib(Attributes, FilePattern:="", Mode:="")
    {
        if !RegExMatch(Attributes, "^[+\-\^]")
        {
            FileSetAttrib -RASHOT, %FilePattern%, % InStr(Mode, "D") ? (InStr(Mode, "F") ? 1 : 2) : 0, % !!InStr(Mode, "R")
            Attributes := "+" Attributes
        }
        FileSetAttrib %Attributes%, %FilePattern%, % InStr(Mode, "D") ? (InStr(Mode, "F") ? 1 : 2) : 0, % !!InStr(Mode, "R")
        return !ErrorLevel
    }
    SetTime(YYYYMMDDHH24MISS:="", FilePattern:="", WhichTime:="M", Mode:="")
    {
        FileSetTime %YYYYMMDDHH24MISS%, %FilePattern%, %WhichTime%, % InStr(Mode, "D") ? (InStr(Mode, "F") ? 1 : 2) : 0, % !!InStr(Mode, "R")
        return !ErrorLevel
    }
}
