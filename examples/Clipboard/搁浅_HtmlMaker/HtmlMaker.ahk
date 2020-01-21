#SingleInstance force
data := {}

Gui, +toolwindow
Gui, add, treeview, w150 h300 hwnd@html
Gui, add, listbox, y6 w150 h300, % ls_2Str("|","a","abbr","acronym","address","applet","area","article","aside","audio","b","base","basefont","bdi","bdo","big","blockquote","body","br","button","canvas","caption","center","cite","code","col","colgroup","command","datalist","dd","del","details","dir","div","dfn","dialog","dl","dt","em","embed","fieldset","figcaption","figure","font","footer","form","frame","frameset","h1","head","header","hr","html","i","iframe","img","input","ins","isindex","kbd","keygen","label","legend","li","link","map","mark","menu","menuitem","meta","meter","nav","noframes","noscript","object","ol","optgroup","option","output","p","param","pre","progress","q","rp","rt","ruby","s","samp","script","section","select","small","source","span","strike","strong","style","sub","summary","sup","table","tbody","td","textarea","tfoot","th","thead","time","title","tr","track","tt","u","ul","var","video","wbr","xmp")
Gui, show, ,html maker

html := new element("html")
return

guiclose() {
	ExitApp
}

class dom {
	static eleLs := []
}

class element {
	static dict := {}
	static tagList := obj_trans_key_var(["a","abbr","acronym","address","applet","area","article","aside","audio","b","base","basefont","bdi","bdo","big","blockquote","body","br","button","canvas","caption","center","cite","code","col","colgroup","command","datalist","dd","del","details","dir","div","dfn","dialog","dl","dt","em","embed","fieldset","figcaption","figure","font","footer","form","frame","frameset","h1","head","header","hr","html","i","iframe","img","input","ins","isindex","kbd","keygen","label","legend","li","link","map","mark","menu","menuitem","meta","meter","nav","noframes","noscript","object","ol","optgroup","option","output","p","param","pre","progress","q","rp","rt","ruby","s","samp","script","section","select","small","source","span","strike","strong","style","sub","summary","sup","table","tbody","td","textarea","tfoot","th","thead","time","title","tr","track","tt","u","ul","var","video","wbr","xmp"])
	__New(tag, parent := "",text := "", attrDict := "", styleDict := "") {
		if not isobject(parent) {
			this.parent := "root"
			dom.eleLs.push(this)
			this.i := dom.eleLs.MaxIndex()
		} else {
			this.parent := parent
			parent.childs.push(this)
			this.i := parent.i "-" parent.childs.MaxIndex()
		}

		this.text := text
		this.name := tag ":" this.i
		this.tag := tag

		this.childs := []
		this.attrDict := (attrDict = "") ? {} : attrDict
		this.styleDict :=  (styleDict = "") ? {} : styleDict
		this.hwnd := tv_add(this.name)

	}
	add() {

	}
}

ls_2Str(sDelimit,ls*) 			{			;~ 将列表组成一个新字符串, 参1为分隔符, 返回字符串
	rtStr := ""
	for i, v in ls
		rtStr .= v . sDelimit
	if (rtStr)
		StringTrimRight, rtStr, rtStr, 1
	return rtStr
}

obj_trans_key_var(obj) {
	retObj := {}
	for key, var in obj
		retObj[var] := key
	return retObj
}