module utf_bc;
import core.stdc.stdio;

public import utf_bc.ascii: decodeChar, codeLength, encodeChar;
public import utf_bc.utf8: decodeChar, codeLength, encodeChar;
public import utf_bc.utf16: decodeChar, codeLength, encodeChar;
public import utf_bc.utf32: decodeChar, codeLength, encodeChar;

nothrow @trusted:

public import utf_bc.formats;

auto decode(TextFormat format, bool check_size = true)
	(const(typeForTextFormat!format)[] slice) 
	@nogc 
	pure
	do{
		alias Tchar = typeForTextFormat!format;
		struct EncodeRange{
			@nogc nothrow @trusted:

			const(void)[] slice_;
			protected size_t pos = 0;
			public FormatError err = FormatError.None;


			pragma(inline)
			uint dword() const pure{
				uint i;
				static if(check_size){
					size_t diff = slice_.length - pos;
					if(diff == 3){
						i = (cast(ushort*) (slice_.ptr + pos))[0];
						(cast(ubyte*)&i)[2] = (cast(ubyte*) (slice_.ptr + pos))[2];
					}
					else if(diff == 2) i = (cast(ushort*) (slice_.ptr + pos))[0];
					else if(diff == 1) i = (cast(ubyte*) (slice_.ptr + pos))[0];
					else i = (cast(uint*) (slice_.ptr + pos))[0];
				}
				else i = (cast(uint*) (slice_.ptr + pos))[0];
				return i;
			}

			dchar front() pure{
				return this.dword().decodeChar!format(err);
			}

			void popFront() pure{
				auto a = cast(Tchar*) (slice_.ptr + pos);
				pos += (*a).codeLength!format;
			}

			bool empty() const pure{
				return slice_.length <= pos;
			}
		}
		 
		static if(!check_size) 
			if(slice.length % 4 != 0) 
				debug return EncodeRange([]);

		return EncodeRange(slice);
	}


template encode(TextFormat format, A, bool allacator_is_static, Range)
	{
		enum enocde_body(string allacator)=
			"
				ubyte[] a;
				a = cast(ubyte[]) "~allacator~".allocate(16);
				size_t pos;
				void append(size_t size, uint data){
					while(a.length < pos + 4){
						auto bred = cast(void[]) a;
						"~allacator~".reallocate(bred, a.length * 2);
						a = cast(ubyte[]) bred;
					}
					*(cast(uint*)&a[pos]) = data;
					pos += size;
				}
				foreach(r; range){
					append(r.codeLength!format, r.encodeChar!format(err));
				}
				a = a[0..pos];
				return a;
			";

		static if(allacator_is_static){
			void[] encode(Range range, ref FormatError err)
				do{
					mixin(enocde_body!"A");
				}
		}
		else{
			void[] encode(Range range, ref A allacator, ref FormatError err)
				do{
					mixin(enocde_body!"allacator");
				}
		}
		

	}

template convert(TextFormat FromFormat, TextFormat ToFormat, A, bool allacator_is_static, bool check_size = true){
	static assert(FromFormat != ToFormat);
	alias getRange = (slice) => decode!(FromFormat, check_size)(slice);
	static if(allacator_is_static){
		typeForTextFormat!(ToFormat)[] 
		 convert(const(typeForTextFormat!(FromFormat))[] slice, ref FormatError err){
			return cast(typeForTextFormat!(ToFormat)[]) 
				encode!(ToFormat, A, true, typeof(getRange(slice)))(getRange(slice), err);
		}
	}
	else{
		typeForTextFormat!(ToFormat)[] 
		 convert(const(typeForTextFormat!(FromFormat))[] slice, A allacator, ref FormatError err){
			return cast(typeForTextFormat!(ToFormat)[]) 
				encode!(ToFormat, A, false, typeof(getRange(slice)))(getRange(slice), allacator, err);
		}
	}
}

dchar charAt(TextFormat format, bool check_size = true)
	(const(typeForTextFormat!format)[] slice, size_t position)
	pure
	@nogc 
	do{
		size_t i = 0;
		auto range = decode!(format, check_size)(slice);
		foreach(c; range){
			debug if(range.err != FormatError.None) return 0;
			if(i == position) return c;
			i++;
		}
		return '\0';
	}

size_t codePointsCount(TextFormat format, bool check_size = true)
	(const(typeForTextFormat!format)[] slice)
	@nogc 
	pure
	do{
		size_t i = 0;
		auto range = decode!(format, check_size)(slice);
		while(!range.empty){
			debug if(range.err != FormatError.None) return 0;
			range.popFront();
			i++;
		}
		return i;
	}