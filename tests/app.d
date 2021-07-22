import utf_bc;

import std.experimental.allocator.mallocator;

FormatError err;

void main() @safe{
	assert("english русский €€ 𐍈𐍈".codePointsCount!(TextFormat.UTF_8) == 21);
	assert("english русский €€ 𐍈𐍈"w.codePointsCount!(TextFormat.UTF_16) == 21);
	assert("english русский €€ 𐍈𐍈"d.codePointsCount!(TextFormat.UTF_32) == 21);
	assert("nй€𐍈".charAt!(TextFormat.UTF_8)(0) == 'n');
	assert("nй€𐍈"w.charAt!(TextFormat.UTF_16)(1) == 'й');
	assert("nй€𐍈"d.charAt!(TextFormat.UTF_32)(2) == '€');
	assert("nй€𐍈"w.charAt!(TextFormat.UTF_16)(3) == '𐍈');

	static assert(textFormatForType!(wchar) == TextFormat.UTF_16);
	static assert(textFormatForType!(dchar) == TextFormat.UTF_32);
	static assert(textFormatForType!(char) == TextFormat.UTF_8);
	
	@trusted
	auto myencode(TextFormat format)(dstring str) {
		return cast(typeForTextFormat!(format)[]) 
		  encode!(format, typeof(Mallocator.instance), false, dstring)
			(str, Mallocator.instance, err);
	}

	@safe
	auto myconvert(TextFormat from, TextFormat to)(typeForTextFormat!(from)[] slice){
		return convert!(from, to, typeof(Mallocator.instance), false)
			(slice, Mallocator.instance, err);

	}

	@safe
	bool noError(){
		return err == FormatError.None;
	}


	@safe
	void simpleTest(string str)(){
		enum str_8 = str;
		enum str_16 = mixin('"'~str_8~'"'~'w');
		enum str_32 = mixin('"'~str_8~'"'~'d');

		auto result_string8 = myencode!(TextFormat.UTF_8)(str_32);
		assert(result_string8 == str_8);
		assert(noError());

		auto result_string16 = myencode!(TextFormat.UTF_16)(str_32);
		assert(result_string16 == str_16);
		assert(noError());

		enum postfixs = ["8", "16", "32"];

		static foreach(first; postfixs) static foreach(second; postfixs){
			static if(first != second)
			assert(myconvert!(
					mixin("TextFormat.UTF_"~first), 
					mixin("TextFormat.UTF_"~second)
				)
				(mixin("str_"~first).dup) == mixin("str_"~second));
		}
		assert(noError());
	}
	
	static foreach(str; [
		"Hello, World!", 
		"你好，世界！", 
		"Привет, Мир!",
		"Γειά σου Κόσμε!",
		"Hallo Welt!",
		"Bonjour le monde!",
		"ሰማይ አይታረስ ንጉሥ አይከሰስ።
		  ብላ ካለኝ እንደአባቴ በቆመጠኝ።
		  ጌጥ ያለቤቱ ቁምጥና ነው።
		  ደሀ በሕልሙ ቅቤ ባይጠጣ ንጣት በገደለው።
		  የአፍ ወለምታ በቅቤ አይታሽም።
		  አይጥ በበላ ዳዋ ተመታ።
		  ሲተረጉሙ ይደረግሙ።
		  ቀስ በቀስ፥ ዕንቁላል "
	]){
		simpleTest!(str)();
	}
}
