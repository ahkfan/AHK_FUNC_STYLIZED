Gui Add, ActiveX, xm w980 h640 vWB, Shell.Explorer
ComObjConnect(WB, WB_events)
Gui, show
WB.Navigate("https://up.woozooo.com/account.php?action=login&ref=/mydisk.php")
sleep 1000
b := WB.document.getElementById("username")
b.setAttribute("value", "13906910247")
b := WB.document.getElementsByTagName("input")
a := ""
loop, %  b.length
{
	i := A_Index

	try {
		obj := b[i]
		if obj.getAttribute("placeholder") = "密码"
			obj.click
	}
}
/*
b := WB.document.getElementsByTagName("a")
a := ""
loop, %  b.length
{
	i := A_Index

	try {
		obj := b[i]
		if obj.getAttribute("href") = "http://www.lanzou.com/account.php?action=login"
			obj.click
	}
}
sleep 3000
b := WB.document.getElementsByTagName("input")
loop, %  b.length
{
	i := A_Index
	try {
		obj := b[i]
		MsgBox, % obj.getAttribute("class")

	}
}
*/
return


class Ctrl_ActiveX {
	__New(IEserverObj) {
		this.obj := IEserverObj
	}

	getTagAll() {

	}
}

