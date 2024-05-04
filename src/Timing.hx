package;

import haxe.Int64;
import haxe.Timer;
#if hl
import hl.I64;
#end

/**
 * Timing is the wrapper class for externs for the low level timing functions required for profiling.
 * Externs/extensions are expected to be written by platform and target as required.
 */
#if cpp
@:include("..\\..\\..\\lib\\tpLib\\timing.h")
@:buildXml('
    <target  id="haxe">
    <lib name="..\\..\\..\\lib\\tpLib\\x64\\Debug\\tpLib.lib"/>
	</target>
')
@:native("Timing")
extern class Timing {
	/**
	 * Get microsecond times for C++.
	 * 
	 * Absolute values cannot be mapped to any calendar time
	 * and only intervals between values are meaningful.
	 * 
	 * @return Int64 number of microseconds. 
	 */
	@:native("Timing::get_hirestime") public static function get_hirestime():Int64;
}
#elseif hl
@:hlNative("tpLib")
class Timing {
	public function new() {}

	/**
	 * Get microsecond times for HL/JIT and HL/C.
	 * 
	 * Absolute values cannot be mapped to any calendar time
	 * and only intervals between values are meaningful.
	 * 
	 * @return hl.I64 which will seamlessly cast to Int64 on return.
	 */
	@:native("hl_get_hirestime") public static function get_hirestime():I64 {
		return 0;
	}
}
#else
class Timing {
	/**
	 * Get microsecond times for all other targets.
	 * Note that the precision is microsecond but the resolution is likely far less,
	 * generally millisecond.
	 * 
	 * Absolute values cannot be mapped to any calendar time
	 * and only intervals between values are meaningful.
	 * 
	 * @return Int64
	 */
	public static function get_hirestime():Int64 {
		return Math.floor(Timer.stamp() * 1000000.0);
	}
}
#end
