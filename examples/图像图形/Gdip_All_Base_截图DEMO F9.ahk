#Include Gdip_All.ahk

OnExit, scExitApp
SetWorkingDir %A_ScriptDir%

If (!pToken:=Gdip_Startup()) {
	msgbox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}

^1::ScreenCapture(, 1, , "Clipboard")	; 带光标 保存至剪切板
; F9::ScreenCapture(, 0, , "Clipboard")	; 不带光标 保存至剪切板
; F9::ScreenCapture(, 1, , A_Desktop "\111.png")	; 不带光标 保存至桌面 \111.png
; F9::ScreenCapture(100 "|" 100 "|" 500 "|" 500, 1, , "111.png")		; x0=y0=100 w=h=500
; F9::Msgbox % ScreenCapture(,1, , "Bitmap").Bitmap		; 返回位图句柄
; F9::Msgbox % ScreenCapture(,1, , "Stream").Stream		; 保存成流
; F9::Msgbox % ScreenCaptureBox(0)		; 截图时动态显示，返回位图句柄
; F9::Msgbox % ScreenCapture(,1, 75, "Bitmap", "Clipboard", "111.bmp").Bitmap


F10::
Gdip_Shutdown(pToken)
Reload

scExitApp:
Gdip_Shutdown(pToken)
ExitApp


; =============================================================================================================
; =============================================================================================================
; =============================================================================================================

