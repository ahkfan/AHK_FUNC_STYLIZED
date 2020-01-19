/*
    return type of a certain obj

    This relies on the following:
    Unlike a variable, an array element can't contain a string and a pure number simultaneously.
    A field's "capacity" is the size of string it can hold before it needs to expand. If it doesn't hold a string it has no capacity.
    SetFormat hasn't been used to remove the decimal point from the floating-point string format. (If var is float has the same limitation, since it always converts the value to a string for analysis.)

    reference: https://blog.csdn.net/liuyukuan/article/details/90545903
*/
type(obj)
{
    if IsObject(obj)
	{
		if ObjGetCapacity(obj)>ObjCount(obj)
			return "Associative Array"
		else
			return "Array"
	}
    return obj="" || [obj].GetCapacity(1) ? "String" : InStr(obj,".") ? "Float" : "Integer"
}