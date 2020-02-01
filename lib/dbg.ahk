; LIB OF DEBUG
; 暂时搁置

dbg()
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