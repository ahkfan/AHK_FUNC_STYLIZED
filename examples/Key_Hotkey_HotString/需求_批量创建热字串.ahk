#SingleInstance force
/*
脚本需求:
    连按 xxx(数字) + w 键
    在末尾输出 xxx + "`n" 符号
    要求数字 区间 0-100
    以 热字串 形式 创建 101个热字串
    A_Thishotkey 获取右侧 :: 前的热字串定义符号
*/

loop, 101
    Hotstring(":X*:" . (A_Index - 1) . "w" , "execute", "on")
return

execute:
    /*
    Loop
    {
        CoordMode, Pixel, Window
        ImageSearch, FoundX, FoundY, 0, 0, 1600, 900, D:\我的文件\3ds max\单位.png
        CenterImgSrchCoords("D:\我的文件\3ds max\单位.png", FoundX, FoundY)
        If ErrorLevel = 0
            Click, %FoundX%, %FoundY%, 0
    }
    Until ErrorLevel = 0
    Click, Rel 50, 0 Left, 1
    Sleep, 10
    Send, {Down 3}{Enter}
    Loop
    {
        CoordMode, Pixel, Window
        ImageSearch, FoundX, FoundY, 0, 0, 1600, 900, D:\我的文件\3ds max\倍增.png
        CenterImgSrchCoords("D:\我的文件\3ds max\倍增.png", FoundX, FoundY)
        If ErrorLevel = 0
            Click, %FoundX%, %FoundY%, 0
    }
    Until ErrorLevel = 0
    Click, Rel 50, 0 Left, 2
    Sleep, 10
    */

    Send % substr(A_Thishotkey, 5, -1) . "`n"
return

