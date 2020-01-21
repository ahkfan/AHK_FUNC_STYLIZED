#include obj.ahk
/*
	一个前端朋友, 碰上一个数据转换的麻烦
	具体内容, 将src样式的结构转换成另一种格式
*/

src := [{words:"hhh"}
,{words:"12"}
,{words:"54"}
,{words:"78"}

,{words:"mmm"}
,{words:"32"}
,{words:"785"}
,{words:"ddd"}]

result := stylizedLs(src)
msgbox, % obj_dbg3(result)

stylizedLs(src) {
	ret := []
	name := ""
	index := 0

	for i in src
	{
		v := src[i]["words"]

		if v is not number
		{
			ret.push({"name": v, "data": []})
			index := ret.length()
			name := v
		}
		else
		{
			ret[index]["data"]["push"](v)
		}
	}

	return ret
}

