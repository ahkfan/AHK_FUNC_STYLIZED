
"".base.__Get := func("String_Property_Trans")

var := 567
MsgBox, % "字符串长度: " var.len

A_Index.foo		;~ 调用不存在的属性时

str := "段1|段2|段3"
for i, v in str.split.("|")
{
	MsgBox, % "当前段: " v
}


MsgBox, % "后6个字符是: " "你的身份证号码是: 350181".sub.(-5)

MsgBox, 即将启动当前脚本所在文件夹%A_ScriptDir%

A_ScriptDir.Run.()

return


String_Property_Trans(nonobj, key) 
{
	if String_Propertys.HasKey(key)
	{
		return String_Propertys[key](nonobj)		;~ 属性调用
	}

	if String_Methods.HasKey(key)
	{
		return String_Methods.__Exec(nonobj, key)	;~ 方法调用
	}

	MsgBox, %key% > 不属于字符串方法

	return ""
}

String_Methods_Receive(var*) 
{
	return String_Methods[String_Methods.key](var*)
}

class String_Propertys 
{
	len(Self) 
	{
		return strlen(Self)
	}
}


class String_Methods 
{
	;-----------------------------------
	__Exec(nonobj, key)
	{
		static f := func("String_Methods_Receive")
		this.self := nonobj, this.key := key
		return f
	}
	;-----------------------------------
	split(Delimiter := "", OmitChars := "") 
	{
		return StrSplit(this.self, Delimiter, OmitChars)
	}

	;-----------------------------------
	sub(StartPos := 1, len := "")
	{
		if (len = "")
			return SubStr(this.self, StartPos)
		return SubStr(this.self, StartPos, len)
	}

	;-----------------------------------
	Run()
	{
		Run, % this.self
	}
}

