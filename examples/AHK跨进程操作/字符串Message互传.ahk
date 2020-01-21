/* example
;  接收方 单独文件 ====================================================================
Gui, show, w100 h100, this_title	;设定窗口标题
OnMessage(0x4a, "#msg_str_get")		;此为关键函数
SetTimer, #showchangge, 100			;即时显示窗口信息
return

#showchangge:
ToolTip, % #rts_laststr()
return

; 发送方 独立文件 ====================================================================

a := 0
return

#space:: 					 ; Win+Space 热键
	发送的消息 := A_ThisHotkey . (a += 1)
	要发送的窗口 := "this_title"
	#sendmsg_win(要发送的窗口, 发送的消息)    ;返回值1成功交接数据, 0为未收到回馈, "FAIL"为窗口不存在
return

*/


#sendmsg_win(s_title, ByRef 字符串变量, i_timeout := 4000) { ; 此函数发送指定的字符串到指定的窗口然后返回收到的回复.   ; 如果目标窗口处理了消息则回复为 1, 而消息被忽略了则为 0.
   ;参1:str标题, 参2:str要发送的消息, 参3:int最长等待时间,毫秒时间
    ;返回值: 1 对方成功接收 0失败	FAIL 窗口不存在
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)                  ; 分配结构的内存区域.
    SizeInBytes := (StrLen(字符串变量) + 1) * (A_IsUnicode ? 2 : 1)  ; 首先设置结构的 cbData 成员为字符串的大小, 包括它的零终止符(字符串长度 + 1终止符):
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)                  ; 操作系统要求这个需要完成.
    NumPut(&字符串变量, CopyDataStruct, 2*A_PtrSize)                 ; 设置 lpData 为到字符串自身的指针.
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On                              ; 搜索包括隐藏窗口
    SetTitleMatchMode 2                                 ; 某个位置包含标题才能匹配
    SendMessage , 0x4a, 0, &CopyDataStruct,, %s_title%,,,, % i_timeout  ; 0x4a 为 WM_COPYDAT
    DetectHiddenWindows, %Prev_DetectHiddenWindows%     ; 恢复调用者原来的设置.
    SetTitleMatchMode, %Prev_TitleMatchMode%            ; 同样.
    return ErrorLevel                                   ; 返回 SendMessage 的回复给我们的调用者.
}

; 接收方 ====================================================================
#msg_str_get(wParam, lParam) {  	;接受消息函数
    #rts_laststr(StrGet(NumGet(lParam + 2*A_PtrSize)))   ; 从结构中复制字符串
    return true                                         ; 返回 1 (true) 是回复此消息的传统方式, 可以返回其他数值
}
#rts_laststr(b_returen := "") {   	;参数为空时返回最后一次接受到的消息
    static s_lastgot := ""
    if (b_returen = "")
        return s_lastgot
    else
       s_lastgot := b_returen
}
