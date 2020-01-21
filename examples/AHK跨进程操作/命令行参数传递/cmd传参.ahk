/* 此方法仅适用于启用时的一次性传递参数

RunSendCMD(runScriptPath, argsLs*)
	;~ 参1: 启动子脚本的路径
	;~ 参2: 为动态参数, 参数间不可带有空格
	;~ 返回值: 启动子脚本的pid
*/
Loop, 2
	itPid :=  RunSendCMD(A_ScriptDir "\cmd传参_sub.ahk", A_Index)
return


RunSendCMD(runScriptPath, argsLs*) {
	for i, Msg in argsLs
		toSubMsgs .= " " . Msg
	Run,  % A_AhkPath " /f " runScriptPath . toSubMsgs, , , theScriptPid
	return theScriptPid
}

