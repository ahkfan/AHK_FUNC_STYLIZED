#SingleInstance Force
#NoEnv
#InstallKeybdHook
#InstallMouseHook
#Persistent
SetDefaultMouseSpeed,0

;~ 参2为字典 : 键为击键次数, 值为函数对象
KeyCounts2Func.add("$``", {1: func("sendTheKey", 2: func("runScript")}))

Return

sendTheKey()
{
	send, ``
}

runScript()
{
	static a := 0
	ToolTip, % a += 1
}

class KeyCounts2Func {
	static period := -300
	static dict := {}
	add(key, count2funcDict) {
		KeyCounts2Func["dict"][key] := [0, count2funcDict]
		Hotkey, % key, OnKeyDownEvent1
		return
		OnKeyDownEvent1:
			KeyCounts2Func["dict"][A_ThisHotkey][1] += 1
			SetTimer, OnKeyDownTimeout1, % KeyCounts2Func.period
		return

		OnKeyDownTimeout1:
			obj := KeyCounts2Func["dict"][A_ThisHotkey]
			obj[2][obj[1]]()
			obj[1] := 0
		return
	}
}

class KeyCounts2Label {
	static period := -300
	static dict := {}
	add(key, count2LabelDict) {
		KeyCounts2Label["dict"][key] := [0, count2LabelDict]
		Hotkey, % key, OnKeyDownEvent2
		return
		OnKeyDownEvent2:
			KeyCounts2Label["dict"][A_ThisHotkey][1] += 1
			SetTimer, OnKeyDownTimeout2, % KeyCounts2Label.period
		return

		OnKeyDownTimeout2:
			obj := KeyCounts2Label["dict"][A_ThisHotkey]
			lb := obj[2][obj[1]]
			if islabel(lb)
				gosub, % lb
			obj[1] := 0
		return
	}
}

/*
OnKeyDown(key, arrEvent, nTimeout := 200){
	nKeyDownCount[key] := 0
	arrKeyDownEvents[key] := arrEvent
	Hotkey, %key%, OnKeyDownEvent
	Return
OnKeyDownEvent:
	; If (A_PriorHotkey != A_ThisHotkey)
	; 	Return
	nKeyDownCount[A_ThisHotkey] := nKeyDownCount[A_ThisHotkey] + 1
	SetTimer, OnKeyDownTimeout, -300
	Return
OnKeyDownTimeout:
	; global arrKeyDownEvents
	; global nKeyDownCount
	nIdx := nKeyDownCount[A_ThisHotkey] > arrKeyDownEvents.MaxIndex() ?  nKeyDownCount[A_ThisHotkey] : arrKeyDownEvents.MaxIndex()
	lbl := arrKeyDownEvents[A_ThisHotkey][nIdx]
	if IsLabel(lbl)
		GoSub %lbl%
	; Clipboard := nIdx "`t" lbl "`n" A_ThisHotkey "`t nKeyDownCount = " nKeyDownCount[A_ThisHotkey] ", arrKeyDownEvents.MaxIndex() = " arrKeyDownEvents[A_ThisHotkey].MaxIndex()
	nKeyDownCount[A_ThisHotkey] := 0
	Return
}



LShiftClick:
LCtrlClick:
LCtrlDoubleClick:
LCtrlTripleClick:
; Clipboard := A_ThisLabel
	Return
LShiftDoubleClick:
ToggleTotalCommander:
	DetectHiddenWindows, on
	IfWinNotExist ahk_class TTOTAL_CMD
		Run Z:\Totalcmd\TOTALCMD.EXE
	Else IfWinNotActive ahk_class TTOTAL_CMD
		WinActivate
	Else
		WinMinimize
	Return
~Pause::
$~#ScrollLock::
	Suspend
	Return
$~#Esc::
	WinGetActiveTitle, OutputVar
	If InStr(OutputVar, A_ScriptName)
		Reload
	Return
$~#^Esc::
!q::
	ExitApp
	Return
*/