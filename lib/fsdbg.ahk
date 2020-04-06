; LIB OF DEBUG
; 暂时搁置

; Lib of command about debug
/*
    dbg := fsdbg()

    dbg.Out(text)       same as OutputDebug
    dbg.ListVars(P)     same as ListVars, if P == true function will pasue script
    dbg.ListLines(P)    same as ListLines, if P == true function will pasue script

*/

fsdbg()
{
    return __CLASS_AHKFS_DEBUG
}

class __CLASS_AHKFS_DEBUG
{

    Out(text)
    {
        ; text must be a string
        OutputDebug, %text%
    }

    ListVars(P := True)
    {
        ListVars
        if P
            Pause
        Return this
    }

    ListLines(P := True)
    {
        ListLines
        if P
            Pause
        Return this
    }
}