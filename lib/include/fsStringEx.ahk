/*
	Optional impoved lib of string
	Provide a more OOP way to use strings
	By using default base, "." is available to get property or call method fit to strings
	such as "abc".len will retrieve the length of "abc", which is 3 in this case
	
	MUST BE EXPLICIT INCLUDE
*/


; auto execute
"".base.base := __CLASS_FS_STRING_EXTEND    

class __CLASS_FS_STRING_EXTEND 
{

	__Call(method, args*) 
    {
		static _ := __CLASS_FS_STRING_EXTEND.Method_Call
		if not _.haskey(method)
        {
			throw Exception("Call non-exist function.", -1)
		}
		try
			return _[method](this, args)
		catch err
			throw Exception(err.Message, -1)
	}


	__Get(property) 
    {
		static _ := __CLASS_FS_STRING_EXTEND.Property_Get

		if not _.haskey(property)
        {
			if property is Integer
				return SubStr(this, property, 1)
			
			return ""
		}
		return _[property](this)
	}


	__Set(key, var*) 
    {
        throw Exception("String property only permits reading.", -1)
	}

;------------------------- define string method -------------------------
	class Method_Call
	{
		split(str, args) 
		{
			; unsupport for unpack parameters
			; thus, ugly and silly switch for this
			switch args.length()
			{
				
				case 1:
					return StrSplit(str, args[1])
				case 2:
					return StrSplit(str, args[1], args[2])
				case 3:
					return StrSplit(str, args[1], args[2], args[3])
				case 0:
					return StrSplit(str)
				Default:
					throw Exception("Too many parameters passed to function.", -1)
			}
		}
		
		lower(str, args)
		{
			if args.length()
				throw Exception("Too many parameters passed to function.", -1)
			StringLower, str, str
			return str
		}
		
		upper(str, args)
		{
			if args.length()
				throw Exception("Too many parameters passed to function.", -1)
			StringUpper, str, str
			return str
		}
		
		titler(str, args)
		{
			if args.length()
				throw Exception("Too many parameters passed to function.", -1)
			StringUpper, str, str, T
			return str
		}
		
		replace(str, args)
		{
			switch args.length()
			{
				
				case 1:
					return StrReplace(str, args[1])
				case 2:
					return StrReplace(str, args[1], args[2])
				case 3:
					return StrReplace(str, args[1], args[2], args[3])
				case 4:
					return StrReplace(str, args[1], args[2], args[3], args[4])
				case 0:
					throw Exception("Too few parameters passed to function.", -1)
				Default:
					throw Exception("Too many parameters passed to function.", -1)
			}
		}
		
		join(str, char_list)
		{
			res_str := ""
			if (char_list.length() > 1)
				throw Exception("Too many parameters passed to function.", -1)
			for _, substr in char_list[1]
			{
				res_str .= substr . str
			}
			return SubStr(res_str, 1, StrLen(res_str) - StrLen(str))
		}
	}

;------------------------- define string property get -------------------------
	class Property_Get 
	{
		len(str) 
		{
			return StrLen(str)
		}
	}

;-------------------------  -------------------------
}   ;~ end of __CLASS_FS_STRING_EXTEND
;-------------------------  -------------------------