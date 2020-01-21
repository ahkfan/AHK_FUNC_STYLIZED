#SingleInstance force
/* 临时热键创建工具

摸鱼写的...

界面说明, 由上而下:

	1. 编辑框 输入热键名称, 初始热键参考全局变量 key,  如 f1 , 如 +^1 如 a & b, 如 ~lbutton
	2. 列表框 选择输出文本, 对应 全局变量元素单位 textLs  双击删除文本
	3. 编辑框 由 4 按钮添加文本到 2 列表
	4. 按钮 参考3
	5. 按钮 启用热键, 启用后可禁用

其他说明:

	label_key_func 此标签处为热键功能定义块, 可自行作定制, 更改输出模式

	未加入保存配置到文件, 请勿多花时间做临时配置...

*/

SetKeyDelay, -1, -1

global key := "!1"

global textLs := ["hello world"]

;SendMode Input|Play|Event|InputThenPlay

global @theKey
, @TextLs
, @Text
, @addText

gui, +alwaysontop +toolwindow

Gui, add, edit, w200 hwnd@theKey, % key

Gui, add, listbox, w200 h200 hwnd@TextLs AltSubmit gdelItem

gui, add, edit, w200 h120 hwnd@Text, % text

gui, add, button, w200 h30 gaddText hwnd@addText, 添加

gui, add, button, w200 h50 grunIt, 启动

gui, show, % "x" (A_ScreenWidth - 300), 临时热键创建工具

newListBox()

return

changeHotkey(key, text) {

	static exKey, thisText

	if (exKey <> "")
		hotkey, % exKey, off

	if (key <> "") {
		hotkey, % key, label_key_func
		hotkey, % key, on
	}

	thisText := text

	exKey := key

	return


	label_key_func:
		;~ 此处为输出模式
		;send, % thisText
		;send, % {text} thisText
		;sendevent, % thisText
		;sendinput, % thisText
		;sendplay, % thisText
		sendraw, % thisText
	return
}


allDisabled(b) {
	op := (b ? "+" : "-") . "disabled"
	GuiControl,  % op, % @theKey
	GuiControl,  % op, % @Text
	GuiControl,  % op, % @TextLs
	GuiControl,  % op, % @addText
}

guiclose() {
	ExitApp
}

delItem(hwnd) {

	GuiControlGet, i, , % @TextLs
	if (a_guievent <> "doubleclick") {
		GuiControl, , % @Text, % textLs[i]
		return
	}

	if (i >= 1)
		textLs.removeat(i)

	newListBox()
}

runIt(hwnd) {


	GuiControlGet, btText, , % hwnd

	if (btText = "启用") {

		GuiControlGet, i, , % @TextLs

		text := textLs[i]

		if (text = "")
			return

		GuiControlGet, keyName, , % @theKey

		changeHotkey(keyName, text)

		allDisabled(1)
		GuiControl, , % hwnd, 禁用

	} else {
		changeHotkey("", "")
		allDisabled(0)
		GuiControl, , % hwnd, 启用
	}
}

newListBox() {

	GuiControl, , % @TextLs, % " "
	GuiControl, , % @TextLs, % "|"

	s := ""
	for i, text in textLs
		s .= text "|"

	GuiControl, , % @TextLs, % s
}

addText() {

	GuiControlGet, text, , % @Text

	if (text <> "") {
		GuiControl, , % @TextLs, % text
		textLs.push(text)
	}
}