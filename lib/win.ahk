/*
win := win()
*/


win()
{
    return __ClASS_AHKFS_WINDOW
}

class __ClASS_AHKFS_WINDOW
{
    ;--------------------------------------------
    class msg
    {
        
    }
    ;--------------------------------------------
    class op
    {

    }
    ;--------------------------------------------
    HwndFormat(hwnd)        ;~ win.HwndFormat()
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
    GetAttrs(hwnd)          ;~ win.GetAttrs()
    {                       ;~ todo: 相对客户区的坐标和尺寸

        /*
        简介:   获取窗口大部分可用属性

        参1:    hwnd   {UInt}    窗口句柄

        返回值: {Object / String} 窗口属性 / 错误
                1. 0                        窗口格式错误
                2. ""                       窗口不存在
                3. {Object}                 窗口的某些属性
                    {
                        "isActive"      : {Boolean}
                        "isMax"         : {Boolean}
                        "isMin"         : {Boolean}
                        "isFloat"       : {Boolean}
                        "title"         : {String}
                        "class"         : {String}
                        "text"          : {String}
                        "process"       : {String}
                        "path"          : {String}
                        "pid"           : {UInt / ""}
                        "transparent"   : {UInt / ""}
                        "transcolor"    : {Uint}
                        "style"         : {UInt}
                        "exstyle"       : {UInt}
                        "childs"        : {Array} 例: [{"class": "CLSName", "hwnd": 0x123}, {"class": "CLSName2", "hwnd": 0x567}]
                        "w"             : {UInt}
                        "h"             : {UInt}
                        "x"             : {Int}
                        "y"             : {Int}
                    }
        */
        
        if ((_hwnd := this.hwndFormat(hwnd)) = "")
        {
            return 0
        }
        if not WinExist(_hwnd)
        {
            return ""
        }
        ret := {}
        WinGetPos, x, y, w, h, % _hwnd
        WinGetTitle, tilte		, % _hwnd
        WinGetClass, className	, % _hwnd
        WinGetText , text       , % _hwnd
        WinGet, ProcessName	    , ProcessName	, % _hwnd
        WinGet, transparent	    , Transparent	, % _hwnd
        WinGet, transcolor	    , transcolor	, % _hwnd
        WinGet, ProcessPath	    , ProcessPath	, % _hwnd
        WinGet, pid			    , PID			, % _hwnd
        WinGet, style		    , Style			, % _hwnd
        WinGet, exstyle		    , ExStyle		, % _hwnd
        WinGet, controlList		, ControlList   , % _hwnd
        WinGet, ControlListHwnd	, ControlListHwnd  , % _hwnd
        WinGet, MinMax          , MinMax        , % _hwnd

        ret.isActive        := WinActive(_hwnd) ? true : false
        ret.isMax           := (MinMax = 1)     ? true : false
        ret.isMin           := (MinMax = -1)    ? true : false
        ret.isFloat         := (MinMax = 0)     ? true : false
        ret.title           := tilte
        ret.class           := className
        ret.text            := text
        ret.process         := ProcessName
        ret.path            := ProcessPath
        ret.pid             := pid
        ret.transparent     := transparent
        ret.transcolor      := transcolor
        ret.style           := style
        ret.exstyle         := exstyle
        ret.x               := x
        ret.y               := y
        ret.w               := w
        ret.h               := h
        ret.childs          := []   ;~ 返回单位元素为 {"class": "", "hwnd": ""} 的列表
        loop, parse, ControlList, `n
        {
            ControlGet, hwndOp, hwnd, , % A_LoopField, % _hwnd
            ret.childs.push({"class": A_LoopField, "hwnd": hwndOp})
        }
        return ret
    }
    ;--------------------------------------------
    FindHwndBy(filter)      ;~ win.FindHwnd()
    {

    }
}