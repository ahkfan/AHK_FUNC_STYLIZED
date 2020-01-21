/* 造了个轮子
	lwin + 数字键 			切换桌面
	ctrl + shift + 数字键	将鼠标下的窗口扔到对应组

*/

DetectHiddenWindows,off
#MaxHotkeysPerInterval, 70
#MaxThreadsPerHotkey, 1
SetWinDelay, -1
SetBatchLines, -1

global @ls_all_wins := []	; 此为二维数组
global i_exdesktop := 1		; 当前显示的桌面

i_maxdesknum := 3			; 创建桌面数量
Loop, % i_maxdesknum
{	; #(win)键加数字键(1-9)
	Hotkey, #%a_index%, #show_desktop
	Hotkey, #Numpad%a_index%, #put_to_group
	@ls_all_wins[a_index] := []
}

#putactive_winid_to_group(1)
return

#show_desktop:
	StringTrimLeft, i_now_active, A_ThisHotkey, 1
	#desk_show(i_now_active)
	KeyWait, lwin
	KeyWait, % i_now_active
return

#put_to_group:
	StringRight, i_now_put, A_ThisHotkey, 1
	if (i_now_put = i_exdesktop)
		goto, #nothing_do
	MouseGetPos, , , this_id
	(@ls_all_wins[i_now_put]).push("ahk_id " this_id)
	WinHide, % "ahk_id " this_id
	#nothing_do:
		KeyWait, LWin
		KeyWait, Numpad%i_now_put%
		KeyWait, % i_now_put
return


#desk_show(i_active) {					;显示该窗口
	if (i_active = i_exdesktop)			;没有切换窗口
		return
	#putactive_winid_to_group(i_exdesktop)
	for i, v in @ls_all_wins
		(i_active = i) ? #ls_win_show(v, 1) : #ls_win_show(v, 0)
	i_exdesktop := i_active
}
#ls_win_show(ls_ls, b_show:= 1) {		;激活或隐藏列表中的窗口
	if b_show
		for i, v in ls_ls
			WinShow, % v
	else
		for i, v in ls_ls
			WinHide, % v
}

#putactive_winid_to_group(i_group) {	;将存在的窗口放入组中
	@ls_all_wins[i_group] := []
	winget, winls, List
	Loop, % winls
		(@ls_all_wins[i_group]).push("ahk_id " winls%A_Index%)
}