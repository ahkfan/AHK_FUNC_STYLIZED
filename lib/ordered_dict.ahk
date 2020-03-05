; An associative array will return key and value in order of insert order

; MUST BE EXPLICIT INCLUDE

class OrderedDict
{
    __New(pairs*)
    {
        ; pairs should be passed in (key1, value1, key2, value2, …)
        local
        _Keys := []
        _Dict := {}
        ObjRawSet(this, "_Keys", _Keys)
        ObjRawSet(this, "_Dict", _Dict)
        
        Loop % pairs.Count()//2
        {
            this._Keys.Push(pairs[A_Index*2-1])
            this._Dict[pairs[A_Index*2-1]] := pairs[A_Index*2]
        }
        
    }

    __Set(Key, Value)
    {
        local
        this._Keys.Push(Key)
        this._Dict[Key] := Value
    }

    __Get(Key)
    {
        local
        return this._Dict[Key]
    }

    Count()
    {
        return this._Keys.Count()
    }

    GetKeys()
    {
        return this._Keys
    }

    Get(Key)
    {
        local
        return this._Dict[Key]
    }

    Set(Key, Value)
    {
        local
        this._Keys.Push(Key)
        this._Dict[Key] := Value
    }

    HasKey(Key)
    {
        local
        return this._Dict.HasKey(Key)
    }

    Delete(Key)
    {
        local
        if !this._Dict.HasKey(Key)
            return this
        For index, aKey in this._keys
        {
            if (aKey == Key)
            {
                this._keys.RemoveAt(index)
                this._Dict.Delete(Key)
                return this
            }
        }
    }
    
    class Enumerator
    {
        __New(OrderedDict)
        {
            local
            this._ItemsEnum := OrderedDict._Keys._NewEnum()
            this.Dict := OrderedDict._Dict
            return this
        }
        
        Next(ByRef Key, ByRef Value := "")
        {
            local
            Result := this._ItemsEnum.Next(_, index)
            if(index)
            {
                Key   := index
                Value := this.Dict[index]
                return Value
            }
        }
    }
    
    _NewEnum()
    {
        local
        global OrderedDict
        return new OrderedDict.Enumerator(this)
    }
}
