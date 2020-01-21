#SingleInstance force

main:

	w := 350		;~ 编辑框宽度
	len := 512		;~ 缓冲区尺寸

	Gui, add, edit, gChange hwndECG w%w% h25

	md := []
	md.push({"CharSet": "GBK"		, "CodePage": "cp936"	, "hwnd": ""})
	md.push({"CharSet": "Big5"		, "CodePage": "cp950"	, "hwnd": ""})
	md.push({"CharSet": "GB2312"	, "CodePage": "cp20936"	, "hwnd": ""})
	;md.push({"CharSet": "GB18030"	, "CodePage": "cp54936"	, "hwnd": ""})
	md.push({"CharSet": "ASCLL"		, "CodePage": "cp437"	, "hwnd": ""})
	md.push({"CharSet": "utf-8"		, "CodePage": "cp65001"	, "hwnd": ""})
	md.push({"CharSet": "utf-16"	, "CodePage": "cp1200"	, "hwnd": ""})
	;md.push({"CharSet": "utf-16-big endian"	, "CodePage": "cp1201"	, "hwnd": ""})

	;md.push({"CharSet": "utf-32"	, "CodePage": "cp12000"	, "hwnd": ""})

	for i, obj in md
	{
		Gui, add, text, 								, % obj.Charset "-----" obj.CodePage
		Gui, add, edit, readonly w%w% h25 hwnd@e
		obj.hwnd := @e
	}
	Gui, show

	VarSetCapacity(buff, len, 0)
return

Change:
	guicontrolget, text, , % ECG
	for i, o in md
	{
		VarSetCapacity(buff, len, 0)
		StrPut(text, &buff , len , o.CodePage)

		bin := ""
		Loop, % len // 4
		{
			aa := NumGet(&buff, a_index - 1, "UChar")
			bin .= format( "{1:02x}", aa) " "
		}
		bin := RegExReplace(bin, "(00\s)+$")

		GuiControl, , % o.hwnd, % bin
	}
return
