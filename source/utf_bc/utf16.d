module utf_bc.utf16;

import utf_bc.formats;
import utf_bc.le_be;
import utf_bc.utils;

@nogc nothrow:

pragma(inline)
bool isSur(uint c)
	pure
	do{
		ushort first = (cast(ushort*) &c)[0];
		return first >= 0xD800 && first <= 0xDFFF;
	}

pragma(inline)
dchar decodeChar(TextFormat format)(uint c, ref FormatError err) 
	pure
	if(isUTF_16!format)
	do{
		if(!c.isSur) return ushortFrom!0(c);
		else{
			ushort word1 = fromEndian!(getFormatEndian!format)(ushortFrom!1(c));
			ushort word2 = fromEndian!(getFormatEndian!format)(ushortFrom!0(c));
			
			uint result = (word2 & 0x3FF) << 10;
			result |= (word1 & 0x3FF);
			return cast(dchar) result + 0x10000;
		}
	}

pragma(inline) 
size_t codeLength(TextFormat format)(wchar c) pure
	if(isUTF_16!format)
	do{
		return (c >= 0xD800 && c <= 0xDFFF) ? 4 : 2;
	}

pragma(inline) 
size_t codeLength(TextFormat format)(dchar c) pure
	if(isUTF_16!format)
	do{
		return (c < 0x10000) ? 2 : 4;
	}

pragma(inline)
uint encodeChar(TextFormat format)(dchar c, ref FormatError err) 
	pure
	if(isUTF_16!format)
	do{
		debug if(c > MaxUnicodeCode){
			err = FormatError.CodeIsBig;
			return 0;
		}
		if(c < 0x10000) return cast(uint) c;
		else{
			auto c_ = (cast(uint) c) - 0x10000;
			ushort low = c_ & 0x3FF;
			ushort high = cast(ushort) (c_ >> 10);

			uint result;
			ushortFrom!0(result)  = fromEndian!(getFormatEndian!format)(cast(ushort)(high | 0xD800));
			ushortFrom!1(result) = fromEndian!(getFormatEndian!format)(cast(ushort)(low | 0xDC00));
			return result;
		}
	}	