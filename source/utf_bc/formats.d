module utf_bc.formats;

import utf_bc.le_be;

enum TextFormat{
	ASCII,
	UTF_8,
	UTF_16LE,
	UTF_32LE,
	UTF_16BE,
	UTF_32BE,
	UTF_16 = (systemEndian == Endian.Little) ? UTF_16LE : UTF_16BE,
	UTF_32 = (systemEndian == Endian.Little) ? UTF_32LE : UTF_32BE,
}

enum FormatError{
	None,
	CodeIsBig,
	UTF8_invlaidStartOctet,
}

enum MaxUnicodeCode = 1_112_064;

enum isUTF_16(TextFormat format) = (format == TextFormat.UTF_16LE || format == TextFormat.UTF_16BE);
enum isUTF_32(TextFormat format) = (format == TextFormat.UTF_32LE || format == TextFormat.UTF_32BE);

template getFormatEndian(TextFormat a){
	enum getFormatEndian = {
		static if(a == TextFormat.UTF_16LE || a == TextFormat.UTF_32LE){
			return Endian.Little;
		}
		else static if(a == TextFormat.UTF_16BE || a == TextFormat.UTF_32BE){
			return Endian.Big;
		}
		else static assert(0);
	}();
}

alias typeForTextFormat(TextFormat format) = mixin({
	if(isUTF_16!format) return "wchar";
	else if(isUTF_32!format) return "dchar";
	else if(format == TextFormat.UTF_8 || format == TextFormat.ASCII) return "char";
	else assert(0);
}());