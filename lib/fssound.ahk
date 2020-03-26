; LIB OF SOUND
; 未经测试

fsSound()
{
    return __CLASS_AHKFS_SOUND
}

class __CLASS_AHKFS_SOUND
{
    Beep(Frequency:=523, Duration:=150)
    {
        SoundBeep %Frequency%, %Duration%
    }
    
    Get(ComponentType:="", ControlType:="", DeviceNumber:="")
    {
        local OutputVar
        SoundGet OutputVar, %ComponentType%, %ControlType%, %DeviceNumber%
        if !ErrorLevel
            return OutputVar
    }
    
    Play(Filename, Wait:="")
    {
        SoundPlay %Filename%, %Wait%
        return !ErrorLevel
    }

    Set(NewSetting, ComponentType:="", ControlType:="", DeviceNumber:="")
    {
        SoundSet %NewSetting%, %ComponentType%, %ControlType%, %DeviceNumber%
        return !ErrorLevel
    }
}
