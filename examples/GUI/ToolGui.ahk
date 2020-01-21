#SingleInstance force

;~ 创建示例
human := new ToolGui("abc", {"kEdit": {"姓名": "某人"
									, "性别": "男"
									, "电话号码": "13906910000"}})

return

;~ 调用示例
f1::
	info := human.get()

	if not info
		MsgBox, 你关闭了选项窗口
	else
		MsgBox, % "姓名:"		info["姓名"] "`n"
				. "性别:" 		info["性别"] "`n"
				. "电话号码:"	info["电话号码"]

return


;~ 唯一按钮默认控件事件
ToolGui_Button(hwnd) {

	obj := ToolGui["btDict"]["@" . hwnd]
	obj.closeSubmit := true
	Gui, % obj.GUI_NAME ":hide", , % obj.title

}

class ToolGui {

	static i := 0

	static head := "ToolGui_"

	static nameDict := {}		;~ 用户定义名称到对象的索引, 一个名称对应一个对象

	static btDict := {}			;~ 按钮到对象的索引, 一个按钮对应一个对象

	static mostLeft := 6		;~ 左侧对齐起点

	static mostRight := 0		;~ 控制唯一按钮的x2坐标(宽度)

	static btH	:= 30				;~ 按钮控件默认高度

	__New(name, buildDict,iniDir := "") {
		cls := this.__class
		cls := %cls%

		;~ 检验名称是否重复
		if cls.nameDict.haskey(name) {
			MsgBox, % "请勿重复创建窗口: " name
			return ""
		}

		;~ 检验键名是否重复
		d := {}
		for k, obj in buildDict {
			for k in obj {
				if d.HasKey(k) {
					MsgBox, % "new ToolGui() warning!`n(" k ") : this key got duplicate.`nGui create faild."
					return ""
				}
				d[k] := ""
			}
		}
		d := ""

		;~ 正式创建GUI
		cls["nameDict"][name] := this
		cls.i += 1
		cls.mostLeft := 6

		this.name := name

		;~ gui名称
		this.GUI_NAME 	:= cls.head . cls.i

		;~ 标题
		this.title 		:= cls.head . name

		;~ 配置文件
		this.ini := iniDir "\" name ".ini"

		;~ 所有控件对象
		this.children := []

		;~ 当前窗口句柄
		this.hwnd := ""

		;~ 创建按钮

		Gui, % this.GUI_NAME ":+hwnd@toolHwnd +toolwindow +alwaysontop"
		Gui, % this.GUI_NAME ":add", button, % "gToolGui_Button h" cls.btH " hwnd@bt x" cls.mostLeft, Submit

		this.hwnd := @toolHwnd
		this.hwndBT := @bt
		this.hwndEx := @bt

		cls["btDict"]["@" format("{1:i}", @bt)] := this

		for key, var in buildDict
			this.add(key, var)

		w := cls.mostRight - ctrl_getXY(@bt)["x"]
		GuiControl, move, % @bt, % "w" w

	}

	;----------------------------------------------
	;~ 阻塞运行并获取所有选项的键值对, 期间关闭GUI 返回 "" 空值
	get() {
		this.closeSubmit := false

		ex := A_DetectHiddenWindows
		DetectHiddenWindows, off
		Gui, % this.GUI_NAME ":show", , % this.title
		loop {
		} until not winexist("ahk_id " this.hwnd)


		if (this.closeSubmit) {
			ret := {}
			for i, obj in this.children
				ret := obj_join(ret, obj.get())
		} else {
			ret := ""
		}
		DetectHiddenWindows, % ex
		return ret
	}

	;----------------------------------------------
	;~
	getObjByName(name) {
		cls := this.__class
		cls := %cls%
		return cls["nameDict"][name]
	}

	;~ 添加控件
	add(type, dict) {
		o := ToolGui[type]
		this.children.push(new o(this, dict))
	}

	;-------------------------------------
	;~ 创建 键(text控件): 值(编辑框) 竖排列表
	class kEdit {

		;~ 编辑框宽度
		static EditW := 150

		;~ 控件高度
		static CtrlH := 18

		__New(parent, dict) {
			static textEnd := ":"

			cls := parent.__class
			cls := %cls%

			this.dict := {}
			;---------------------
			;~ 最长控件尺寸

			wMax := 0
			for key in dict {
				w := ctrl_try_get_size("text", key . textEnd).w
				if (w > wMax)
					wMax := w
			}

			for key, var in dict {
				p := ctrl_getOnBottom(parent.hwndEx, 8)
				gui, % parent.GUI_NAME ":add", text, % "hwnd@t right w" wMax " h" this.CtrlH " x" p.x " y" p.y, % key . textEnd

				p := ctrl_getOnRight(@t, 5, -2)
				gui, % parent.GUI_NAME ":add", edit, % "hwnd@e w" this.EditW " h" this.CtrlH " x" p.x  " y" p.y, % Var

				x2 := ctrl_getXY2(@e).x2
				if (x2 > cls.mostRight)
					cls.mostRight := x2

				parent.hwndEx := @t
				this["dict"][key] := @e
			}
		}

		get() {
			ret := {}
			for key, hwnd in this["dict"] {
				GuiControlGet, var, , % hwnd
				ret[key] := var
			}
			return ret
		}
	}

}
;---------------------------------------------------------------------
;~ 合并右侧字典到左侧, 如存在相同键, B将覆盖左侧A的值, 不改变AB字典, 返回新字典
obj_join(objA, objB) {
    ret := {}
    for key, var in objA
        ret[key] := var
    for key, var in objB
        ret[key] := var
    return ret
}

;-------------------------------------
;~ 取相对于垂直下侧的 x, y 坐标
ctrl_getOnBottom(hwnd, y := 0, x := 0) {
	GuiControlGet, pos, pos, % hwnd
	y := posy + posh + y
	x := posx + x
	return {x: x, y: y}
}

;-------------------------------------
;~ 取相对水平右侧位置的 x,y坐标
ctrl_getOnRight(hwnd, x := 0, y := 0) {
	GuiControlGet, pos, pos, % hwnd
	x := posx + posw + x
	y := posy + y
	return {x: x, y: y}
}

;-------------------------------------
;~ 计算预见的控件尺寸, 返回w h
ctrl_try_get_size(ctrlType, text) {
	static name := "textGuiWidthGet"
	Gui, % name ":destroy"
	Gui, % name ":add", % ctrlType, hwnd@ctrl, % text
	GuiControlGet, pos, pos, % @ctrl
	Gui, % name ":destroy"
	return {w:posw, h:posh}
}

;-------------------------------------
;~ 取相对水平右侧位置的 x,y坐标
ctrl_getPos(hwnd) {
	GuiControlGet, pos, pos, % hwnd
	return {x:posx, y:posy, w:posw, h:posh, x2:posx + posw, y2: posy+posh}
}

ctrl_getWH(hwnd) {
	GuiControlGet, pos, pos, % hwnd
	return {w:posw, h:posh}
}

ctrl_getXY(hwnd) {
	GuiControlGet, pos, pos, % hwnd
	return {x:posx, y:posy}
}

ctrl_getXY2(hwnd) {
	GuiControlGet, pos, pos, % hwnd
	return {x2:posx + posw, y2: posy+posh}
}