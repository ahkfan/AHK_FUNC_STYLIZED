import ctypes, sys

STD_OUT_HANDLE = -11

GREEN = 0x0a
RED   = 0x0c
BULE  = 0X09
YELLOW= 0x0e

failtestCount = 0

hStdOut = ctypes.windll.kernel32.GetStdHandle(STD_OUT_HANDLE)

def SetCmdTxtColor(color, handle = hStdOut):
    return ctypes.windll.kernel32.SetConsoleTextAttribute(handle, color)

def ResetColor():
    SetCmdTxtColor(RED | GREEN | BULE)

p_in = sys.stdin.readlines()

for line in p_in:
    if line.split(":")[0] == "FAIL":
        failtestCount += 1
        SetCmdTxtColor(RED)
        print(line)
        ResetColor()
    else:
        print(line)

print("Total:", len(p_in)," Fail test:",failtestCount,"\nFrom Python")
