DllCall("QueryPerformanceFrequency", "Int64*", QuadPart)

DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
MsgBox, % CounterBefore / QuadPart * 1000000
Sleep 1000
DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
;MsgBox % "Elapsed QPC time is " . (CounterAfter - CounterBefore) /QuadPart * 1000000

return
