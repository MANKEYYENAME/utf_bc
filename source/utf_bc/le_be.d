module utf_bc.le_be;

enum Endian{Big, Little}
@nogc nothrow @trusted:

version(LittleEndian) enum Endian systemEndian = Endian.Little;
else enum Endian systemEndian = Endian.Big;

pragma(inline)
uint reverseEndian(uint e)
	pure
	do{
		uint result;
		uint temp = result;
		(cast(byte*)&result)[0] = (cast(byte*)&temp)[3];
		(cast(byte*)&result)[1] = (cast(byte*)&temp)[2];
		(cast(byte*)&result)[2] = (cast(byte*)&temp)[1];
		(cast(byte*)&result)[3] = (cast(byte*)&temp)[0];
		return result;
	}

pragma(inline)
ushort reverseEndian(ushort e)
	pure
	do{
		ushort result;
		ushort temp = result;
		(cast(byte*)&result)[0] = (cast(byte*)&temp)[1];
		(cast(byte*)&result)[1] = (cast(byte*)&temp)[0];
		return result;
	}

pragma(inline)
auto fromEndian(Endian en, T)(T e) 
	pure 
	do{
		static if(en != systemEndian) return e.reverseEndian;
		else return e;
	}
