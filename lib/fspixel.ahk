; LIB Of Pixel
; need test

fsPixel()
{
    Return __ClASS_AHKFS_PIXEL
}

class __ClASS_AHKFS_PIXEL
{
    Search(X1, Y1, X2, Y2, ColorID, Variation := 0, Mode := "RGB")
    {
        PixelSearch, OutputVarX, OutputVarY, %X1%, %Y1%, %X2%, %Y2%, %ColorID%, %Variation%, %Mode%
        if !ErrorLevel
            Return [OutputVarX, OutputVarY]
    }

    GetColor(X, Y, AltSlow:="")
    {
        local OutputVar
        PixelGetColor OutputVar, %X%, %Y%, %AltSlow% RGB ; v2 uses RGB
        if !ErrorLevel
            return OutputVar
    }
}