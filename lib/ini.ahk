; LIB OF INI
; 未经测试

fsini()
{
    Return new __CLASS_AHKFS__INI
}

class __CLASS_AHKFS__INI 
{
    __New()
    {
        IniAST := {}
        ObjRawSet(this, "IniAST", IniAST)
    }

    __Set(section, key, value)
    {
        this.IniAST[section, key] := value
        Return this
    }

    __Get(section := "", key := "")
    {
        if key
            Return this.IniAST[section, key]
        else if section
            Return this.IniAST[section]
        else
            Return this.IniAST
    }

    GetAllSection()
    {
        sections := []
        for section,_ in this.IniAST
            sections.Push(section)
        Return sections
    }

    Delete(section, key := "")
    {
        if filename == ""
            filename := this,filename
        Else
            this.filename := filename
        
        IniDelete, Filename, Section , Key
        Return this
    }

    Write(filename)
    {
        str := ""
        for section, pairs in this.IniAST
        {
            str .= "[" . section . "]`n"
            for key, value in pairs
                str .= key . " = " . value . "`n"
        }
        
        file := FileOpen(filename, "w")
        if IsObject(file)
            Throw Exception("File open fail.", -1)
        file.Write(str)
        file.Close()
    }

    Parse(file)
    {
        IfNotExist %file%
            Throw Exception("None exist file passed!", -1)
        
        currentSection := ""

        Loop, Read, %file%
        {
            Contain := Trim(A_LoopReadLine) 
            ; delete comment
            if InStr(Contain, ";")
                Contain := SubStr(Contain, 1, InStr(Contain, ";") - 1)
            ; section
            if SubStr(Contain, 1, 1) == "["
            {
                if SubStr(Contain, 0) != "]"
                    Throw Exception("Invaild section define! Expect a ""]""", -1)
                currentSection := SubStr(Contain, 2, -1)
                ; Section should be unique
                if this.IniAST.HasKey(currentSection)
                    Throw Exception("Duplicate section!")
            }
            ; key and value
            else
            {
                if not assignPos := InStr(Contain, "=")
                    Throw Exception("Invaild assign! Expect a ""=""", -1)
                k := Trim(SubStr(Contain, 1, assignPos-1))
                ; make sure key is correct
                RegExMatch(k, "\s*[_a-zA-Z][_a-zA-Z0-9]*", rightK)
                if rightK != k
                    Throw Exception("Invaild key!", -1)
			    v := Trim(SubStr(Contain, assignPos+1))
                this.IniAST[currentSection, k] := v 
            }
        }
    }
}

