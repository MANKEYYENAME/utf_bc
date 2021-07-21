module utf_bc.utf8;

import utf_bc.formats;
import utf_bc.utils;

@nogc nothrow:

pragma(inline)
dchar decodeChar(TextFormat format: TextFormat.UTF_8)(uint c, ref FormatError err) 
	pure
	do{
		auto byte_count = codeLength!format(ubyteFrom!0(c));
		switch(byte_count){
			case 1:	
				return cast(dchar) ubyteFrom!0(c);
			case 2:
				uint result;
				result = ubyteFrom!0(c) & 0b1_1111;
				result <<= 6;
				result |= ubyteFrom!1(c) & 0b11_1111;
				return cast(dchar) result;
			case 3:
				uint result;
				result = ubyteFrom!0(c) & 0b1111;
				result <<= 6;
				result |= ubyteFrom!1(c) & 0b11_1111;
				result <<= 6;
				result |= ubyteFrom!2(c) & 0b11_1111;
				return cast(dchar) result;
			case 4:
				uint result;
				result = ubyteFrom!0(c) & 0b111;
				result <<= 6;
				result |= ubyteFrom!1(c) & 0b11_1111;
				result <<= 6;
				result |= ubyteFrom!2(c) & 0b11_1111;
				result <<= 6;
				result |= ubyteFrom!3(c) & 0b11_1111;
				return cast(dchar) result;
			default: 
				err = FormatError.UTF8_invlaidStartOctet;
				return 0;
		}
	}

pragma(inline) 
size_t codeLength(TextFormat format: TextFormat.UTF_8)(char c) 
	pure
	do{
		if(c >> 7 == 0) return 1;
		else if(c >> 5 == 0b110) return 2;
		else if(c >> 4 == 0b1110) return 3;
		else if(c >> 3 == 0b11110) return 4;
		else return 0;
	}

pragma(inline) 
size_t codeLength(TextFormat format: TextFormat.UTF_8)(dchar c) 
	pure
	do{
		if(c <= 0x7F) return 1;
		else if(c < 0x7FF) return 2;
		else if(c < 0xFFFF) return 3;
		else if(c >= 1_112_064) return 0;
		else return 4;
	}

pragma(inline)
uint encodeChar(TextFormat format: TextFormat.UTF_8)(dchar c, ref FormatError err) 
	pure
	do{
		auto byte_count = codeLength!format(c);
		switch(byte_count){
			case 1:	
				return cast(uint) c;
			case 2:
				uint result;
				ubyteFrom!0(result) = cast(ubyte) ((c >> 6 )) | 0b110_00000;
				ubyteFrom!1(result) = cast(ubyte)((c >> 0 ) & 0b11_1111) | 0b10_000000;
				return result;
			case 3:
				uint result;
				ubyteFrom!0(result) = cast(ubyte) ((c >> 12)) | 0b1110_0000;
				ubyteFrom!1(result) = cast(ubyte) ((c >> 6 ) & 0b11_1111) | 0b10_000000;
				ubyteFrom!2(result) = cast(ubyte) ((c >> 0 ) & 0b11_1111) | 0b10_000000;
				return result;
			case 4:
				uint result;
				ubyteFrom!0(result) = cast(ubyte) ((c >> 18)) | 0b11110_000;
				ubyteFrom!1(result) = cast(ubyte) ((c >> 12) & 0b11_1111) | 0b10_000000;
				ubyteFrom!2(result) = cast(ubyte) ((c >> 6 ) & 0b11_1111) | 0b10_000000;
				ubyteFrom!3(result) = cast(ubyte) ((c >> 0 ) & 0b11_1111) | 0b10_000000;
				return result;
			default: 
				err = FormatError.CodeIsBig;
				return 0;
		}
	}	