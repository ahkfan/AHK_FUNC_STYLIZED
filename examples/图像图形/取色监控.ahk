msgbox, % getColor(100, 100)
return

getColor(x, y) {
	PixelGetColor, ret, % x, % y, RGB
	return ret
}