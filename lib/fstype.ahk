/*
    return type of a certain obj

    This relies on the following:
    Unlike a variable, an array element can't contain a string and a pure number simultaneously.
    A field's "capacity" is the size of string it can hold before it needs to expand. If it doesn't hold a string it has no capacity.
    SetFormat hasn't been used to remove the decimal point from the floating-point string format. (If var is float has the same limitation, since it always converts the obj to a string for analysis.)

    reference: https://blog.csdn.net/liuyukuan/article/details/90545903

    只支持简单的类型判断
    在对象是一个类时返回字符串 "Object: BaseObjectName"，如果基对象是数组或者关联数组则认为对象是一个数组或者关联数组
    问题：不支持判断 FuncObject ComObject RegexObject 等等复杂的对象，
         这些对象要么会被视作数组如FileObject；要么会抛出异常，代表内存中的结构的对象通常会抛出异常
         
         不支持判断 Inf -Inf NaN 等特殊的浮点类型，这些浮点类型应该会被当成字符串类型
*/

; 改了，还没再次测试

fstype(obj)
{
    ; for v2
    if SubStr(A_AhkVersion, 1, 1) >= 2
        ; 如果是内置的类那么使用v1的判断方法
        if type(obj) != "Class"
            return type(obj)
        else
            Goto V1AssertArray
    ; for v1
    if IsObject(obj)
	{
        ; 这里也许更应该返回基对象本身
        if obj.__class
            while obj := obj.base
            {
                if !obj.__class
                    return obj.__Class
            }
        V1AssertArray:
		if ObjGetCapacity(obj)>ObjCount(obj)
            return "Associative Array"
		else
			return "Array"
	}
    return obj="" || [obj].GetCapacity(1) ? "String" : InStr(obj,".") ? "Float" : "Integer"
}
