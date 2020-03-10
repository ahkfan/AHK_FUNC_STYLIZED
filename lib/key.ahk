;~键\

fsKey()
{
    return __CLASS_AHKFS_KEY
}

class __CLASS_AHKFS_KEY
{
    Send(Keys)
    {
        Send %Keys%
    }

    SendEvent(Keys)
    {
        SendEvent %keys%
    }
    
    SendInput(Keys)
    {
        SendInput %Keys%
    }

    ; maybe should put in conf
    SendMode(Mode)
    {
        SendMode %Mode%
    }

    SendPlay(Keys)
    {
        SendPlay %Keys%
    }
    
    SendRaw(Keys)
    {
        SendRaw %Keys%
    }

    SetHotkey(Param1, Param2:="", Param3:="")
    {
        Hotkey %Param1%, %Param2%, %Param3%
        if (InStr(Param1, "IfWin") || InStr(Param3, "UseErrorLevel"))
            return !ErrorLevel
    }

    CaretGetPos(ByRef OutputVarX:="", ByRef OutputVarY:="")
    {
        local GUITHREADINFO, hWnd, hWndC, Mode, OriginX, OriginY, POINT, RECT, TID
        ;this works but there was an issue regarding A_CaretX/A_CaretY not updating correctly:
        ;OutputVarX := A_CaretX, OutputVarY := A_CaretY
        hWnd := WinExist("A")
        VarSetCapacity(GUITHREADINFO, A_PtrSize=8?72:48, 0)
        NumPut(A_PtrSize=8?72:48, &GUITHREADINFO, 0, "UInt") ;cbSize
        TID := DllCall("user32\GetWindowThreadProcessId", Ptr,hWnd, UIntP,0, UInt)
        DllCall("user32\GetGUIThreadInfo", UInt,TID, Ptr,&GUITHREADINFO)
        hWndC := NumGet(&GUITHREADINFO, A_PtrSize=8?48:28, "Ptr") ;hwndCaret
        OutputVarX := NumGet(&GUITHREADINFO, A_PtrSize=8?56:32, "Int") ;rcCaret ;x
        OutputVarY := NumGet(&GUITHREADINFO, A_PtrSize=8?60:36, "Int") ;rcCaret ;y
        Mode := SubStr(A_CoordModeCaret, 1, 1)
        VarSetCapacity(POINT, 8)
        NumPut(OutputVarX, &POINT, 0, "Int")
        NumPut(OutputVarY, &POINT, 4, "Int")
        DllCall("user32\ClientToScreen", Ptr,hWndC, Ptr,&POINT)
        OutputVarX := NumGet(&POINT, 0, "Int")
        OutputVarY := NumGet(&POINT, 4, "Int")
        if (Mode = "S") ;screen
            return
        else if (Mode = "C") ;client
        {
            VarSetCapacity(POINT, 8, 0)
            DllCall("user32\ClientToScreen", Ptr,hWnd, Ptr,&POINT)
            OriginX := NumGet(&POINT, 0, "Int")
            OriginY := NumGet(&POINT, 4, "Int")
        }
        else if (Mode = "W") ;window
        {
            VarSetCapacity(RECT, 16, 0)
            DllCall("user32\GetWindowRect", Ptr,hWnd, Ptr,&RECT)
            OriginX := NumGet(&RECT, 0, "Int")
            OriginY := NumGet(&RECT, 4, "Int")
        }
        OutputVarX -= OriginX, OutputVarY -= OriginY
    }
}