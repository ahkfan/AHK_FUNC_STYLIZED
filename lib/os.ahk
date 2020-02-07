;~系统与文件

os()
{
    return __CLASS_AHKFS_OPERATION_SYSTEM
}


class __CLASS_AHKFS_OPERATION_SYSTEM
{
    ;------------------------- get hardware info -------------------------
    GetCPUList()
    {
        /*
            简介:   获取所有CPU 名称 / 唯一编号
                    参考网址: https://docs.microsoft.com/zh-cn/windows/win32/cimwin32prov/win32-processor
        */
        ret := []
        for v in ComObjGet("Winmgmts:").InstancesOf("Win32_Processor")
            ret.push({"Name": v.Name, "ProcessorId" :v.ProcessorId}) 
        return ret
    }

    GetDiskList()
    {
        /*
           简介:    获取所有硬盘 型号 / 尺寸 / 唯一编号, 包括外置硬盘
                    参考网址: https://docs.microsoft.com/zh-cn/windows/win32/cimwin32prov/win32-diskdrive
        */
        ret := []
        for v in ComObjGet("Winmgmts:").InstancesOf("Win32_DiskDrive")
            ret.push({"Model" : v.Model, "Size" : v.Size , "DeviceID" : v.DeviceID})   
        ;  v.PNPDeviceID 这个不知道干嘛的
        return ret
    }

    GetPhysicalMemoryList()
    {
        /*
            简介:   获取物理内存的 产商 / 容量
                    参考网址: https://docs.microsoft.com/zh-cn/windows/win32/cimwin32prov/win32-physicalmemory
        */
        ret := []
        for v in ComObjGet("Winmgmts:").InstancesOf("Win32_PhysicalMemory")
            ret.push({"Manufacturer" : v.Manufacturer, "Capacity" : v.Capacity }) 
        return ret
    }

    ;------------------------- ip -------------------------
    GetEnableIPV4s()
    {
        /*
            简介:    获取当前局域网内可用的ipv4地址
                    参考网址: https://docs.microsoft.com/zh-cn/windows/win32/cimwin32prov/win32-networkadapterconfiguration
        */
        ret := []
        for v in ComObjGet("Winmgmts:").InstancesOf("Win32_NetworkAdapterConfiguration")
            if (-1 == v.IPEnabled)
                loop, % v.IPAddress.MaxIndex()
                    if not instr(addr := v.IPAddress[A_Index - 1], ":")
                        ret.push(addr)
        return ret
    }
}