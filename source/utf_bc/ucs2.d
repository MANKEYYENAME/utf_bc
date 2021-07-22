module utf_bc.ucs2;

import utf_bc.formats;
import utf_bc.le_be;
import utf_bc.utils;

@nogc nothrow:

pragma(inline)
dchar decodeChar(TextFormat format)(uint c, ref FormatError err) 
	pure
	if(isUCS_2!format)
	do{
		return cast(dchar) c.ushortFrom!(0).fromEndian!(getFormatEndian!format);
	}

pragma(inline) 
size_t codeLength(TextFormat format)(dchar c) 
	pure
	if(isUCS_2!format)
	do{
		return 2;
	}

pragma(inline) 
size_t codeLength(TextFormat format)(wchar c) 
	pure
	if(isUCS_2!format)
	do{
		return 2;
	}

pragma(inline)
uint encodeChar(TextFormat format)(dchar c, ref FormatError err) 
	pure
	if(isUCS_2!format)
	do{
		debug if(c > ushort.max){
			err = FormatError.CodeIsBig;
			return 0;
		}
		return cast(uint) c.fromEndian!(getFormatEndian!format);
	} 