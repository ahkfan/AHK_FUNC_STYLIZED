/*随机
rand(min := 0, max := 2147483647)
rand_range(min, max, step := 1)
rand_choice(source)
rand_shuffle(source)
rand_sample(source, num)
*/

rand(min := 0, max := 2147483647)
{
	; 这个方法也允许浮点数
	out := 0
	Random, out, min, max
	Return out
}

rand_range(min, max, step := 1)
{
	; 返回从"max"到"min"之间的一随机数，间隔为"step"
	; 只能使用整数
	out := 0
	Random, out, 0, (max-min) // step
	Return min + out * step
}

; -------------------- sequence methods  -------------------

rand_choice(source)
{
	; 随机返回一个在"source"中的元素，字符串时为一个字符
	if IsObject(source)
	{
		if !source[1]
		{
			; 当source是关联数组的情况
	;   !!!! 这个效率比较低我不知道有没有更好的方法 !!!!
			; 不要在关联数组比较长的时候使用
			s2 := []
			for k,v in source
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

rand_shuffle(source)
{
	; 返回一个顺序被随机打乱的简单数组
	; Fisher–Yates Shuffle
	s2 := New source                    ; 用原型链防止操作影响 source

	if IsObject(source)
	{
	; 如果关联数组包含键 "1" 那么就凉了，有人这么写的话我也没办法
		if !s2[1]
			Throw, Exception("Source must be an unempty simple array, not an empty array or associative arrays.")
		l := source.Length()
		for k,v in source
		{
			j := this.Rand(1, l-k+1)    ; l-k会到0加一让序数从一开始
			temp := s2[l-k+1]
			s2[l-k+1] := s2[j]
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
			j := this.Rand(1, l-k+1)
			temp := source[l-k+1]
			source[l-k+1] := source[j]
			source[j] := temp
		}
	}
	*/
}

rand_sample(source, num)	; TODO: 把这个部分改成可以跑的
{
	l := this._getLength(source)
	if num >= l or num <= 0
		Throw Exception("Sample larger than source or is negative")

	; 这个情况区分的部分是什么道理我也不知道，python官方是这么写的LOL
	result := []
	setsize := 21
	if num > 5
		setsize += 4^(Ceil(Log(num * 3)/Log(4)))
	; 两个方法
	if l <= setsize
	{
		pool := New source                  ; 用原型链防止对 pool 的操作影响 source
		Loop, num
		{
			j := this.Rand(1, l-A_Index+1)
			result[A_Index] := pool[j]
			pool[j] := pool[l-A_Index+1]    ; 把用过的用没用过的替换
		}
	}
	else
	{
		select := []
		Loop, num
		{
			j := this.Rand(1, l-A_Index)
			While (this._isInList(j, select))           ; TODO: 这句只是个表示意思的伪代码
				j := this.Rand(1, l-A_Index)
			select.Push(j)
			result[A_Index] := source[j]
		}
	}
	Return result
}