AHKFS_WARNING()
{
	return __AHKFS_WARNING
}

class __AHKFS_WARNING
{
	__Call(key)
	{
		Throw Exception("<<< " this.file " Warning >>> you try to call none exist method [" key "]!")
	}

	__Set(key)
	{
		Throw Exception("<<< " this.file " Warning >>> you try to set key [" key "]!")
	}

	__Get(key)
	{
		Throw Exception("<<< " this.file " Warning >>> you try to get key [" key "]!")
	}
}