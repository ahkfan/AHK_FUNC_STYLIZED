#MaxHotkeysPerInterval 200
#SingleInstance force
THEKEY := "space"
WAITAP := 501	;判断期限内
onclickspaceS := 20	;space连续输出就间隔
return

$space::
nowtaptime := [A_Now, A_MSec]
onFunc := 1
loop { 
	taptimeP := NMsecSubt([A_Now, A_MSec], nowtaptime) 
	StringTrimLeft, THISKEY, A_ThisHotkey, 1	
	;ToolTip,  %  taptimeP          
	if not GetKeyState("SPACE", "p") 
	{	;当短击判定达成时
		break
	}
	if  (taptimeP >= WAITAP) {
		;按键超时   
		onFunc := 0
		break
	}
	if (THISKEY != THEKEY)
	{	;当功能键启用时
		onfunc2 := 1
		keywait, space
		onFunc := 0
		return
	}
}
onFunc := 0 
if (taptimeP >= WAITAP)
{
	loop {
		Send, {space down}
		Sleep, % onclickspaceS
		Send, {space Up}
		if  not getkeystate("space", "p")
			break		
	}
}  
return

space Up::
	onFunc := 0
	;if  ((taptimeP <   WAITAP)  && (! onfunc2) && (!winac))
	if  ((taptimeP <   WAITAP)  && (! onfunc2) )
	{
		;ToolTip, % taptimeP "`n" WAITAP
		Send, {space down}
		Sleep, % onclickspaceS
		Send, {space Up}
	}
	onfunc2 := 0
	winac := 0
	return

 /*
~Lwin::
	;解决输入法切换问题
	winac := 1
	return
*/
NMsecSubt(tmlsA, tmlsB) {	;计算两时间点列表值的差,单位毫秒
	subSVar := tmlsA[1]
	subSVar -= tmlsB[1], s	;两数相减的秒数
	if (subVar != 0) 
		return % subSVar * 1000 + (tmlsA[2] - tmlsB[2])
	else
		return % tmlsA[2] - tmlsB[2]
}
 
#If (onFunc)
q::LButton
w::RButton
e::Home
r::End
s::up
x::Down
d::Left
f::right
/*
* 原有映射表 
1::F1
2::F2
3::F3
4::F4
5::F5
6::F6
7::F7
8::F8
9::F9
0::F10
-::F11
=::F12
q::RButton
e::LButton
u::Home
i::Up
o::End
j::Left
k::Down
l::Right
,::Volume_Down
.::Volume_Up
*/