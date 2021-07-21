import std.stdio;
import utf_bc;
import std.conv;
import std.experimental.allocator.gc_allocator;

void main(){
	assert("english русский €€ 𐍈𐍈".codePointsCount!(TextFormat.UTF_8) == 21);
	assert("english русский €€ 𐍈𐍈"w.codePointsCount!(TextFormat.UTF_16) == 21);
	assert("english русский €€ 𐍈𐍈"d.codePointsCount!(TextFormat.UTF_32) == 21);
	assert("nй€𐍈".charAt!(TextFormat.UTF_8)(0) == 'n');
	assert("nй€𐍈"w.charAt!(TextFormat.UTF_16)(1) == 'й');
	assert("nй€𐍈"d.charAt!(TextFormat.UTF_32)(2) == '€');
	assert("nй€𐍈"w.charAt!(TextFormat.UTF_16)(3) == '𐍈');
	FormatError err;
	auto utf8_string = cast(char[]) 
		encode!(TextFormat.UTF_8, typeof(GCAllocator.instance), false, dstring)
			("Hello, World!"d, GCAllocator.instance, err);
	writeln(utf8_string);
}
