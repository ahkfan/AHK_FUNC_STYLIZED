; LIB OF INI
; 未经测试

class Ini 
{
    ; 允许在连续的调用中省略不写 filename，此时的 filename 为上一次时操作的 filename 值
    filename := ""

    Read(filename, section := "", key := "")
    {
        out := ""
        IniRead, out, filename, section, key
        Return out
    }

    Delete(filename := "", section, key := "")
    {
        if filename == ""
            filename := this,filename
        Else
            this.filename := filename
        
        IniDelete, Filename, Section , Key
        Return this
    }

    ; TODO: 调制以适应 pairs 的写入方式
    Write(value, filename := "", section, key)
    {
        if filename == ""
            filename := this,filename
        Else
            this.filename := filename
        
        IniWrite, Value, Filename, Section, Key
        Return this
    }
}

fsini()
{
    Return Ini
}