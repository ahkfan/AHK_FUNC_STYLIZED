

hw_url = %A_ScriptDir%\index.html

Gui +AlwaysOnTop  +HwndGuiHwnd +LastFound -DPIScale
Gui, Add, ActiveX, vg_webBrowser hwndg_hwndWebBrowser x0 y0 w300 h300, Shell.Explorer ; The final parameter is the name of the ActiveX component.

g_webBrowser.silent := true ; Surpress JS Error boxes
ComObjConnect(g_webBrowser, "IE_")
g_webBrowser.Navigate(%A_ScriptDir%\index.html)
g_webBrowser.document.parentWindow.HTML中事件响应函数 := Func("回调函数")    ;~ 这句重点

;g_fader := new WindowFader(GuiHwnd)
Gui, show, ,abc
return


执行AHK_1()  ;~ 作为 HTML中事件响应函数("")
{
    static a := 0
    ToolTip, % "执行AHK_1: " a += 1
}

执行AHK_2()  ;~ 作为 HTML中事件响应函数("")
{
    static a := 0
    ToolTip, % "执行AHK_2: " a += 1
}

; javascript:AHK('Func') --> Func()
回调函数(func, prms*) ;~ 于UI
{
    global g_webBrowser

	wb := g_webBrowser
	; Stop navigation prior to calling the function, in case it uses Exit.
	wb.Stop()
	return %func%(prms*)
}

;~ 这里不知道干嘛的
class WindowFader {

    __New(hwnd) {
        this.speed := 6.0
        this.isFadeIn := true
        this.interval := 1
        this.hwnd := hwnd
        this.alpha := 0.0


        ; Tick() has an implicit parameter "this" which is a reference to
        ; the object, so we need to create a function which encapsulates
        ; "this" and the method to call:
        this.timer := ObjBindMethod(this, "_tick")
    }



    fadeIn() {
        this.isFadeIn := true
        this._startTimer()
    }

    fadeOut() {
        this.isFadeIn := false
        this._startTimer()
    }

    _startTimer() {

        ; KNOWN LIMITATION: SetTimer requires a plain variable reference.
        timer := this.timer
        SetTimer % timer, % this.interval

        this.lastTime := A_TickCount
    }

    _stopTimer() {
        ; To turn off the timer, we must pass the same object as before:
        timer := this.timer
        SetTimer % timer, Off
    }

    ; In this example, the timer calls this method:
    _tick() {

        delta := (A_TickCount - this.lastTime) / 1000.0
        this.lastTime := A_TickCount

        if (this.isFadeIn and this.alpha > 1.0) {
            this.alpha := 1.0
            this._stopTimer()
        }
        if ( !this.isFadeIn and this.alpha <= 0.0 ) {
            this.alpha := 0.0
            this._stopTimer()
        }

        if (this.alpha > 0.0) {
            WinShow, % "ahk_id " this.hwnd
        }
        if (this.alpha <= 0.0) {
            WinHide, % "ahk_id " this.hwnd
        }


        ; Apply animation curve
        val := sin( this.alpha * 1.57079632679 ) * 256


        WinSet, Transparent, % val, % "ahk_id " this.hwnd


        step := delta * this.speed
        step := this.isFadeIn ? step : -step
        this.alpha += step
    }

}