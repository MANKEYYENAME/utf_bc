module utf_bc.ascii;

import utf_bc.formats;
import utf_bc.utils;

@nogc nothrow:

pragma(inline)
dchar decodeChar(TextFormat format: TextFormat.ASCII)(uint c, ref FormatError err) 
	pure
	do{
		return cast(char) ubyteFrom!0(c);
	}

pragma(inline) 
size_t codeLength(TextFormat format: TextFormat.ASCII)(char c) 
	pure
	do{
		return 1;
	}

pragma(inline) 
size_t codeLength(TextFormat format: TextFormat.ASCII)(dchar c) 
	pure
	do{
		return 1;
	}

pragma(inline)
uint encodeChar(TextFormat format: TextFormat.ASCII)(dchar c, ref FormatError err) 
	pure
	do{
		debug if(c > 255){
			err = FormatError.CodeIsBig;
			return 0;
		}
		return cast(byte) c;
	}