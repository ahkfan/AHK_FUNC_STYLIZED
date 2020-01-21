main:
	MsgBox, % a_ahkversion
	窗口数量限制:=5
	a := 0
	loop, 10
	{
	hotkey,  ~%a%, 同步按键
	a+=1
	}
	for i, v in ["q","e","r", "-","="]
	   hotkey, % "~" q-v, 同步按键
return

同步按键:
	key:=substr(a_thishotkey, 2, 1)
	keywait, % key


	if not winactive("魔兽世界")
	   return

	loop, % wowid
	{
		id := "ahk_id " wowid%a_index%
		ControlSend, ,% key, % id

		if (a_index > 窗口数量限制) {
			break
		}
	}
return


;~这行刷新窗口
f1::winget, wowid, list, 魔兽世界