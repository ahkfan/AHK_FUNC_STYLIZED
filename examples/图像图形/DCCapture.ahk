SetBatchLines, -1
Gui, +hwnd@main
gui, show, % "w" (A_ScreenWidth // 2) " h" (A_ScreenHeight // 2)
ControlGetPos, , , fW, fH, , % "ahk_id " @main

hwnd_frame_view := @main
hdcGui := getDcFrom(hwnd_frame_view)
;hDcc := getDcFrom(198876)

hdc := dllcall("GetDC", "ptr", 0, "ptr")	; // get the desktop device context
;hDest := dllcall("CreateCompatibleDC", "ptr", hdc, "ptr")

;hBDesktop := dllcall("CreateCompatibleBitmap", "ptr", hdc, "int", A_ScreenWidth, "int", A_ScreenHeight, "ptr")
;hBmpOld := setDcGdiObj(hDest, hBDesktop)
;
a := A_TickCount
b := 0
Loop
{
	;copyDc2Dc2(hdc, 0, 0, A_ScreenWidth, A_ScreenHeight, hDest, 0, 0, A_ScreenWidth, A_ScreenHeight)
copyDc2Dc2(hdc, 0, 0, 960,540, hdcGui, 0, 0, 960,540)
b += 1
if (A_Tickcount - a >= 1000)
{
	ToolTip, % b
	a := A_TickCount, b := 0

}


}
dllcall("ReleaseDC", "ptr", 0, "ptr", hdc)

dllcall("DeleteDC", "ptr", hDest)

MsgBox, % hdc
return
;---------------------------
;~ 设置Dc的Gdi对象, 返回旧对象
setDcGdiObj(hdc, hGdiObject) {
	return Dllcall("SelectObject", "Ptr", hdc, "Ptr", hGdiObject, "Ptr", hGdiObjectOld, "Int")
}
;---------------------------
;~ 获取对应窗口DC, 与release对应
getDcFrom(hwnd) {
	return Dllcall("GetDC", "ptr", hwnd, "Ptr")
}
;---------------------------
;~ 拷贝DC内容到另一个DC, 未设定返回值
copyDc2Dc(hdcFrom, fromX, fromY, hdcTo, x, y, w, h) {
	DllCall("BitBlt", "Ptr", hdcTo, "int", x, "int", y, "int", w, "int", h, "Ptr", hdcFrom, "int", fromX, "int", fromY, "uint", 0xcc0020)
}
;---------------------------
;~ 拷贝DC内容到另一个DC, 拉伸, 未设定返回值
copyDc2Dc2(hdcFrom, fX, fY, fW, fH, hdcTo, x, y, w, h) {
	DllCall("StretchBlt", "Ptr", hdcTo, "int", x, "int", y, "int", w, "int", h, "Ptr", hdcFrom, "int", fX, "int", fY, "int", fW, "int", fH, "uint", 0xcc0020)
}


/*

// get the height and width of the screen
int height = GetSystemMetrics(SM_CYVIRTUALSCREEN);
int width = GetSystemMetrics(SM_CXVIRTUALSCREEN);

// create a bitmap
HBITMAP hbDesktop = CreateCompatibleBitmap( hdc, width, height);

// use the previously created device context with the bitmap
SelectObject(hDest, hbDesktop);

// copy from the desktop device context to the bitmap device context
// call this once per 'frame'
BitBlt(hDest, 0,0, width, height, hdc, 0, 0, SRCCOPY);

// after the recording is done, release the desktop context you got..
ReleaseDC(NULL, hdc);

// ..delete the bitmap you were using to capture frames..
DeleteObject(hbDesktop);

// ..and delete the context you created
DeleteDC(hDest);
*/