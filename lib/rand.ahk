/* 随机
要是测试通过了记得写个 test pass 的注释
rand(min, max) pass
rand_range(min, max, step := 1) pass
rand_choice(source) pass
rand_shuffle(source) pass
rand_sample(source, num)
*/

; #Include type.ahk		Put this file in lib or include it

class Rand
{
    __New()
    {
        Return Rand
    }
    
    _getLength(item)
    {
        if IsObject(item)
            Return item.Length()
        else
            Return StrLen(item)
    }

    _isInList(value, item)
    {
        for k,v in item
        {
            if v := value
                Return True
        }
        Return False
    }

    Seed(a)
    {
        if a is digit
            Random, , a
        else
            Throw Exception("Seed must be an integer", A_ThisFunc)
        Return this         ; 允许用rand.seed().method()调用
    }

; --------------------- digit methods  --------------------

    Rand(min := 0, max := 2147483647)
    {
        ; 这个方法也允许浮点数
        out := 0
        Random, out, min, max
        Return out
    }

    RandRange(min, max, step := 1)
    {
        ; 返回从"max"到"min"之间的一随机数，间隔为"step"
        ; 只能使用整数
        if min is not digit or max is not digit
            Throw Exception("Min and Max must be an integer", A_ThisFunc)
        out := 0
        Random, out, 0, (max-min) // step
        Return min + out * step
    }

; -------------------- sequence methods  -------------------

    Choice(source)
    {
        ; 随机返回一个在"source"中的元素，字符串时为一个字符
		; 只支持 ahk v1.1.31+

		switch type(source)
		{
			case "Array":
				i := this.Rand(1, source.Length())
            	Return source[i]
			case "Associative Array":
				; 当source是关联数组的情况
        ;   !!!! 这个效率比较低我不知道有没有更好的方法 !!!!
                ; 不要在关联数组比较长的时候使用   
                s2 := []
                for k,v in source
                    s2 := s2.push(k)
                i := this.Choice(s2)
                Return Object(i, source[i]) ; 关联数组的键用{}的方式设置，不能用变量，只好这样了
			case "String":
				i := this.Rand(1, StrLen(source))
            	Return SubStr(source, i, 1)
			Default:
				Throw Exception("Source must an object with lenght", A_ThisFunc)
		} 
    }

    Shuffle(source)
    {
        ; 返回一个顺序被随机打乱的简单数组
		; 只支持 ahk v1.1.31+
		; Fisher–Yates Shuffle
        s2 := New source                    ; 用原型链防止操作影响 source 
		switch type(source)
		{
			case "Array":
				l := source.Length()
            	for k,v in source
            	{
                	j := this.Rand(1, l-k+1)    ; l-k会到0加一让序数从一开始
                	temp := s2[l-k+1]
                	s2[l-k+1] := s2[j]
                	s2[j] := temp
				}
				Return s2
			Default:
				Throw, Exception("Source must be an unempty simple array, not an empty array or associative arrays.", A_ThisFunc)
		}
        /*
        byref 版
        if IsObject(source)
        {
            l := source.Length()
            for k,v in source
            {
                j := this.Rand(1, l-k+1)
                temp := source[l-k+1]
                source[l-k+1] := source[j]
                source[j] := temp
            }
        }
        */
    }
    
    ; TODO: 把这个部分改成可以跑的
    Sample(source, num)
    {
        l := this._getLength(source)
        if num >= l or num <= 0
            Throw Exception("Sample larger than source or is negative", A_ThisFunc)

        ; 这个情况区分的部分是什么道理我也不知道，python官方是这么写的LOL
        result := []
        setsize := 21
        if num > 5
            setsize += 4^(Ceil(Log(num * 3)/Log(4)))
        ; 两个方法
        if l <= setsize
        {
            pool := New source                  ; 用原型链防止对 pool 的操作影响 source 
            Loop %num%
            {
                j := this.Rand(1, l-A_Index+1)
                result.Push(pool[j]) 
                pool[j] := pool[l-A_Index+1]    ; 把用过的用没用过的替换
            }
        }
        else
        {
            select := []
            Loop %num%
            {
                j := this.Rand(1, l-A_Index)
                While (this._isInList(j, select))           ; TODO: 这句只是个表示意思的伪代码
                    j := this.Rand(1, l-A_Index)
                select.Push(j)
                result.Push(source[j]) 
            }
        }
        Return result
    }
}

fsrand(){
    Return Rand
}