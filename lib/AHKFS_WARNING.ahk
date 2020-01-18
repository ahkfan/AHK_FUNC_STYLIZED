AHKFS_WARNING()
{
	return __AHKFS_WARNING
}

class __AHKFS_WARNING
{
	static line := "`n--------------------------------------------------------------------------------------`n"
	__Call(key)
	{
		Throw Exception(__AHKFS_WARNING.line "   < " this.file " Warning > you try to call none exist method < " key " >!" __AHKFS_WARNING.line )
	}

	__Set(key)
	{
		Throw Exception(__AHKFS_WARNING.line  "   < " this.file " Warning > you try to set key < " key " >!" __AHKFS_WARNING.line )
	}

	__Get(key)
	{
		Throw Exception(__AHKFS_WARNING.line  "   < " this.file " Warning > you try to get key < " key " >!" __AHKFS_WARNING.line )
	}
}