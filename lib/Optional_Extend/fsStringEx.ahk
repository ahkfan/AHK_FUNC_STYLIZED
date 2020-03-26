/*
	Optional impoved lib of string
	Provide a more OOP way to use strings
	By using default base, "." is available to get property or call method fit to strings
	such as "abc".len will retrieve the length of "abc", which is 3 in this case

	MUST BE EXPLICIT INCLUDE

	Function:
		split()          Same as StrSplit(), just omit pass string itself, other functions all do not need to pass string itself
		lower(), upper() Same as StringLower and StringUpper, but cannot convert to title form
		title()          convert string into title form
		join(iterable)   Return a string which is the concatenation of the strings in iterable.
						 A Error will be throwed if there are any non-string values in iterable
						 " ".join(["a", "b", "c"]) will return "a b c"
		replace()        Same as StrReplace()

	Property:
		len              Return length of a string
		1,2,3……			 

*/


; auto execute
"".base.base := __CLASS_FS_STRING_EXTEND

class __CLASS_FS_STRING_EXTEND
{

	__Call(method, args*)
    {
		static _ := __CLASS_FS_STRING_EXTEND.Method_Call
		if not _.haskey(method)
			throw Exception("Call non-exist function.", -1)
		try
			return _[method](this, args*)
		catch err
			throw Exception(err.Message, -1, err.What)
	}

	__Get(property*)
    {
		static _ := __CLASS_FS_STRING_EXTEND.Property_Get

		if property[1] is Integer
			return __CLASS_FS_STRING_EXTEND.Property_Get.StrCut(this, property*)
		if not _.haskey(property[1])
        {
			throw Exception("Get non-exist property.", -1)
		}
		return _[property[1]]
	}


	__Set(key, var*)
    {
        throw Exception("String property only permits reading.", -1)
	}

;------------------------- define string method -------------------------
	class Method_Call
	{
		Split(str, args*)
		{
			if (args.length() > 3)
				throw Exception("Too many parameters passed to function.", -1)
			return StrSplit(str, args*)
		}

		Lower(str, args*)
		{
			if args.length()
				throw Exception("Too many parameters passed to function.", -1)
			StringLower, str, str
			return str
		}

		Upper(str, args*)
		{
			if args.length()
				throw Exception("Too many parameters passed to function.", -1)
			StringUpper, str, str
			return str
		}

		Title(str, args*)
		{
			if args.length()
				throw Exception("Too many parameters passed to function.", -1)
			StringUpper, str, str, T
			return str
		}

		Replace(str, args*)
		{
			if (args.length() > 4)
				throw Exception("Too many parameters passed to function.", -1)
			else if (args.length() < 1)
				throw Exception("Too few parameters passed to function.", -1)
			return StrReplace(str, args*)
		}

		Join(str, char_list, args*)
		{
			res_str := ""
			if (args.length())
				throw Exception("Too many parameters passed to function.", -1)
			for _, substr in char_list
			{
				if (IsObject(substr))
					throw Exception("Type error. Get a non-string value in iteration")
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

		StrCut(str, start, end := "")
		{
			start := (start>0) ? start : start+1
			len := (end == "") ? 1 : end - start + 1
			return SubStr(str, start, len)
		}
	}
}
