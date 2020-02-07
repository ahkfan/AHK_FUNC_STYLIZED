Caputre(A_Desktop "\1.bmp", 0, 0, A_ScreenWidth, A_ScreenHeight)


Caputre(OutputFile, x, y, w, h)
{
    /*
        说明: 截图并保存到bmp文件中

        参数:
            [1] OutputFile  {String}    输出的文件路径, 如 "E:\123.bmp"
            [2] x           {Int}       截取左侧坐标
            [3] y           {Int}       截取上侧坐标
            [4] w           {Int}       截取宽度
            [5] h           {Int}       截取高度

        返回值: 
            -1  打开dll文件失败
            0   成功
            1   创建内存DC失败
            2   创建兼容位图句柄失败
            3   拷贝位图DC数据失败
            4   创建hDIB失败
            5   创建文件失败
    */
    static hModule := ""
    local dir

    if not hModule
    {
        SplitPath, A_LineFile, , dir
        hModule := DllCall("LoadLibrary", "Str", dir "\Capture.dll", "Ptr")
        if not hModule
            return 6
    }

    return DllCall("Capture.dll\Capture","AStr", OutputFile
                , "Int", x
                , "Int", y
                , "Int", w
                , "Int", h
                , "Int")
}