Gdip_SaveImageToStream(pBitmap, Extension:="PNG", Quality:=75){
	nCount:=0, nSize:=0, _p:=0, Ptr:=A_PtrSize ? "UPtr" : "UInt"
	If !RegExMatch(Extension, "^(?i:BMP|DIB|RLE|JPG|JPEG|JPE|JFIf|GIf|TIf|TIfF|PNG)$")
		Return -1

	Extension:="." Extension
	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, Ptr, &ci)
	If !(nCount && nSize)
		Return -2

	If (A_IsUnicode){
		StrGet_Name:="StrGet"
		N:=(A_AhkVersion < 2) ? nCount : "nCount"
		Loop %N%
		{
			sString:=%StrGet_Name%(NumGet(ci, (idx:=(48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
			If !InStr(sString, "*" Extension)
				continue
			pCodec:=&ci+idx
			break
		}
	} Else {
		N:=(A_AhkVersion < 2) ? nCount : "nCount"
		Loop %N%
		{
			Location:=NumGet(ci, 76*(A_Index-1)+44)
			nSize:=DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			VarSetCapacity(sString, nSize)
			DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
			If !InStr(sString, "*" Extension)
				continue
			pCodec:=&ci+76*(A_Index-1)
			break
		}
	}
	If !pCodec
		Return -3

	If (Quality !=75)
	{
		Quality:=(Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		If RegExMatch(Extension, "^\.(?i:JPG|JPEG|JPE|JFIf)$")
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, "uint", nSize, Ptr, &EncoderParameters)
			nCount:=NumGet(EncoderParameters, "UInt")
			N:=(A_AhkVersion < 2) ? nCount : "nCount"
			Loop %N%
			{
				elem:=(24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad:=A_PtrSize=8 ? 4 : 0)
				If (NumGet(EncoderParameters, elem+16, "UInt")=1) && (NumGet(EncoderParameters, elem+20, "UInt")=6)
				{
					_p:=elem+&EncoderParameters-pad-4
					NumPut(Quality, NumGet(NumPut(4, NumPut(1, _p+0)+20, "UInt")), "UInt")
					break
				}
			}
		}
	}
	DllCall("ole32\CreateStreamOnHGlobal", Ptr, 0, "int", 1, "ptr*", pStream)
	DllCall("gdiplus\GdipSaveImageToStream", Ptr, pBitmap, Ptr, pStream, Ptr, pCodec, "uint", _p ? _p : 0)
	DllCall("DeleteObject", Ptr, pBitmap)
	Return pStream
}

ScreenCaptureBox(Options = 0){
	local
	; cur_jt:=DllCall("LoadImage","Uint", 0, "Str", A_ScriptDir "\cur_jt.cur", "Uint", 2, "int", 0, "int", 0, "Uint", 0x50)
	c_cursor:=StrSplit("32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650,32651", ",")
	CoordMode, ToolTip, Screen
	CoordMode, Pixel, Screen
	CoordMode, Mouse, Screen
	x0:=DllCall("GetSystemMetrics", "Int", 76), y0:=DllCall("GetSystemMetrics", "Int", 77)
	Width:=DllCall("GetSystemMetrics", "Int", 78), Height:=DllCall("GetSystemMetrics", "Int", 79)
	TopLeftX:=x0, TopLeftY:=y0, XWidth:=Width, YHeight:=Height
	, MypBitmap:=0, movespeed:=1, bCursor:=Options & 1, dynamic:=Options >> 1 & 1

	If dynamic {
		MypBitmap:=ScreenCapture(x0 "|" y0 "|" Width "|" Height, bCursor, , "Bitmap").Bitmap
		MyhBitmap:=Gdip_CreateHBITMAPFromBitmap(MypBitmap)
		staichdc:=CreateCompatibleDC(), staicobm:=SelectObject(staichdc, MyhBitmap)
	}
	;Generate the GDI+
	Gui, mengban: +LastFound -Caption +AlwaysOnTop +ToolWindow +hwndhwnd1 +E0x00080000
	Gui, mengban: Show, NA
	WinSet, ExStyle, +0x20
	Hotkey, LButton, invalid, on
	Hotkey, RButton, invalid, on
	Hotkey, Up, micromove, on
	Hotkey, Down, micromove, on
	Hotkey, Left, micromove, on
	Hotkey, Right, micromove, on
	Loop % c_cursor.Length()
		DllCall( "SetSystemCursor", "Ptr", DllCall("CopyImage", "Ptr", DllCall("LoadCursor", "Ptr",0, "Ptr",c_cursor[4]), "UInt",2, "Int",0, "Int",0, "UInt",0), "UInt",c_cursor[A_Index])

	pPen:=Gdip_CreatePen(0xff00aeff, 2), pPenszx:=Gdip_CreatePen(0xff00aeff, 1)
	pBrush:=Gdip_BrushCreateSolid(0x8f000000), pPenbk:=Gdip_CreatePen(0xff000000, 1)

	while (GetKeyState("LButton", "P") = 0)
	{
		MouseGetPos, NewMX, NewMY, VarWin
		WinGetPos, TopLeftX, TopLeftY, XWidth, YHeight, ahk_id%VarWin%
		VarSetCapacity(Rect, 16, 0)
		DllCall("GetClientRect","Uint",VarWin,"Ptr",&Rect)
		DllCall("ClientToScreen","Uint",VarWin,"Ptr",&Rect)
		tempy:=NumGet(Rect, 4, "Uint"), tempy:=tempy>0x7FFFFFFF?-~tempy:tempy
		TopLeftX:=NumGet(Rect, 0, "Uint"), TopLeftX:=TopLeftX>0x7FFFFFFF?-~TopLeftX:TopLeftX
		RightBottomX:=TopLeftX+NumGet(Rect, 8, "Uint"), RightBottomY:=tempy+NumGet(Rect, 12, "Uint")
		TopLeftX:=TopLeftX<x0?x0:TopLeftX, TopLeftY:=TopLeftY<y0?y0:TopLeftY
		RightBottomX:=RightBottomX>x0+Width?x0+Width:RightBottomX, RightBottomY:=RightBottomY>y0+Height?y0+Height:RightBottomY
		XWidth:=RightBottomX-TopLeftX, YHeight:=RightBottomY-TopLeftY
		If !((NewMX=OldMX)&&(NewMY=OldMY)){
			Tooltip %XWidth% x %YHeight%, TopLeftX, TopLeftY-30
			OldMX:=NewMX, OldMY:=NewMY
			hbm:=CreateDIBSection(Width, Height), hdc:=CreateCompatibleDC(), obm:=SelectObject(hdc, hbm)
			G:=Gdip_GraphicsFromHDC(hdc), Gdip_SetSmoothingMode(G, 4)
			If dynamic {
				hbm2:=CreateDIBSection(Width, Height), hdc2:=CreateCompatibleDC()
				obm2:=SelectObject(hdc2, hbm2),	G2:=Gdip_GraphicsFromHDC(hdc2)
				BitBlt(hdc2, 0, 0, Width, Height, staichdc, 0, 0)
				Gdip_DrawLine(G2, pPenszx, NewMX, NewMY - 12, NewMX, NewMY + 12)
				Gdip_DrawLine(G2, pPenszx, NewMX - 12, NewMY, NewMX + 12, NewMY)
				BitBlt(hdc, 0, 0, Width, Height, staichdc, 0, 0)		;静态展示
				Gdip_FillRoundedRectangle(G, pBrush, 0, 0, Width, Height, 1)
				BitBlt(hdc, TopLeftX, TopLeftY, XWidth, YHeight, staichdc, TopLeftX, TopLeftY)
				Gdip_DrawRoundedRectangle(G, pPen, TopLeftX - 1, TopLeftY - 1, XWidth + 1, YHeight + 1, 0)	;蓝色边框
				StretchBlt(hdc, NewMX + 15, NewMY + 25, 126, 126, hdc2, NewMX - 10, NewMY - 10, 21, 21)
				Gdip_DrawRoundedRectangle(G, pPenbk, NewMX + 14, NewMY + 24, 127, 127, 0)
				SelectObject(hdc2, obm2), DeleteObject(hbm2), DeleteDC(hdc2), Gdip_DeleteGraphics(G2)
			} Else {
				hbm2:=CreateDIBSection(XWidth, YHeight), hdc2:=CreateCompatibleDC(), obm2:=SelectObject(hdc2, hbm2)
				Gdip_FillRoundedRectangle(G, pBrush, 0, 0, Width, Height, 1)
				BitBlt(hdc, TopLeftX, TopLeftY, XWidth, YHeight, hdc2, 0, 0)		;透明遮罩
				Gdip_DrawRoundedRectangle(G, pPen, TopLeftX - 1, TopLeftY - 1, XWidth + 1, YHeight + 1, 0)		;蓝色边框
				SelectObject(hdc2, obm2), DeleteObject(hbm2), DeleteDC(hdc2)
			}
			UpdateLayeredWindow(hwnd1, hdc, X0, Y0, Width, Height)
			SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc), Gdip_DeleteGraphics(G)
		}

		If (GetKeyState("RButton", "P") = 1)or(GetKeyState("Esc", "P") = 1) {
			Gdip_DisposeImage(MypBitmap)
			Gosub scexit
			exit
		} Else If (GetKeyState("Enter", "P") = 1)
			Break
	}
	Gui, shadow: +LastFound -Caption +AlwaysOnTop +ToolWindow
	WinSet, Transparent, 1
	Gui, shadow: Show, NA x%x0% y%y0% w%Width% h%Height%
	MouseGetPos, MX, MY
	OldMX:=MX, OldMY:=MY, firstfg:=1
	Loop
	{
		MouseGetPos, NewMX, NewMY
		If !(firstfg&&(abs(NewMX-MX)<3)&&(abs(NewMY-MY)<3))
		If !((NewMX=OldMX)&&(NewMY=OldMY)) {
			OldMX:=NewMX, OldMY:=NewMY, xw:=abs(NewMX-MX), yh:=abs(NewMY-MY), XWidth:=xw + 1, YHeight:=yh + 1, firstfg:=0
			Tooltip %XWidth% x %YHeight%, TopLeftX:=(MX < NewMX ? MX : NewMX) ,(TopLeftY:=(MY < NewMY ? MY : NewMY)) -30

			hbm:=CreateDIBSection(Width, Height), hdc:=CreateCompatibleDC(), obm:=SelectObject(hdc, hbm)
			G:=Gdip_GraphicsFromHDC(hdc), Gdip_SetSmoothingMode(G, 4)
			If dynamic {
				hbm2:=CreateDIBSection(Width, Height), hdc2:=CreateCompatibleDC()
				obm2:=SelectObject(hdc2, hbm2), G2:=Gdip_GraphicsFromHDC(hdc2)
				BitBlt(hdc2, 0, 0, Width, Height, staichdc, 0, 0)
				Gdip_DrawLine(G2, pPenszx, NewMX, NewMY - 10, NewMX, NewMY + 10)
				Gdip_DrawLine(G2, pPenszx, NewMX - 10, NewMY, NewMX + 10, NewMY)
				BitBlt(hdc, 0, 0, Width, Height, staichdc, 0, 0)				;静态展示
				Gdip_FillRoundedRectangle(G, pBrush, 0, 0, Width, Height, 1)
				BitBlt(hdc, TopLeftX, TopLeftY, XWidth, YHeight, staichdc, TopLeftX, TopLeftY)
				Gdip_DrawRoundedRectangle(G, pPen, TopLeftX - 1, TopLeftY - 1, XWidth + 1, YHeight + 1, 0)	;蓝色边框
				StretchBlt(hdc, NewMX + 15, NewMY + 25, 126, 126, hdc2, NewMX - 10, NewMY - 10, 21, 21)
				Gdip_DrawRoundedRectangle(G, pPenbk, NewMX + 14, NewMY + 24, 127, 127, 0)
				SelectObject(hdc2, obm2), DeleteObject(hbm2), DeleteDC(hdc2), Gdip_DeleteGraphics(G2)
			} Else {
				hbm2:=CreateDIBSection(XWidth, YHeight), hdc2:=CreateCompatibleDC(), obm2:=SelectObject(hdc2, hbm2)
				Gdip_FillRoundedRectangle(G, pBrush, 0, 0, Width, Height, 1)
				BitBlt(hdc, TopLeftX, TopLeftY, XWidth, YHeight, hdc2, 0, 0)		;透明遮罩
				Gdip_DrawRoundedRectangle(G, pPen, TopLeftX - 1, TopLeftY - 1, XWidth + 1, YHeight + 1, 0)		;蓝色边框
				SelectObject(hdc2, obm2), DeleteObject(hbm2), DeleteDC(hdc2)
			}
			UpdateLayeredWindow(hwnd1, hdc, X0, Y0, Width, Height)
			SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc), Gdip_DeleteGraphics(G)
		}

		If (GetKeyState("LButton", "P") = 0)
			Break
		If (GetKeyState("RButton", "P") = 1)||(GetKeyState("Esc", "P") = 1) {
			Gosub scexit
			exit
		}
	}
	Gosub scexit

	If MypBitmap
		Return {"Box":TopLeftX "|" TopLeftY "|" XWidth "|" YHeight, "Bitmap":Gdip_CloneBitmapArea(MypBitmap, TopLeftX-x0, TopLeftY-y0, XWidth, YHeight)}, Gdip_DisposeImage(MypBitmap)
	Else
		Return {"Box":TopLeftX "|" TopLeftY "|" XWidth "|" YHeight, "Bitmap":ScreenCapture(TopLeftX "|" TopLeftY "|" XWidth "|" YHeight, , , "Bitmap").Bitmap}
	scexit:
		Tooltip
		DllCall("SystemParametersInfo", "UInt", 0x57, "UInt", 0, "UInt", 0, "UInt", 0)	; SPI_SETCURSORS
		Gdip_DeletePen(pPen), Gdip_DeleteBrush(pBrush), Gdip_DeletePen(pPenszx), Gdip_DeletePen(pPenbk)
		If MyhBitmap
			SelectObject(staichdc, staicobm), DeleteDC(staichdc), DeleteObject(MyhBitmap)
		Gui, mengban:Destroy
		Gui, shadow:Destroy
		If (GetKeyState("RButton", "P") = 1)
			KeyWait, RButton, up
		Hotkey, LButton, off
		Hotkey, RButton, off
		Hotkey, Up, off
		Hotkey, Down, off
		Hotkey, Left, off
		Hotkey, Right, off
	Return
	invalid:
	Return
	micromove:
	tt:=InStr("RLDU",SubStr(A_ThisHotkey, 1, 1))-1
	SetTimer, speedinc, -100
	MouseMove, (1-(tt>>1))*(1-2*(tt&1))*movespeed, (tt>>1)*(1-2*(tt&1))*movespeed, 0, R
	If movespeed<30
		movespeed+=1
	Return
	speedinc:
	movespeed:=1
	Return
}

