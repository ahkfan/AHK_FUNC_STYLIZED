
ret := {}
Loop, Reg, HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\, R
{
	keyDict := {"DhcpIPAddress":0, "IPAddress":0}
	if (keyDict.HasKey(A_LoopRegName))
	{
		RegRead,  ipAddress, % A_LoopRegKey "\" A_LoopRegSubKey, % A_LoopRegName
		MsgBox, % ipAddress
	}
}