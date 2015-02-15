import std.stdio;

void main() {
	writeln("Type           : ", int.stringof);
    writeln("Length in bytes: ", int.sizeof);
    writeln("Minimum value  : ", int.min);
    writeln("Maximum value  : ", int.max);
    writeln("Initial value  : ", int.init);
    writeln();

    writeln("Type           : ", long.stringof);
    writeln("Length in bytes: ", long.sizeof);
    writeln("Minimum value  : ", long.min);
    writeln("Maximum value  : ", long.max);
    writeln("Initial value  : ", long.init);
    writeln();

    writeln("Type           : ", float.stringof);
    writeln("Length in bytes: ", float.sizeof);
    writeln("Minimum value  : ", float.min_normal);
    writeln("Maximum value  : ", float.max);
    writeln("Initial value  : ", float.init);
    writeln();

    writeln("Type           : ", double.stringof);
    writeln("Length in bytes: ", double.sizeof);
    writeln("Minimum value  : ", double.min_normal);
    writeln("Maximum value  : ", double.max);
    writeln("Initial value  : ", double.init);
    writeln();

    writeln("Type           : ", real.stringof);
    writeln("Length in bytes: ", real.sizeof);
    writeln("Minimum value  : ", real.min_normal);
    writeln("Maximum value  : ", real.max);
    writeln("Initial value  : ", real.init);
    writeln();
}