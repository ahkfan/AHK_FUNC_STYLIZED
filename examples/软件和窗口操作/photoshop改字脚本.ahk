#UseHook
f9::go()

go(stratnum := 200, stopnum := 231) {
	pstitle := "ahk_class Photoshop"
	loop {
		Send, {t}
		Click, 688, 537
		Send, ^a
		Clipboard := ""
		Clipboard := stratnum
		ClipWait
		Send, ^v
		Sleep 500
		Send, {NumpadEnter}
		sleep 500
		PostMessage, 0x111, 33, , , % pstitle					;~ 另存为
		sleep 500
		ControlSetText,  Edit1, % stratnum, ahk_class #32770	;~ 保存文件
		sleep 300
		Control, choose, 10, ComboBox3, ahk_class #32770
		sleep 1000
		loop 3
		{
			ControlClick, x507 y364, ahk_class #32770
			sleep 500
		}
		loop 3
		{
			ControlClick, x308 y41, ahk_class PSFloatC
			sleep 500
		}

		stratnum += 1
	} until (stratnum = stopnum)
}