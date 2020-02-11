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
    HwndFormat(hwnd)        ;~ win.HwndFormat()
    {
        /*
        简介:   将传入的窗口句柄格式化

        参数: 
            [1] hwnd {String / UInt}

        返回值: {String} 
            格式不合法返回 ""
            格式无误则返回 "ahk_id 0xffffffff" 此类形式的字符串
            

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

        参数:
            [1] hwnd   {UInt}    窗口句柄

        返回值: {Object / String} 窗口属性 / 错误
                1. 0                        窗口格式错误
                2. ""                       窗口不存在
                3. {Object}                 窗口的某些属性
                    {
                        "Error"         : {String}  为空时成功取得窗口, 否则显示错误信息
                        "isActive"      : {Boolean}
                        "isMax"         : {Boolean}
                        "isMin"         : {Boolean}
                        "isFloat"       : {Boolean}
                        "title"         : {String}
                        "class"         : {String}
                        "text"          : {String}
                        "process"       : {String}
                        "path"          : {String}
                        "pid"           : {UInt}
                        "transparent"   : {UInt / ""}
                        "transcolor"    : {Uint / ""}
                        "style"         : {UInt}
                        "exstyle"       : {UInt}
                        "childs"        : {Array} 例: [{"class": "CLSName", "hwnd": 0x123}, {"class": "CLSName2", "hwnd": 0x567}]
                        "w"             : {UInt}
                        "h"             : {UInt}
                        "x"             : {Int}
                        "y"             : {Int}
                    }
        */
        
        if ( ( _hwnd := this.hwndFormat(hwnd) ) == "")
        {
            return { "Error": ( "wrong hwnd [") . (hwnd) . ("]") }
        }
        if not WinExist(_hwnd)
        {
            return { "Error": ("win not exist: ") . (hwnd) }
        }
        
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

        ret := {}
        ret.Error           := ""
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
    FindWindow(filter)      ;~ win.FindHwnd()
    {
        /*
        简介: 通过过滤条件查找窗口

        参数: 
            [1] filter {Associative Array} 筛选窗口的条件 可有以下选项:
            
                Title       : {String}  窗口完整匹配标题
                Class       : {String}  窗口类名
                Exe         : {String}  程序名称
                Path        : {String}  路径
                w           : {Int}     完整窗口宽度
                h           : {Int}     完整窗口高度
                cw          : {Int}     窗口客户区宽度
                ch          : {Int}     窗口客户区高度
                Style       : {UInt}    窗口Style属性
                ExStyle     : {UInt}    窗口ExStyle属性
                ChildStrLs  : {String}  由 winget 的 ControlList 返回的字符串
        
        返回: {Array}   窗口列表
        */  

    }

    ;-------------------------  -------------------------


    GetAHwnd()
    {
        local hwnd
        winget, hwnd, id, A
        return hwnd
    }

    GetClientSize(hWnd) 
    {
        /*
        简介: 获取客户区尺寸
        */
        VarSetCapacity(rect, 16)
        DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
        return { "w" : NumGet(rect, 8, "int"), "h" :  NumGet(rect, 12, "int") }
    }

    GetPos(hwnd)
    {
        WinGetPos, x, y, , , % _hwnd
        return {"x" : x, "y" : y}
    }

    GetClientPos(hwnd)
    {
        /*
        简介: 获取窗口客户区全屏坐标
        */
        local x, y
        ret := this.GetPos(hwnd)
        cp  := PosToClient(hwnd, ret.x, ret.y)
        return { "x" : (x- cp.x), "y" : (y- cp.y) }
    }


    PosToClient(hWnd, x, y) 
    {
        /*
        简介: 将坐标转换为相对窗口客户区的坐标
        */
        VarSetCapacity(pt, 8), NumPut(y, NumPut(x, pt, "int"), "int")

        if !DllCall("ScreenToClient", "ptr", hWnd, "ptr", &pt)
            return false

        return {"x" : NumGet(pt, 0, "int"), "y" : NumGet(pt, 4, "int")}
    }

    ;--------------------------------------------
    class msg
    {
        
    }
    ;--------------------------------------------
    class op
    {

    }
}