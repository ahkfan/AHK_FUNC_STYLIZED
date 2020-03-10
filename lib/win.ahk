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

    ; TODO: Need to modfiy to fs style

    WinActivate(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinActivate %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinActivateBottom(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinActivateBottom %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinClose(WinTitle:="", WinText:="", SecondsToWait:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinClose %WinTitle%, %WinText%, %SecondsToWait%, %ExcludeTitle%, %ExcludeText%
    }
    WinGetClass(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGetClass OutputVar, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar
    }
    WinGetClientPos(ByRef X:="", ByRef Y:="", ByRef Width:="", ByRef Height:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local hWnd, RECT
        hWnd := WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText)
        VarSetCapacity(RECT, 16, 0)
        DllCall("user32\GetClientRect", Ptr,hWnd, Ptr,&RECT)
        DllCall("user32\ClientToScreen", Ptr,hWnd, Ptr,&RECT)
        X := NumGet(&RECT, 0, "Int"), Y := NumGet(&RECT, 4, "Int")
        Width := NumGet(&RECT, 8, "Int"), Height := NumGet(&RECT, 12, "Int")
    }
    WinGetControls(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, ControlList, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return StrSplit(OutputVar, "`n")
    }
    WinGetControlsHwnd(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar, ControlsHwnd, i
        WinGet OutputVar, ControlListHwnd, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        ControlsHwnd := StrSplit(OutputVar, "`n")
        for i in ControlsHwnd
            ControlsHwnd[i] += 0
        return ControlsHwnd
    }
    WinGetCount(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, Count, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar
    }
    WinGetExStyle(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, ExStyle, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar + 0
    }
    WinGetID(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar + 0
    }
    WinGetIDLast(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, IDLast, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar + 0
    }
    WinGetList(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar, List
        WinGet OutputVar, List, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        List := []
        Loop % OutputVar
            List.Push(OutputVar%A_Index% + 0)
        return List
    }
    WinGetMinMax(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, MinMax, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar
    }
    WinGetPID(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, PID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar
    }
    WinGetPos(ByRef X:="", ByRef Y:="", ByRef Width:="", ByRef Height:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinGetPos X, Y, Width, Height, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinGetProcessName(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, ProcessName, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar
    }
    WinGetProcessPath(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, ProcessPath, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar
    }
    WinGetStyle(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, Style, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar + 0
    }
    WinGetText(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGetText OutputVar, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        if !ErrorLevel
            return OutputVar
    }
    WinGetTitle(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGetTitle OutputVar, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar
    }
    WinGetTransColor(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, TransColor, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar
    }
    WinGetTransparent(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local OutputVar
        WinGet OutputVar, Transparent, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return OutputVar
    }
    WinHide(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinHide %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinKill(WinTitle:="", WinText:="", SecondsToWait:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinKill %WinTitle%, %WinText%, %SecondsToWait%, %ExcludeTitle%, %ExcludeText%
    }
    WinMaximize(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinMaximize %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinMinimize(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinMinimize %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinMinimizeAll()
    {
        WinMinimizeAll
    }
    WinMinimizeAllUndo()
    {
        WinMinimizeAllUndo
    }
    WinMove(Params*) ;X, Y [, Width, Height, WinTitle, WinText, ExcludeTitle, ExcludeText]
    {
        local WinTitle, WinText, X, Y, Width, Height, ExcludeTitle, ExcludeText
        local Len
        if (Len := Params.Length())
        {
            if (Len > 2)
            {
                X            := Params[1]
                Y            := Params[2]
                Width        := Params[3]
                Height       := Params[4]
                WinTitle     := Params[5]
                WinText      := Params[6]
                ExcludeTitle := Params[7]
                ExcludeText  := Params[8]
                WinMove %WinTitle%, %WinText%, %X%, %Y%, %Width%, %Height%, %ExcludeTitle%, %ExcludeText%
            }
            else
            {
                X := Params[1]
                Y := Params[2]
                WinMove %X%, %y%
            }
        }
        else
            WinMove
    }
    WinMoveBottom(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinSet Bottom,, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinMoveTop(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinSet Top,, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinRedraw(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinSet Redraw,, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinRestore(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinRestore %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinSetAlwaysOnTop(Value:="Toggle", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local Hwnd
        WinGet Hwnd, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        if (!Hwnd)
            return 0

        if Value in 1,0,-1 ; On,Off,Toggle
            Value := Value == -1 ? "Toggle" : Value ? "On" : "Off"

        if Value not in On,Off,Toggle
            throw Exception("Parameter #1 invalid.", -1) ; v2 raises an error

        WinSet AlwaysOnTop, %Value%, ahk_id %Hwnd%
        return 1
    }
    WinSetEnabled(Value, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local Hwnd
        WinGet Hwnd, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        if (!Hwnd)
            return 0

        ; 1, 0 and -1 are compared as strings, non-integer values(e.g.: 1.0) are not allowed
        local Style
        if (Value = "Toggle" || Value == "-1")
        {
            WinGet Style, Style, ahk_id %Hwnd%
            Value := (Style & 0x8000000) ? "On" : "Off" ; WS_DISABLED = 0x8000000
        }

        if (Value = "On" || Value == "1")
            WinSet Enable,, ahk_id %Hwnd%
        else if (Value = "Off" || Value == "0")
            WinSet Disable,, ahk_id %Hwnd%
        else
            throw Exception("Paramter #1 invalid.", -1) ; v2 raises an error
        return 1
    }
    WinSetExStyle(N, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinSet ExStyle, %N%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return !ErrorLevel
    }
    WinSetRegion(Options:="", WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinSet Region, %Options%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return !ErrorLevel
    }
    WinSetStyle(N, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinSet Style, %N%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        return !ErrorLevel
    }
    WinSetTitle(NewTitle, Params*) ;NewTitle [, WinTitle, WinText, ExcludeTitle, ExcludeText]
    {
        local WinTitle, WinText, ExcludeTitle, ExcludeText
        if (Params.Length())
        {
            WinTitle     := Params[1]
            WinText      := Params[2]
            ExcludeTitle := Params[3]
            ExcludeText  := Params[4]
            WinSetTitle %WinTitle%, %WinText%, %NewTitle%, %ExcludeTitle%, %ExcludeText%
        }
        else
            WinSetTitle %NewTitle%
    }
    WinSetTransColor(ColorN, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local Hwnd
        WinGet Hwnd, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        if (!Hwnd)
            return 0

        WinSet TransColor, %ColorN%, ahk_id %Hwnd%
        return 1
    }
    WinSetTransparent(N, WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        local Hwnd
        WinGet Hwnd, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
        if (!Hwnd)
            return 0

        WinSet Transparent, %N%, ahk_id %Hwnd%
        return 1
    }
    WinShow(WinTitle:="", WinText:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinShow %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
    }
    WinWait(WinTitle:="", WinText:="", Seconds:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinWait %WinTitle%, %WinText%, %Seconds%, %ExcludeTitle%, %ExcludeText%
        return ErrorLevel ? 0 : WinExist()
    }
    WinWaitActive(WinTitle:="", WinText:="", Seconds:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinWaitActive %WinTitle%, %WinText%, %Seconds%, %ExcludeTitle%, %ExcludeText%
        return ErrorLevel ? 0 : WinExist()
    }
    WinWaitClose(WinTitle:="", WinText:="", Seconds:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinWaitClose %WinTitle%, %WinText%, %Seconds%, %ExcludeTitle%, %ExcludeText%
        return !ErrorLevel
    }
    WinWaitNotActive(WinTitle:="", WinText:="", Seconds:="", ExcludeTitle:="", ExcludeText:="")
    {
        WinWaitNotActive %WinTitle%, %WinText%, %Seconds%, %ExcludeTitle%, %ExcludeText%
        return !ErrorLevel
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