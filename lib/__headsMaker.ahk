/*
我觉得这个可以不传上来

;~ 该脚本用于批量创建文件

a =
(
dbg	- 调试
ahk	- 脚本进程
conf	- 脚本全局设定
os	- 系统与文件
prog	- 进程
sound	- 声音
gui	- GUI窗体
guiop	- GUI控件
ini	- ini配置文件
key	- 键
m	- 鼠标
win	- 窗口
winop	- 窗口控件
pixel	- 图色
str	- 字符串
rand	- 随机
time	- 时间
)


loop, parse, a, `n, `r
{
	if not RegExMatch(A_LoopField, "^\s*$")
	{
		s := RegExReplace(A_LoopField, "\s*")
		ls := StrSplit(s, "-")
		;MsgBox, % "(" ls[1] ")(" ls[2] ")"
		FileAppend, % ";~" ls[2], % ls[1] ".ahk", utf-8
	}
}
*/

