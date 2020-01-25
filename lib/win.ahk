;~窗口
win := win()
msgbox, % win.hwndFormat("ahk_id 0x123")


win()
{
    return __Class_Window
}


class __Class_Window
{

    class msg
    {

    }

    class op
    {

    }
    ;--------------------------------------------
    hwndFormat(hwnd)
    {
        /*
        简介:   将传入的窗口句柄格式化
        参1:    hwnd {String / UInt}
        返回值: {String} "ahk_id 0xffffffff" 此类形式的字符串0
        */
        if (SubStr(hwnd, 1, 9) = "ahk_id 0x")
            return (format("{1:d}", SubStr(hwnd, 8)) > 0) ? (hwnd) : ("")
        else if ((ret := format("0x{1:x}", hwnd)) <> "0x")
            return "ahk_id " ret
        else
            return ""
        
    }

    ;--------------------------------------------
    getAttrs(hwnd, KeyLs := "")
    {
        /*
        简介:   获取窗口大部分可用属性

        参1:    hwnd   {UInt}    窗口句柄
        参2:    KeyLs  {Array}   可空, 可只选择部分需要返回的属性

        返回值: {Object / String} 窗口属性 / 字符串错误提示
                1. "error form [" hwnd "]"  窗口格式错误
                2. "WinNotExist"            窗口不存在
                3. {Object}                 窗口的某些属性
        */
        
        if ((_hwnd := this.hwndFormat(hwnd)) = "")
        {
            return "error form [" hwnd "]"
        }
        if not WinExist(_hwnd)
        {
            return "WinNotExist"
        }
        ret := {}
        if (KeyLs = "")     ;~ 获取所有属性
        {
            WinGetPos, x, y, w, h, % _hwnd
            WinGetTitle, tilte		, % _hwnd
            WinGetClass, className	, % _hwnd
            WinGet, ProcessName	    , ProcessName	, % _hwnd
            WinGet, transparent	    , Transparent	, % _hwnd
            WinGet, transcolor	    , transcolor	, % _hwnd
            WinGet, ProcessPath	    , ProcessPath	, % _hwnd
            WinGet, pid			    , PID			, % _hwnd
            WinGet, style		    , Style			, % _hwnd
            WinGet, exstyle		    , ExStyle		, % _hwnd
           
            ret.title           := tilte
            ret.class           := className
            ret.exe             := ProcessName
            ret.transparent     := transparent
            ret.path            := ProcessPath
            ret.pid             := pid
            ret.style           := style
            ret.exstyle         := exstyle
            ret.x               := x
            ret.y               := y
            ret.w               := w
            ret.h               := h

        }
        else
        {

        }
        return ret
    }

    findHwnd(filter := "")
    {
        /*
        简介: 查找符合条件的窗口, 返回单个窗口句柄

        原型: winget, v, list

        参1: filter {Object} , 可选以下键值对

            title   : {String}  "标题"
            class   : {String}  "类名"
            exe     : {String}  "进程名称.exe"
            pid     : {UInt}    进程pid
            path    : {String}  "进程完整路径"
            style   : {UInt}
            exstyle : {UInt}
            wW      : {UInt}    窗口宽度
            wH      : {UInt}    窗口高度
            cW      : {UInt}    窗口客户区宽度
            cH      : {UInt}    窗口客户区高度
            
        返回值: Hwnd 窗口句柄
        */
    }
}