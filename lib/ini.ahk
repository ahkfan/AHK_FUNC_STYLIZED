; LIB OF INI
/*
    Require ordered_dict.ahk

    Example:
        ini := fsini()              ; return a instance of IniParser(__CLASS_AHKFS__INI)
        ini.Parser(filename)        ; parse a ini file
        ini[section, key] := value  ; set a section and a pair of key and value
        ini.write(filename)         ; write a ini tree to a file
    
    Functions:
        ini[section, ""] := ""      ; creat an empty section
        ini["", key] := val         ; search all section in ini tree. If the tree has the key, set value of key to val
                                    ; if there were more than one match, set the first key
        ini["", key]                ; search all section in ini tree. If the tree has the key, return the value of key
                                    ; if there were more than one match, return the first matched value

        ini.GetAllSections()        ; return all section name in a list
        ini.Insert(postion, section[, key, value])
                                    ; Insert a pairs after the postion(Key)
                                    ; if omit key and value, insert a section after the postion(section)
                                    ; if pass "" to section, function will search all section in ini tree
                                    ; and insert after the first matched postion(key)
        ini.InsertBefore(postion, section[, key, value])
                                    ; Insert a pairs before the postion(Key)
                                    ; if omit key and value, insert a section before the postion(section)
                                    ; if pass "" to section, function will search all section in ini tree
                                    ; and insert before the first matched postion(key)
        ini.HasSection(Section)     ; if tree has section name Section return True, else return False
        ini.HasKey(Section, Key)    ; if Section has Key return True, else return False
                                    ; if pass "" to Section, function will search all section in ini tree
                                    ; if tree has Key return True, else return False
        ini.Delete(Section[, Key])  ; delete key in a section, if key is "", delete the section
                                    ; if pass "" to section, function will search all section in ini tree
                                    ; and delete the first matched key-value pair

        If you have created a section, then you can use 
        ini[section][key] := value to creat a pair
        But creat a section and a pair at the same time by this way is not allowed
        Other way that used to set value in Associative Array is allowed

        Any way that used to get value in Associative Array is allowed
*/

; passed

#Include <ordered_dict>

fsini()
{
    Return new __CLASS_AHKFS__INI()
}

class __CLASS_AHKFS__INI 
{
    __New()
    {
        IniAST := new __CLASS_AHKFS__INIAST__()
        ObjRawSet(this, "IniAST", IniAST)
    }

    __Set(section, Key, Value)
    {
        this.IniAST[section, Key] := Value
        Return this
    }

    __Get(Section, Key := "")
    {
        Section := Section ? Section : this.IniAST.FindSection(Key)
        return this.IniAST.Get(Section, Key)
    }

    GetAllSections()
    {
        return this.IniAST.GetKeys()
    }

    Delete(section, key := "")
    {
        section := section ? section : this.IniAST.FindSection(key)
        if (key == "")
            this.IniAST.delete(section)
        this.IniAST[Section].delete(key)
    }

    Insert(postion, section, key := "", value := "")
    {
        section := section ? section : this.IniAST.FindSection(key)
        d := this.IniAST._Keys
        if (key)
        {
            c := this.IniAST[section]._Keys.Count()
            keylist := this.IniAST[Section]["_Keys"]
            while(A_Index <= c)
            {
                if (postion == keylist[A_Index])
                {
                    keylist.InsertAt(A_Index+1, Key)
                    this.IniAST[section]._Dict[key] := value
                    break
                }
            }
            ;~ throw Exception("Can not find postion key.",-1)
        }
        else
        {
            for index, aVal in this.IniAST._Keys
            {
                if (postion == aVal)
                {
                    this.IniAST._Keys.InsertAt(index+1, Section)
                    this.IniAST._Dict[Section] := new __CLASS_AHKFS__INIAST__.__Pairs__()
                    break
                }
            }
            ;~ throw Exception("Can not find postion section.", -1)
        }
        return this
    }

    InsertBefore(postion, section, key := "", value := "")
    {
        section := section ? section : this.IniAST.FindSection(key)
        d := this.IniAST._Keys
        if (key)
        {
            c := this.IniAST[section]._Keys.Count()
            keylist := this.IniAST[Section]["_Keys"]
            while(A_Index <= c)
            {
                if (postion == keylist[A_Index])
                {
                    keylist.InsertAt(A_Index, Key)
                    this.IniAST[section]._Dict[key] := value
                    break
                }
            }
            ;~ throw Exception("Can not find postion key.",-1)
        }
        else
        {
            for index, aVal in this.IniAST._Keys
            {
                if (postion == aVal)
                {
                    this.IniAST._Keys.InsertAt(index, Section)
                    this.IniAST._Dict[Section] := new __CLASS_AHKFS__INIAST__.__Pairs__()
                    break
                }
            }
            ;~ throw Exception("Can not find postion section.", -1)
        }
        return this
    }
    
    HasSection(Section)
    {
        return this.IniAST.Has(Section)
    }
    
    HasKey(Section , Key)
    {
        if (Section)
        {
            if (this.IniAST.FindSection(Key))
                return True
            else
                return False
        }
        return this.IniAST[Section].Has(Key)
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
        if (!IsObject(file))
        {
            Throw Exception("File open fail.", -1)
        }
        file.Write(str)
        file.Close()
    }

    Parse(file)
    {
        IfNotExist %file%
            Throw Exception("Non-exist file passed!", -1)
        
        currentSection := ""

        Loop, Read, %file%
        {
            Contain := Trim(A_LoopReadLine) 
            if (Contain == "")
                continue
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
                if this.IniAST.Has(currentSection)
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
                if (rightK != k)
                    Throw Exception("Invaild key!", -1)
			    v := Trim(SubStr(Contain, assignPos+1))
                this.IniAST[currentSection, k] := v 
            }
        }
    }
}

; Inner AST class, do not call it directly!    
class __CLASS_AHKFS__INIAST__ extends OrderedDict
{
    class __PAIRS__ extends OrderedDict
    {
        ; pass
    }
    
    __Set(Section, Key, Value)
    {
        local
        Section := Section ? Section : this.FindSection(Key)
        if (Section == "")
        {
            return this
        }
        if (this.Has(section)) 
        {
            this._Dict[section]["Set"](Key, Value)
        }
        else
        {
            this._Keys.Push(section)
            ; if key == "", we just creat an empty section
            if (Key)
                this._Dict[section] := new this.__PAIRS__(key, value)
            else
                this._Dict[section] := new this.__PAIRS__()
        }
        return this
    }

    FindSection(key)
    {
        for section, pairs in this
        {
            if (pairs.Has(key))
                return section
        }
        return ""
    }
    
    Get(section, key := "")
    {
        if (section == "")
        {
            return
        }
        if (key == "")
            return this._Dict[section]
        return this._Dict[section]["Get"](key)
    }
}
