/*
	某键
	长按时连续输出
	松开时不再继续输出
*/


#InstallMouseHook
SetKeyDelay, -1, -1
return

Insert::
	thisk := "Insert"
	loop {
		send_keystate(thisk, "t")
		send_keystate(thisk, "y")
		send_keystate(thisk, "u")
	} until not getkeystate(thisk, "p")
return

send_keystate(s_keyname, s_send_key, i_downdelay := 0, i_updelay := 0)
{
	if (GetKeyState(s_keyname, "p")) {
		Send, % "{" s_send_key " down}"
		Sleep, % i_downdelay
		Send, % "{" s_send_key " up}"
		Sleep, % i_updelay
	}
}
