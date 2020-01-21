;~ 从文件里取出, 大概如此
text =
(join`r`n
asdgasdg-asdfgasdg-3
asdgahfd-erf24gzdf-3
adfhtrk6-1234675e3-1
asdhgh55-e4ydvsdfh-1
herthhhh-57ellhjdf-2
)

ls := []
MsgBox, % text
for i, v in strsplit(text, "`n", "`r") 
{
	ls.push(strsplit(v, "-"))
}
   
ls[2].push("adddd")

s:=""
for i, ls2 in ls
{
	s .= lsjoin(ls2, "-") "`r`n"
}

;~ 输出, 可写入文件
msgbox, % s
return

lsjoin(ls, delim) 
{
	ret := ""
	for i, v in ls
	   ret .= v . delim
	ret := substr(ret, 1, -1)
	return ret
}



