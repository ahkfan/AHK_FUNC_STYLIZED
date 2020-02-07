;~ auto execute
"".base.base := __CLASS_FS_STRING_EXTEND    

;msgbox, % "abc".len





class __CLASS_FS_STRING_EXTEND 
{
    ;-------------------------  -------------------------
	__Call(method, args*) 
    {
		static _ := __CLASS_FS_STRING_EXTEND.Method_Call
		if not _.haskey(method)
        {
			return ""
		}
		return _[method](this, args.count(), args*)
	}

	;-------------------------  -------------------------
	__Get(property) 
    {
		static _ := __CLASS_FS_STRING_EXTEND.Property_Get

		if not _.haskey(property)
        {
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
;------------------------- define string method -------------------------
class Method_Call
{
    toCharLs(str) 
    {
        return strsplit(str)
    }
}

;------------------------- define string property get -------------------------
class Property_Get 
{
    len(str) 
    {
        return strlen(str)
    }
}

;------------------------- define string property set -------------------------
;class Property_Set 
;{
;~ 元函数 __Set() 跳转, 未明确
;}

;-------------------------  -------------------------
}   ;~ end of __CLASS_FS_STRING_EXTEND
;-------------------------  -------------------------