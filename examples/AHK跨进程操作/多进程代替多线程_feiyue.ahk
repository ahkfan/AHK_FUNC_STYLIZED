;===========================================
;  【多进程代替多线程函数】 Exec()  By FeiYue
;
;   使用说明：
;   1、启动进程：Exec(代码，进程标记)
;   2、停止进程：Exec(""，进程标记)
;   3、进程标记相同，后启动的进程会替换先启动的进程
;   4、主脚本退出时，主脚本启动的所有进程都会被清理
;
;===========================================
;======== 下面是使用的例子 ========

;-- 这是一行的写法

/*
F1::Exec("Loop{`nSleep,100`nMouseGetPos,x,y`nToolTip,F1-%A_Index%,x+10,y-30`n}",1)

;-- 这是多行的写法，括号中可以原样粘贴要运行的代码

F2::
s=
(` %
  Loop {
    Sleep, 100
    MouseGetPos, x, y
    ToolTip, F2-%A_Index%, x+10, y+10
  }
)
;-- 使用开关变量来一键切换启动和停止
(ok:=!ok) ? Exec(s,2) : Exec("",2)
return

;-- 清理进程

F3::Exec("",1), Exec("",2)

*/


Exec(s, flag="Default")  ; By FeiYue
{
  static init
  if (!init)
  {
    init=1
    ss=
    (%
    DetectHiddenWindows, On
    RegExMatch(flag, "<<(.*?)>>", r)
    WinWaitClose, ahk_pid %r1%
    WinGet, list, List, %r% ahk_class AutoHotkeyGUI
    Loop, % list {
      IfEqual, myid, % id:=list%A_Index%, Continue
      WinGet, pid, PID, ahk_id %id%
      WinClose, ahk_pid %pid% ahk_class AutoHotkey
      WinWaitClose, ahk_pid %pid%,, 3
      if ErrorLevel
        Process, Close, %pid%
    }
    )
    Exec(ss, "AutoClear")
  }
  pid:=DllCall("GetCurrentProcessId")
  add=`nflag=<<%pid%>>[%flag%]`n
  (%
    #NoEnv
    #NoTrayIcon
    DetectHiddenWindows, On
    Gui, Gui_Flag_Gui: Show, Hide, %flag%
    Gui, Gui_Flag_Gui: +Hwndmyid
    WinGet, list, List, %flag% ahk_class AutoHotkeyGUI
    Loop, % list {
      IfEqual, myid, % id:=list%A_Index%, Continue
      WinGet, pid, PID, ahk_id %id%
      WinClose, ahk_pid %pid% ahk_class AutoHotkey
      WinWaitClose, ahk_pid %pid%
    }
    DetectHiddenWindows, Off
  )
  s:=add "`n" s "`nExitApp`n#SingleInstance off`n"
  s:=RegExReplace(s, "\R", "`r`n")
  ;-----------------------------------
  shell:=ComObjCreate("WScript.Shell")
  exec:=shell.Exec(A_AhkPath " /ErrorStdOut *")
  exec.StdIn.Write(s)
  exec.StdIn.Close()
}

