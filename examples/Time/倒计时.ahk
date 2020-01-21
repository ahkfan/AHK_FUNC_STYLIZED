年 = 2019
月 = 10
日 = 12
时 = 19
分 = 50
秒 = 00
结束时间 := 年 月 日 时 分 秒

loop {
   余秒 := tm_sub_now(结束时间)

   tooltip, % "距离结束时间还有 "  余秒  " 秒"
} until (余秒 <= 0)

;~ 到点的操作写在下面

MsgBox, 时间到

return

;~ 用当前时间戳减去time时间戳，返回单位默认秒
tm_sub_by_now(time, tm := "s") {
   ret := A_Now
   ret -= time, %tm%
   return ret
}

;~ 用time时间戳减去当前时间戳，返回单位默认秒
tm_sub_now(time, tm := "s") {
   time -= A_Now, %tm%
   return time
}

;~ 计算之后的时间戳
tm_after(afterTime, time := "", tm:= "s") {
   ret := (time = "") ? A_Now : time
   ret += afterTime, %tm%
   return ret
}

;~ 计算之前的时间戳
tm_before(beforeTime, time := "", tm:="s") {
   ret := (time = "") ? A_Now : time
   ret += -beforeTime, %tm%
   return ret
}
