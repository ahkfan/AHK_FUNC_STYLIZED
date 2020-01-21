#SingleInstance force

/*
	此例故障, 未知BUG
*/


;~ 示例1: 创建 键盘数字

;~ 唯一参数为2维列表, 代表从上到下, 从左到右的格式

o1 := new KeyTable([[7,8,9], [4,5,6], [1,2,3]])

;~ 该方法创建特定键顺序到图案的功能函数
o1.Key2Func(1112, "执行1112")

/*
r1 := o1.exec(2223)		;~ 被执行
r2 := o1.exec(5556)		;~ 被执行
r3 := o1.exec(12)		;~ 不被执行
*/
Loop, 9
	Hotkey, ^Numpad%A_Index%, fc

return

fc:
	k := subStr(A_ThisHotkey, -0)
	xx .= k
	ToolTip, % xx
	SetTimer, ExecIt, -300
return

ExecIt:
	o1.exec(xx)
	xx := ""
return


执行1112:
	MsgBox, % A_ThisLabel
return


/*

;~ 示例2: 创建 键盘字母
ls := []
ls.push(StrSplit("qwertyuiop"))
ls.push(StrSplit("asdfghjkl"))
ls.push(StrSplit("zxcvbnm"))

o2:= new KeyTable(ls)

;~ 定义键到函数对象
o2.Key2Func("qwedc", func("执行函数qwedc").bind("执行一个函数对象中的消息"))

;~ 执行连续字符图案
r1 := o2.Exec("abcde")
r2 := o2.Exec("werfv")
r3 := o2.Exec("ertgb")

MsgBox, 执行情况`n%r1%`n%r2%`n%r3%
*/
return


class StrFunc
{
	type := ""
	func := ""

	__New(funcStr)
	{

		Loop, parse, funcStr, % ","
		{
			if (A_Index = 1) 						;~ 功能指向对象时
			{
				s := A_LoopField
				if instr(s, ".")
				{
					this.type := "o"
					loop, parse, s, % "."
					{
						if (A_Index = 1)
							obj := %A_LoopField%
						else
							obj := obj[A_LoopField]
					}
					this.func := obj
				}
				else if IsFunc(s)		;~ 功能指向函数时
				{
					this.type := "f"
					this.func := func(s)
				}
				else if isLabel(s)		;~ 功能指向标签时
				{
					this.type := "l"
					this.func := s
				}
			}
			else
			{
				if (this.type = "l")
				{
					break
				}
				sParam := A_LoopField
				if not params
				{
					params := []
				}
				params.push(sParam)
			}
		}
	}

	Call(params*)
	{
		static dict := {"o": "CallObjMethod", "f": "CallFunction", "l": "GoSubLabel"}
		return this[dict[this.type]](params*)

	}
	CallObjMethod(params*)
	{
		return params.length() ? this.func(params*) : this.func(this.params*)
	}

	CallFunction(params*)
	{
		return params.length() ? this.func.call(params*) : this.func.call(this.params*)
	}

	GoSubLabel()
	{
		gosub, % this.func
	}
}



class KeyTable {

	__new(lsInto)
	{
		;~ 创建键坐标, 唯一参数为2维列表
		this.posdict := {}
		for i, v in lsInto
			for j, k in v
				this["posdict"][k] := [j, i]

		this.funcDict := {}
	}


	ReadStr2Key(str) {

		if (strlen(str) < 2)
		{
			return ""
		}

		key := ""
		for i, v in StrSplit(str)
		{
			if not this["posdict"]["haskey"](v)
			{
				;MsgBox, % "错误`n" v " < 该字符未存在坐标字典中"
				return ""
			}

			if (A_Index <> 1)
			{
				key .= "x" . (this["posdict"][v][1] - Pos1[1]) . "y" (this["posdict"][v][2] - Pos[2])
			}
			Pos := this["posdict"][v]
		}
		return key
	}

	Key2Func(str, FuncObj_Label)
	{
		key := this.ReadStr2Key(str)
		if this["funcDict"]["haskey"](key)
		{
			;MsgBox, <%str%>该键图案已被定义`n请勿重复定义
			return false
		}
		this["funcDict"][this.ReadStr2Key(str)] := FuncObj_Label
		return true
	}

	Exec(str) {

		key := this.ReadStr2Key(str)

		if not key
		{
			return false
		}

		if not this.funcDict.HasKey(key)
		{
			return false
		}

		MsgBox, % obj_dbg2(this.funcDict)
		f := this["funcDict"][key]


		if isobject(f)
		{
			f.call()
		}
		else if islabel(f)
		{
			gosub, % f
		}
		else
		{
			return false
		}

		return true

	}
}
