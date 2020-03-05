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


fstype(obj)
{
    local
    if IsObject(obj)
    {
        if obj.haskey("__class")
            return obj.__class
        if ((objCount := obj.count()) == 0)
            return "Array"
        else if (objCount == obj.Length() && obj.MinIndex() == 1)
            return "Array"
        else
            return "Associative Array"
    }
    else
    {
        if (obj == "")
            return "None"

        if ((1 | obj) == "")
            return "String"
        else
            if instr(obj, ".")
                return "Float"
            else
                return "Integer"
    }
}