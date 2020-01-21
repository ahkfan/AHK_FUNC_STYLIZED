结果 := ""
loop, read, test.ini
{
	line := a_loopreadline
	if instr(line, "-") {
		a  := strsplit(line, "-")
		结果 .= a[1] . "|"
	}

}
gui, add, dropdownlist , w200 r20, % 结果
gui, show

Return