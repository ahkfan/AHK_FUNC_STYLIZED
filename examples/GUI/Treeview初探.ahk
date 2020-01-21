#SingleInstance force
Gui, add, edit, hwnd@root readonly
Gui, Add, TreeView, w200 h600
Gui, show
return

GuiClose() {
	ExitApp
}

GuiDropFiles:

	dir := A_Guievent

	if (SubStr(dir, -3) = ".lnk")
		FileGetShortcut, % dir, dir

	FileGetAttrib, Attribute, % dir

	if instr(Attribute, "D") {
		TV_Delete()
		GuiControl, , % @root, % dir
		Loop, files, % dir "\*",FD
			MkDirTv(A_LoopFileLongPath, "")
	}
return

MkDirTv(path, parent) {
	local hwnd, Attribute

	FileGetAttrib, Attribute, % path
	SplitPath, path, name
	if instr(Attribute, "D") {
		hwnd := TV_Add("[D]" name, parent)
		Loop, files, % path "\*", FD
			MkDirTv(A_LoopFileLongPath, hwnd)
	} else {
		TV_Add("[F]" name, parent)
	}
}


