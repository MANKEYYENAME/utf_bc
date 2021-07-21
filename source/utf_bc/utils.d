module utf_bc.utils;

pragma(inline) pure nothrow @nogc @trusted:

ref ubyte ubyteFrom(size_t at, T)(ref T a)
	do{
		return (cast(ubyte*)&a)[at];
	}

ref ushort ushortFrom(size_t at, T)(ref T a)
	do{
		return (cast(ushort*)&a)[at];
	}