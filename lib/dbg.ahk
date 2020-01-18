; LIB OF DEBUG
; 暂时搁置

class Cdbg
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