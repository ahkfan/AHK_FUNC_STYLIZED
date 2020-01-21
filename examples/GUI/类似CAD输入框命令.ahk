;双击右键按住不放，输入b,松开鼠标右键发送box
#SingleInstance FORCE

global 按键字典 :=  {"b" : "box"
, "c" : "功能2"}
return


box:
    msgbox, 777
    return

功能2:
    msgbox, 666
    return

/*========================================
 *按键功能代码块
==========================================
*/

~Rbutton up::
    WinClose, myRun
    return

;#IfWinActive Untitled - Autodesk 3ds Max 2018

RButton::
    KeyWait, RButton
    keyWait, RButton, D T0.1

    If ErrorLevel ;如果超时，就是单击，否则就是双击
    {
     Click, Right
    }
    Else {
        showgui()
        return
    }
    Return


GuiClose:
    gui,Submit
    dicttolable(cmd)
    Destroygui()
    return

dicttolable(the_key) {
    if !the_key
        return
    aaa := 按键字典[the_key]
    if !aaa
    {
        traytip, , % "命令" the_key "不在命令列表中"
    }
    else
        gosub, % 按键字典[the_key]
    return
}

showgui() {
    global
    WIDTH := 600
    Gui,Destroy
    gui, font, s200 cFFFFFF
    gui, color, 000000, 000000
    Gui,add,edit, +BackgroundTrans vCmd x0 y0 w%WIDTH% h300
    Gui -Caption  ; 如果它不是 默认窗口, 则使用 Gui, GuiName:-Caption.
    Gui, +hwndaaaaa
    Gui, Show,  h300 w%WIDTH%, myRun
    WinSet , trans, 100, % "ahk_id " aaaaa
    ;OutputDebug,"show"
}

Destroygui() {
    Gui,Destroy
}
