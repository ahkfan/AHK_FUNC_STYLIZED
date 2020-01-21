/*
; 原代码, 来自 设之讯 由网络获取 C 语言示例
gui,+hwndhwnd
gui,add,text,C839496,%A_TickCount%
gui,show,W250 H190 X10 Y610

F1::
backgroundcolor:=0x002B36
backgroundcolor:=(((backgroundcolor & 255) << 16) + (((backgroundcolor >> 8) & 255) << 8) + (backgroundcolor >> 16))
Brush:=dllcall("CreateSolidBrush","UInt",backgroundcolor,"UInt")
DllCall("SetClassLong","Ptr",hwnd,"int",-10,"int",Brush)
DllCall("InvalidateRect","Ptr",hwnd,"Ptr",0,"Int",1)
DllCall("UpdateWindow","Ptr",hwnd)
return
*/


gui,+hwndhwnd
gui,add,text,C839496,%A_TickCount%
w := 250
h := 190
gui,show,W%w% H%h% X10 Y610

backgroundcolor:=0xff2B36
return


F1::
hdcGuiColor := getDcFrom(hwnd)
hBrush := DllCall("CreateSolidBrush", "Uint", transRGB(backgroundcolor), "Uint")
hBrushEx := setDcGdiObj(hdcGuiColor, hBrush)
Dllcall("Rectangle", "Ptr", hdcGuiColor, "Int", 0, "Int", 0, "Int", w, "Int", h, "UInt")
setDcGdiObj(hdcGuiColor, hBrushEx)
dllcall("DeleteObject", "ptr", hBrush)
releaseDc(hwnd, hdcGuiColor)
return

releaseDc(hwnd, hdc) {
	return Dllcall("ReleaseDC", "ptr", hwnd, "ptr", hdc)
}
getDcFrom(hwnd) {
	return Dllcall("GetDC", "ptr", hwnd, "Ptr")
}
setDcGdiObj(hdc, hGdiObject) {
	return Dllcall("SelectObject", "Ptr", hdc, "Ptr", hGdiObject, "Ptr", hGdiObjectOld, "Int")
}

transRGB(color, retHex := true) {
	return retHex ? format("0x{1:x}",((color & 0xff) << 16) + ((color >> 8 & 0xff) << 8) + (color >> 16 & 0xff)) : ((color & 0xff) << 16) + ((color >> 8 & 0xff) << 8) + (color >> 16 & 0xff)
}
