module utf_bc.utf32;

import utf_bc.formats;
import utf_bc.le_be;

@nogc nothrow:

pragma(inline)
dchar decodeChar(TextFormat format)(uint c, ref FormatError err) 
	pure
	if(isUTF_32!format)
	do{
		return cast(dchar) c.fromEndian!(getFormatEndian!format);
	}

pragma(inline) 
size_t codeLength(TextFormat format)(dchar c) 
	pure
	if(isUTF_32!format)
	do{
		return 4;
	}


pragma(inline)
uint encodeChar(TextFormat format)(dchar c, ref FormatError err) 
	pure
	if(isUTF_32!format)
	do{
		return cast(uint) c.fromEndian!(getFormatEndian!format);
	} 