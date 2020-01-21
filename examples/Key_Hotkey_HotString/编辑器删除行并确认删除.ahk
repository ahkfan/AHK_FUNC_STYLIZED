/* 需求:
完全删除一整行,并返回上一行的末尾
*/

SetKeyDelay, -1, -1
f1::
	loop 3
	{
		Send, {end}+{home}
		Clipboard := ""
		send, +{home}^c
		ClipWait, 0.2
		Send, {backspace}
		if (ErrorLevel)
			break
	}
return
