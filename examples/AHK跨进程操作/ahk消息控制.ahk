
/* 0x201	WM_LBUTTONDOWN		窗口左击客户区时响应
SetWinDelay, 0
Gui,Show, w100 h100, this_win_title
OnMessage(0x201, "moveto")
return

moveto() {
	;根据鼠标坐标偏移移动窗口
	MouseGetPos, mx1, my1
	WinGetPos, ex_win_x, ex_win_y, , , this_win_title
	while getkeystate("lbutton", "p")
	{
		MouseGetPos, mx2, my2
		x偏移 := mx2 - mx1, y偏移 := my2 - my1
		if (x偏移 = 0 && y偏移 = 0)
			continue
		win_m_x := ex_win_x + x偏移
		win_m_y := ex_win_y + y偏移
		WinMove,  this_win_title, , % win_m_x, % win_m_y
		WinGetPos, ex_win_x, ex_win_y, , , % this_win_title
	}
}
*/
/* 0xA1		WM_NCLBUTTONDOWN	窗口左击非客户区时响应。

Gui, Add, Text, g#control_label, 试试用鼠标左键拖动我
Gui,Show, , this_win_title
return

#control_label:
	; text 或 picture 控件 normal 拖行事件激活的标签
	PostMessage, 0xA1, 0, , , this_win_title
return

*/
/* 0x03		WM_MOVE				窗口在移动窗口时响应

Gui, Add, Text, g#control_label, 试试用鼠标左键拖动我
Gui,Show, , this_win_title
return

#control_label:
	; text 或 picture 控件 normal 拖行事件激活的标签
	PostMessage, 0xA1, 0, , , this_win_title
return

*/
/* 0x302						粘粘命令
PostMessage,  0x302, , , , ahk_class TXGuiFoundation	;发送粘粘命令
*/
/* 0x111	WM_COMMAND			AHK脚本消息控制命令参数
WM_COMMAND := 0x111
ID_PauseScript := 65403
ID_SuspendScript := 65404
ID_EditScript := 65401
ID_ReloadScript := 65400
ID_ExitScript := 65405
ID_ViewHistory := 65406
ID_ViewVariables := 65407
ID_ViewHotkeys := 65408
*/