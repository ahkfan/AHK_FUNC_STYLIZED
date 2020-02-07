;~ auto execute
"".base.base := __CLASS_FS_STRING_EXTEND    

class __CLASS_FS_STRING_EXTEND 
{
    ;-------------------------  -------------------------
	__Call(method, args*) 
    {
		static  _ := __CLASS_FSSTRINGEXBASE.Function_Call
		if not _.haskey(method)
        {
			return ""
		}
		return _[method](this, args.count(), args*)
	}

	;-------------------------  -------------------------
	__Get(property) 
    {
		static _ := __CLASS_FSSTRINGEXBASE.Property_Get
		if not _.haskey(key)
        {
            msgbox, 123
			return ""
		}
		return _[property](this)
	}
	/*
    ;-------------------------  -------------------------
	__Set(key, var) 
    {
        ;~ 尚不明确在元函数中取得字符串地址改变字符串本身内容的方法
		static  _ := String.Property_Set
		return
	}
    */
}


class __CLASS_FSSTRINGEXBASE
{
;------------------------- define string method -------------------------
class Function_Call
{
    toCharLs(str) 
    {
        return strsplit(str)
    }
}

;------------------------- define string property -------------------------
class Property_Get 
{
    len(str) 
    {
        return strlen(str)
    }
}

/*
;-------------------------  -------------------------
class Property_Set 
{
    ;~ 元函数 __Set() 跳转, 未明确
}
*/ 
}
