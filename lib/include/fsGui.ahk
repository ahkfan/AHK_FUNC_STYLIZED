
e := new fsEdit({text: "abc"})

Gui, show
a := 0
return

class fsGui
{

}



class fsEdit
{
    text[]
    {
        get
        {
            return this._text
        }
        set
        {
            GuiControl, , % this.hwnd, % this._text := value
        }
    }
    __New(option)
    {
        Gui, add, edit, hwnd@Edit, % option.text
        this.hwnd := @Edit
        this._text := option.text
    }
}