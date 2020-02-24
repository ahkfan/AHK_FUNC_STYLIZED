;~ 未完
class fsGui
{
    static name  := "fsGui_"
    static index := 0

    ahk_id[]
    {
        get {
            return ("ahk_id " this.hwnd)
        }
        set {
            MsgBox, % "Can't not set values for 'ahk_id'"
        }
    }
    ;------------------------- new -------------------------
    __New(title := "", options := "")
    {
        this.index  := (fsGui.index += 1)
        this.name   := this.name this.index ":"

        Gui, % this.name "+hwnd@fsGuiHwnd"
        Gui, % this.name "show"
        this.hwnd   := @fsGuiHwnd

        this.title  := (title == "") ? this.name : title
        this.childs := []
        for i, option in options
        {
            ;~ TODO
        }
    }

    ;------------------------- show | hide | destroy  -------------------------
    show()
    {
        Gui, % this.name "show", , % this.title
    }
    hide()
    {
        Gui, % this.name "hide"
    }
    destroy()
    {
        this.__Delete()
    }
    __Delete()
    {
        for i, ops in this.childs
            ops.__Delete()
        Gui, % this.name "destroy"
    }

    ;------------------------- add controls -------------------------
    newOP(OPType, options)
    {

    }

    class Operation
    {
;-------------------------  -------------------------
class Button
{

}
class Edit
{

}
class ListBox
{

}
class ListView
{

}
;-------------------------  -------------------------
    }
}