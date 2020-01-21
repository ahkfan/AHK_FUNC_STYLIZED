f1::	;~ 在win10 notepad 记事本窗口激活时测试
	WinGet, a, id

	PostMessage,  0x100, % GetKeyVK("a"), 0, Edit1, A	;WM_KEYDOWN
	PostMessage,  0x101, % GetKeyVK("b"), 0, Edit1, A	;WM_KEYUP
	PostMessage,  0x102, % Asc("阿")	, 0	, Edit1, A	;WM_CHAR

	PostMessage,  0x104, % GetKeyVK("c"), 0, Edit1, A	;WM_SYSKEYDOWN
	PostMessage,  0x105, % GetKeyVK("d"), 0, Edit1, A	;WM_SYSKEYUP
	PostMessage,  0x106, % Asc("搞")	, 0, Edit1, A	;WM_SYSCHAR
	PostMessage,  0x107, % Asc("的")	, 0, Edit1, A	;WM_SYSDEADCHAR

	PostMessage,  0x286, % Asc("万"), 0, Edit1, A		;WM_IME_CHAR
	PostMessage,  0x290, % GetKeyVK("e"), 0, Edit1, A	;WM_IME_KEYDOWN
	PostMessage,  0x291, % GetKeyVK("f"), 0, Edit1, A	;WM_IME_KEYUP
return