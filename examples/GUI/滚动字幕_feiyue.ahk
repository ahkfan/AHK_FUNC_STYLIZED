
;------------------------------
; 显示透明文字函数：TransTip()  By FeiYue
; s参数为空，会清除当前的显示，最后四个参数设定显示位置范围
; font参数是Gui的Font命令格式，可以设定字体大小、颜色和样式
;------------------------------

TransTip(s="", font="s36 cRed bold", x=500, y=0, w=800, h=600)
{
  static last_args, last_id
  if (s="")
  {
    last_args:=""
    Gui, TransTip: Destroy
    return
  }
  if (last_args!=font "|" x "|" y "|" w "|" h)
  {
    last_args:=font "|" x "|" y "|" w "|" h
    x:=Round(x), y:=Round(y), w:=Round(w), h:=Round(h)
    Gui, TransTip: Destroy
    Gui, TransTip: +AlwaysOnTop -Caption +ToolWindow +E0x08000020
    Gui, TransTip: Margin, 0, 0
    Gui, TransTip: Color, EEAA99
    Gui, TransTip: Font, Q3 %font%
    Gui, TransTip: Add, Text, -Wrap w%w% h%h%
    ;------------------
    last_id:=WinExist()
    Gui, TransTip: +LastFound
    WinSet, TransColor, EEAA99 150
    WinExist("ahk_id " . last_id)
    ;------------------
    Gui, TransTip: Show, NA x%x% y%y%
  }
  Gui, TransTip: +AlwaysOnTop
  GuiControl, TransTip:, Static1, %s%
}

;-- 滚动显示信息的例子

txt:="今天是：" A_YYYY "年" A_MM "月" A_DD "日，" A_DDDD " - "
len:=StrLen(txt)
Loop {
	if not mod(A_index, 100000) {
		i:=Mod(A_Index-1,len)+1
		s:=SubStr(txt,i) . SubStr(txt,1,i-1)
		TransTip(s, "s36 cBlue bold")
	}
}
return

Pause::Pause

F1:: (ok:=!ok) ? TransTip("你好！","s72"):TransTip()

