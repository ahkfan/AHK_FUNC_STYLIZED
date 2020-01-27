;guiop := guiop()

guiop()
{
    return __CLASS_AHKFS_GUIOP
}

class __CLASS_AHKFS_GUIOP
{

    ;-----------------------------------
    GetText(hwnd)
    {
        /*  
        guiop.GetText(hwnd)

        简介:   获取控件的文本

        参1:    hwnd    {UInt}    控件选项 hwnd句柄, 不支持v变量
        
        返回值: {String}
        */
        GuiControlGet, ret, , % hwnd
        return ret
    }

    ;-----------------------------------
    SetText(hwnd, Text)
    {
        GuiControl, , % hwnd, % Text
    }
    
    ;-----------------------------------
    GetPos(hwnd)
    {
        /*
        guiop.GetPos(hwnd)

        简介:   获取控件相对窗口的坐标

        参1:    hwnd    {UInt}        控件选项 hwnd句柄, 不支持v变量

        返回值: {Object}            {
                                        x: {Int}, 
                                        y: {Int},
                                    }

        */       
        GuiControlGet, ret, Pos, % hwnd
        return {"x" : retX, "y": retY}
    }

    ;-----------------------------------
    GetSize(hwnd)
    {
        /*
        guiop.GetSize(hwnd)

        简介:   获取控件的宽高尺寸

        参1:    hwnd    {UInt}        控件选项 hwnd句柄, 不支持v变量

        返回值: {Object}            {
                                        w: {UInt}, 
                                        h: {UInt},
                                    }

        */  
        GuiControlGet, ret, Pos, % hwnd
        return {"w" : retW, "h" : retH}   
    }

    ;-----------------------------------
    GetRect(hwnd)
    {
        /*

        guiop.GetSize(hwnd)

        简介:   获取控件相对窗口的矩形区域坐标

        参1:    hwnd    {UInt}        控件选项 hwnd句柄, 不支持v变量

        返回值: {Object}                {
                                            x1: {Int}
                                            y1: {Int} 
                                            x2: {Int}
                                            y2: {Int}
                                        }

        */  
        GuiControlGet, ret, Pos, % hwnd
        return {"x1": retX, "y1": retY, "x2": retX + retW, "y2": retY + retH}
    }

    ;-----------------------------------
    GetPosRef(hwnd, byref refX, byref refY)
    {
        /*
        guiop.GetPosRef(hwnd, x, y)

        简介: 获取控件相对窗口的坐标

        参1:    hwnd    {UInt}          控件选项 hwnd句柄, 不支持v变量
        参2:    x       {Int & byref}   返回 控件 相对窗口左侧 的坐标 x
        参3:    y       {Int & byref}   返回 控件 相对窗口顶部 的坐标 y
        
        返回值: ""
        */
        GuiControlGet, ret, Pos, % hwnd
        refX := retX, refY := retY
    }

    ;-----------------------------------
    GetSizeRef(hwnd, byref refW, byref refH)
    {
        /*
        guiop.GetSizeRef(hwnd, refW, refH)

        参1:    hwnd    {UInt}          控件选项  hwnd句柄, 不支持v变量
        参2:    w       {Int & byref}   返回 控件宽度
        参3:    h       {Int & byref}   返回 控件高度

        返回值: ""
        */
        GuiControlGet, ret, Pos, % hwnd
        refX := retX, refY := retY     
    }

    ;-----------------------------------
    GetRectRef(hwnd, byref refX1, byref refY1, byref refX2, byref refY2)
    {
        /*
        guiop.GetRectRef(hwnd, refX1, refY1, refX2, refY2)

        参1:    hwnd        {UInt}          控件选项  hwnd句柄, 不支持v变量
        参2:    refX1       {Int & byref}   返回控件相对窗口 左侧坐标 x1
        参3:    refY1       {Int & byref}   返回控件相对窗口 顶部坐标 y1
        参4:    refX2       {Int & byref}   返回控件相对窗口 右侧坐标 x2
        参5:    refY2       {Int & byref}   返回控件相对窗口 底部坐标 y2

        返回值: ""
        */
        GuiControlGet, ret, Pos, % hwnd
        refX1  := retX, refY1 := retY, refX2 := retX + retW, refY2 := refY + refH
    }
}