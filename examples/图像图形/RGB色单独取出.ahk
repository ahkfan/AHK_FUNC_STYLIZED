

/*
MsgBox, % intColor := format("{1:i}", 0XF0F0F0)
MsgBox, % toHex := format("0x{1:x}   0x{2:x}", 1234, 6666)
*/
CoordMode, mouse,screen
CoordMode, Pixel,screen
return
f5::
	MouseGetPos, x, y
	PixelGetColor, colr, % x, % y, RGB
	msgbox, % colr
	MsgBox, % Rget(colr)
	MsgBox, % Gget(colr)
	MsgBox, % Bget(colr)
return



Rget(Hex) {
	return Hex >> 16
}
Gget(Hex) {
	return (Hex >> 8) & 0xff
}
Bget(Hex) {
	return Hex & 0xff
}

