; RANDOM LIB OF FS
; !!! 还没测试过
; 写成类只是我顺手而已，之后再统一改

;------------------------------------------
/* rand.rand()	;~ 无碍


a := []
loop 10
	a[A_Index] := 0

loop, 10000 {

	l := StrLen(rand.rand())
	a[l] += 1
}

b := ""
for i, v in a
	b .= i ">" v "`n"
MsgBox, % b
*/


;------------------------------------------
/* Rand.RandRange(min, max, step)	;~ 在random命令中左右任意存在浮点数, 结果返回浮点数


msgbox, % Rand.RandRange(0, 20, 3)


b := ""
Random, a, 0.0, 30
b .= "1: " a "`n"
Random, a, 0, 30
b .= "1: " a "`n"
MsgBox, % b

b := ""
loop, 20
	b .= Rand.RandRange(50, 0, 3) "`n"
MsgBox, % b
*/


;------------------------------------------
/* Rand.Shuffle(source)		;~ 已改动


c := [1, 2, 3, 4, 5]
MsgBox, % c[0]
a := Rand.Shuffle(c)
for i, v in a
	MsgBox, % v
MsgBox, % obj_dbg2(a)
*/

;------------------------------------------
/* Rand.Choice(source) 数组也测了..可能没毛病

b := ""
loop, 20
b .= Rand.Choice("abcdefghijkl") "`n"
MsgBox, % b
*/

;------------------------------------------
/* Rand.Sample(soucre, num) ... 不敢测了.. 直接返回空

a := Rand.Sample([123, 555, 666], 5)
MsgBox, % obj_dbg2(a)
MsgBox, % obj_dbg2([123, 555, 666])
*/



;---------------------------------------------------------------------
;~ 拷贝整个对象, 对class method无效
obj_copy(obj) {
	;local rtObj := ""
	if not isobject(obj) {
		retObj := obj
	} else {
		retObj := {}
		for k, v in obj
			retObj[k] := obj_copy(v)
	}
	return retObj
}

;---------------------------------------------------------------------
;~ 将对象转换为可读字符串
obj_dbg1(obj) {
    ret := ""
    if IsObject(obj) {
        ret .= "{"
        for key, var in obj
            ret .= key . " :" . obj_dbg1(var) . ", "
        if (key <> "")
            ret := SubStr(ret, 1, -2)
        ret .= "}"
    } else {
        if obj is number
            ret := obj
        else if (obj = "")
            ret = ""
        else
            ret := """" obj """"
    }
    return ret
}

;---------------------------------------------------------------------
;~ 将对象转换为可读字符串
obj_dbg2(obj) {
    ret := ""
    for key, var in obj
        ret .= key "=" obj_dbg1(var) "`n"

    if (key <> "")
        ret := SubStr(ret, 1, -1)
    return ret
}



class Rand
{
    _getLength(item)
    {
        if IsObject(item)
            Return item.Length()
        else
            Return StrLen(item)
    }

    Rand(min := 0, max := 2147483647)
    {
        out := 0
        Random, out, min, max
        Return out
    }

    RandRange(min, max, step)
    {

        ; 返回从"max"到"min"之间的一组随机数，间隔为"step"


        Random, out, 0, % (max - min) // step

        Return min + out * step
    }

    Choice(source)
    {
		; source 为 数组 或 字符串
        ; 随机返回一个在"soucre" 中的元素，字符串时为一个字符
        if IsObject(source)
        {
            if !source[1]
            {
                ; 当source是关联数组的情况
        ;   !!!! 这个效率比较低我不知道有没有更好的方法 !!!!
                ; 不要在关联数组比较长的时候使用
                s2 := []
                for k,v in soucre
                    s2 := s2.push(k)
                i := this.Choice(s2)
                Return Object(i, s2[i]) ; 关联数组的键用{}的方式设置，不能用变量，只好这样了
            }
            ; 简单数组的情况
            i := this.Rand(1, source.Length())
            Return source[i]
        }
        else
        {
            i := this.Rand(1, StrLen(source))
            Return SubStr(source, i, 1)
        }
    }

    Shuffle(source)
    {
        ; 返回一个顺序被随机打乱的简单数组
        s2 := obj_copy(source)

        if IsObject(source)
        {
        ; 如果关联数组包含键 "1" 那么就凉了，有人这么写的话我也没办法
            if !s2[1]
                Throw, Exception("Source must be an unempty simple array, not an empty array or associative arrays.")

            l := source.Length() + 1

            for k, v in source
            {
                j := this.Rand(1, l-k)
                temp := s2[l-k]

                s2[l-k] := s2[j]
                s2[j] := temp

            }
            Return s2
        }
        /*
        byref 版
        if IsObject(source)
        {
            l := source.Length()
            for k,v in source
            {
                j := this.Rand(0, l-k)
                temp := source[l-k]
                source[l-k] := source[j]
                source[j] := temp
            }
        }
        */
    }

    ; TODO: 把这个部分改成可以跑的
    Sample(soucre, num)
    {
        l := this._getLength(source)

        if num >= l or num <= 0
            Throw Exception("Sample larger than source or is negative")

        ; 这个部分是什么道理我也不知道，python官方是这么写的LOL
        result := []

        setsize := 21

        if num > 5
            setsize += 4^(Ceil(Log(num * 3)/Log(4)))


        if l <= setsize
        {
            pool := obj_copy(soucre)

            Loop, num
            {
                j := this.Rand(1, l-A_Index)

                result[A_Index] := pool[j]

                pool[j] := pool[l-A_Index]
            }

        } else {

            select := []

            Loop, num
            {
                j := this.Rand(1, l-A_Index)

				While (j in select) {

                    j := this.Rand(1, l-A_Index)
				}

                select.Push(j)

                result[A_Index] := soucre[j]
            }
        }

		return result
    }


}

