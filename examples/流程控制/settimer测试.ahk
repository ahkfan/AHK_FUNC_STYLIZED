/*#

SingleInstance force
#Persistent


;-------------------------------------------------
;~ 例1: 代码执行期间运行一次label标签不影响多线程执行, 即循环中标签可插入运行
Loop 
{
	if (A_Index = 1)
	{
		SetTimer, label1, -100
	}
}
return

label1:
	MsgBox, label1弹窗
return

;-------------------------------------------------
;~ 例2: 而下方这个循环label似乎永远不会执行, 下一次运行时间被无数次刷新
Loop 
{
	SetTimer, label1, -100
}
return

label2:
	MsgBox, label2弹窗
return

;-------------------------------------------------
;~ 例3: 定时语法也将在延迟1000毫秒后初次执行

SetTimer, label3, 1000
t := A_TickCount
return

label3:
	ToolTip % "当前距离上次运行间隔: " (A_TickCount - t)  "毫秒"
	t := A_TickCount
return

;-------------------------------------------------
;~ 例4: 若标签的代码段 执行时间 超过计时器间隔, 下一次执行是即时的(不作等待), 包括msgbox, wait系列的命令同理


settimer, label4, 1000
return

label4:
	a := 0
	Loop, 300
	{
		a += 1
		sleep, 10
		ToolTip, % a
	}
return

;-------------------------------------------------
;~ 例5: 接例4, 以下这种方法可以保证的执行周期, 以标签完结时开始计时

SetTimer, label5, -1000
t := A_TickCount
return

label5:
	msgbox, % "距离上次标签执行经过了: " (A_TickCount - t)
	t := A_TickCount
	SetTimer, label5, -1000
return

;-------------------------------------------------
;~ 例6: 标签执行效率是很低的

;~ 6.1 示例
SetBatchLines, -1
t := A_Tickcount
a := 0
Loop {
	;Sleep 1	;~ 去掉sleep前注释运行频率将近似于settimer
	a += 1
	if (a >= 100) {
		MsgBox, % "经过: " (A_Tickcount - t) " 毫秒结束100次循环"
		break
	}
}
return

;~ 6.2 示例
SetBatchLines, -1
t := A_Tickcount
a := 0
SetTimer, label6, 1
return

label6:
	a += 1
	if (a >= 100) {
		MsgBox, % "经过: " (A_Tickcount - t) " 毫秒结束100次循环"
		SetTimer, label6, off
	}
return

*/