ScreenCapture(Screen = "", bCursor = False, nQuality = 100, sFile*){
	Ptr:=A_PtrSize ? "UPtr" : "UInt", hhdc:=0, pBitmap:=0, sOut:={}
	If (Screen = 0) {
		_x:=DllCall("GetSystemMetrics", "Int", 76), _y:=DllCall("GetSystemMetrics", "Int", 77)
		_w:=DllCall("GetSystemMetrics", "Int", 78), _h:=DllCall("GetSystemMetrics", "Int", 79)
	} Else If (SubStr(Screen, 1, 5) = "hwnd:") {
		Screen:=SubStr(Screen, 6)
		If !WinExist("ahk_id " Screen)
			Return -2
		CreateRect( winRect, 0, 0, 0, 0 ) ;is 16 on both 32 and 64
		DllCall( "GetWindowRect", Ptr, Screen, Ptr, &winRect )
		_w:=NumGet(winRect, 8, "UInt")  - NumGet(winRect, 0, "UInt")
		_h:=NumGet(winRect, 12, "UInt") - NumGet(winRect, 4, "UInt")
		_x:=_y:=0
		hhdc:=GetDCEx(Screen, 3)
	} Else If IsInteger(Screen) {
		M:=GetMonitorInfo(Screen), _x:=M.Left, _y:=M.Top, _w:=M.Right-M.Left, _h:=M.Bottom-M.Top
	} Else If (SubStr(Screen, 1, 7) = "bitmap:") {
		pBitmap:=SubStr(Screen, 8)
	} Else If InStr(Screen, "|") {
		S:=StrSplit(Screen, "|")
		_x:=S[1], _y:=S[2], _w:=S[3], _h:=S[4]
	} Else
		pBitmap:=ScreenCaptureBox(2|bCursor).Bitmap

	If !pBitmap {
		If (_x = "") || (_y = "") || (_w = "") || (_h = "")
			Return -1

		chdc:=CreateCompatibleDC(), hbm:=CreateDIBSection(_w, _h, chdc), obm:=SelectObject(chdc, hbm), hhdc:=hhdc ? hhdc : GetDC()
		BitBlt(chdc, 0, 0, _w, _h, hhdc, _x, _y, Raster)
		If bCursor
			CaptureCursor(chdc, _x, _y)
		pBitmap:=Gdip_CreateBitmapFromHBITMAP(hbm)
		ReleaseDC(hhdc), SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
	}
	If !sFile.Length()
		Return Gdip_SetBitmapToClipboard(pBitmap), Gdip_DisposeImage(Bitmap)

	Loop % sFile.Length()
	{
		If (sFile[A_Index]="Bitmap"){
			sOut.Bitmap:=pBitmap
		} Else If (sFile[A_Index]="Stream"){
			sOut.Stream:=Gdip_SaveImageToStream(pBitmap)
		} Else If (sFile[A_Index]="Clipboard"){
			Gdip_SetBitmapToClipboard(pBitmap)
		} Else If (sFile[A_Index])
			Gdip_SaveBitmapToFile(pBitmap, sFile[A_Index], nQuality)
	}
	If !sOut.Bitmap
		Gdip_DisposeImage(Bitmap)
	Return sOut
}

CaptureCursor(hDC, nL, nT){
	VarSetCapacity(mi, 20, 0), mi:=Chr(20)
	DllCall("GetCursorInfo", "Uint", &mi)
	bShow:=NumGet(mi, 4), hCursor:=NumGet(mi, 8), xCursor:=NumGet(mi,12), yCursor:=NumGet(mi,16)
	If bShow && hCursor:=DllCall("CopyIcon", "Uint", hCursor) {
		VarSetCapacity(ni, 20, 0), DllCall("GetIconInfo", "Uint", hCursor, "Uint", &ni)
		bIcon:=NumGet(ni, 0), xHotspot:=NumGet(ni, 4), yHotspot:=NumGet(ni, 8), hBMMask:=NumGet(ni,12), hBMColor:=NumGet(ni,16)
		DllCall("DrawIcon", "Uint", hDC, "int", xCursor - xHotspot - nL, "int", yCursor - yHotspot - nT, "Uint", hCursor)
		DllCall("DestroyIcon", "Uint", hCursor)
		If hBMMask
			DllCall("DeleteObject", "Uint", hBMMask)
		If hBMColor
			DllCall("DeleteObject", "Uint", hBMColor)
	}
}