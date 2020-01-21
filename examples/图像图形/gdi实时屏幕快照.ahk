#SingleInstance force
;~ 按下esc退出
exitHotkey := "esc"

;~ 显示尺寸
finalW := 500
finalH := 300

;~ 放大倍数
zoom := 3

;~ 最高帧率
maxFps := 100
maxTm := floor(1000 / maxFps)

SetBatchLines, 20
SetMouseDelay, -1
SetWinDelay, -1
CoordMode, mouse, screen

Gui, +hwnd@hwnd -caption -sysmenu +AlwaysOnTop
Gui, show, x0 y0 w%finalW% h%finalH%

hdcScreen := createScreenDC()
hdcMem	  := mkMemDcFrom(hdcScreen)
hdcGui	  := getDcFrom(@hwnd)
w := getDcW(hdcScreen)
h := getDcH(hdcScreen)
hBmp	:= createBmpFromDC(hdcScreen, w, h)

hBmpOld := setDcGdiObj(hdcMem, hBmp)

tm := A_TickCount
tm2 := A_TickCount
frame := 0

loop {	;~ 此处绘图





	sub := A_Tickcount - tm
	if (sub >= 1000) {
		ToolTip, % "帧率: " frame " fps"
		tm := A_Tickcount
		frame := 0
	}

	;~ 使屏幕的DC 部分内容放大拷贝到内存DC
	sub2 := A_Tickcount - tm2
	if (sub2 >= maxTm) {

		cPos := mouseGetCapPos(zoom, finalW, finalH)

		;~ 将屏幕写入内存
		copyDc2Dc2(hdcScreen, cPos.x, cPos.y, cPos.w,  cPos.h, hdcMem, 0, 0, finalW, finalH)

		;~ 将内存写入窗口
		copyDc2Dc2(hdcMem, 0, 0, finalW, finalH, hdcGui, 0, 0, finalW, finalH)

		setDcGdiObj(hdcMem, hBmpOld)
		;~ 测试帧率
		tm2 := A_Tickcount
		frame += 1
	}
	;MsgBox, % A_TickCount - tm

} until getkeystate(exitHotkey, "p")



deleteGdiObject(hBmp)

DeleteDC(hdcScreen)
DeleteDC(hdcMem)
releaseDc(hwnd, hdcGui)

ExitApp
return


mouseGetCapPos(scale, finalW, finalH) {
	MouseGetPos, mx, my
	w := floor(finalW / scale)
	h := floor(finalH / scale)
	x := mx - floor(w / 2)
	y := my - floor(h / 2)
	return {"x": x, "y": y, "w": w, "h": h}
}

;---------------------------
;~ 从目标DC创建内存快照
mkMemDcFrom(srcDC) {
	return DllCall("CreateCompatibleDC", "Ptr", srcDC)
}

;---------------------------
;~ 获取屏幕DC, 与delete对应
createScreenDC() {
	return Dllcall("CreateDCW"
					, "Str", "DISPLAY"
					, "Str", ""
					, "Str", ""
					, "Ptr", ""
					, "UInt")
}

;---------------------------
;~ 释放由create创建的DC
DeleteDC(hdc) {
	DllCall("DeleteDC", "ptr", hdc)
}

;---------------------------
;~ 获取对应窗口DC, 与release对应
getDcFrom(hwnd) {
	return Dllcall("GetDC", "ptr", hwnd, "Ptr")
}

;---------------------------
;~ 释放窗口DC
releaseDc(hwnd, hdc) {
	return Dllcall("ReleaseDC", "ptr", hwnd, "ptr", hdc)
}

;---------------------------
;~ 拷贝DC内容到另一个DC
copyDc2Dc(hdcFrom, fromX, fromY, hdcTo, x, y, w, h) {
	DllCall("BitBlt", "Ptr", hdcTo
					, "int", x
					, "int", y
					, "int", w
					, "int", h
					, "Ptr", hdcFrom
					, "int", fromX
					, "int", fromY
					, "uint", 0xcc0020)
}

;---------------------------
;~ 拷贝DC内容到另一个DC, 拉伸
copyDc2Dc2(hdcFrom, fX, fY, fW, fH, hdcTo, x, y, w, h) {
	DllCall("StretchBlt", "Ptr", hdcTo
					, "int", x
					, "int", y
					, "int", w
					, "int", h
					, "Ptr", hdcFrom
					, "int", fX
					, "int", fY
					, "int", fW
					, "int", fH
					, "uint", 0xcc0020)
}

;---------------------------
;~ 创建与目标DC兼容的位图
createBmpFromDC(hdc, w, h) {
	return dllcall("CreateCompatibleBitmap", "Ptr", hdc, "Int", w, "Int", h, "Ptr")
}

;---------------------------
;~ 删除Gdi对象
deleteGdiObject(hGdiObj) {
	return dllcall("DeleteObject", "ptr", hGdiObj)
}

;---------------------------
;~ 设置Dc的Gdi对象, 返回旧对象
setDcGdiObj(hdc, hGdiObject) {
	return Dllcall("SelectObject", "Ptr", hdc, "Ptr", hGdiObject, "Ptr", hGdiObjectOld, "Ptr")
}

;---------------------------
;~ 获取Dc宽度
getDcW(hdc) {
	return DllCall("GetDeviceCaps", "ptr", hdc, "Int", 8, "Int")
}

;---------------------------
;~ 获取Dc高度
getDcH(hdc) {
	return DllCall("GetDeviceCaps", "ptr", hdc, "Int", 10, "Int")
}