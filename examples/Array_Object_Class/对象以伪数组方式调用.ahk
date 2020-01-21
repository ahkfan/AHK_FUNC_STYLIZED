;~ 对象以伪数组方式调用
sObj := "obj"
obj := [{x:123, y:567}, {x: 234, y:789}]
MsgBox, % (%sObj%)[1, "x"]

