/*
将当前文件夹下的lib拷贝到A_AHKPath

#SingleInstance, force
SplitPath, A_AHKPath, , AHKDir
pathLib := AHKDir "\lib"
pathInclude := AHKDir "\lib\include"
CreateDir(pathInclude)
existLs := CopyAllFile(A_ScriptDir "\lib\*.ahk", pathLib)
existLs.push(CopyAllFile(A_ScriptDir "\lib\include\*.ahk", pathInclude)*)
MsgBox, % existLs.length()
return

CopyAllFile(src, des)
{
    existLs := []
    loop, files, % src, F
    {
        desPath := des "\" A_LoopFileName
        if FileExist(desPath)
            existLs.push(desPath)
        else
            FileCopy, % A_LoopFileLongPath, % desPath, 0
    }
    return existLs
}

CreateDir(path)
{
    while not InStr(FileExist(path), "D")
    {
        FileCreateDir, % path
        sleep, 1
    }
}
*/