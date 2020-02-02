; LIB OF INI
; __CLASS_AHKFS__INI __set pass
; other no pass yet

fsini()
{
    Return new __CLASS_AHKFS__INI
}

class __CLASS_AHKFS__INI 
{
    __New()
    {
        IniAST := new __CLASS_AHKFS__INIAST__
        ObjRawSet(this, "IniAST", IniAST)
    }

    __Set(section, pairs := "")
    {
        this.IniAST[section] := pairs
        Return this
    }

    __Get(section)
    {
        return this.IniAST[Section]
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
        if (key == "")
            this.IniAST.delete(section)
        this.IniAST[Section].delete(key)
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
                    Throw Exception("Duplicated section!")
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

; Inner AST class, do not call it directly!
class __CLASS_AHKFS__INIAST__
{
    ; TODO: finish class pairs and make AST fit to it
    
    ; Inner PAIRS class, do not call it directly!
    class __PAIRS__
    {
        ; 只为每一个 section 建立一个 pairs 类
        __New(pairs)
        {
            for key, val in pairs
                this.key := val
        }
        __Set(key, val*)
        {
            ; check set is correct or not
            ; only allow "(str)key: (str)val"
            if IsObject(val)
                throw Exception("value of a key must be a string", -1)
            ObjRawSet(this, key, val)
            return
        }
        __Get()
        {
            ; 我在这个地方抛异常是不是就不用管 key 不存在的问题了
            throw Exception("Get non-exist key!", -1)
        }
    }

    __Set(Section, pairs := "")
    {
        ; To set when section is ""
        if (section == "")
        {
            if IsObject(pairs)
            {
                for Asection, Apairs in this
                {
                    for key, val in Apairs
                    {
                        if (pairs.HasKey(key))
                        {
                            ObjRawSet(this, ASection, Object(key, val))
                            return this
                        }
                    }
                }
            }
            throw Exception("Set Non-exist key!", -1, "If you want to set a key, make sure it is under an exist seciton.")
        }
        ObjRawSet(this, Section, new this.__PAIRS__(pairs))
        return this
    }
    
    __Get(Section, pairs := "")
    {
        ; To get when section is ""
        if (section == "")
        {
            if IsObject(pairs)
            {
                for section, Apairs in this
                {
                    for key, val in Apairs
                    {
                        if (pairs.HasKey(key))
                            return val
                    }
                }
            }
            throw Exception("Get non-exist key!", -1)
        }
        throw Exception("Get non-exist section!", -1)
    }
}
    