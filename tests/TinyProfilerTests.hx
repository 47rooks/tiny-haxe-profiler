package;

import TinyProfiler.EventType;
import TinyProfiler.events;
import TinyProfiler.tpEnterFunc;
import TinyProfiler.tpExitFunc;
import utest.Assert;
import utest.Test;

/**
 * Unit tests for the TinyProfiler class.
 */
@:access(TinyProfiler)
class TinyProfilerTests extends Test {
	public function testTpEnterFunc() {
		tpEnterFunc(1);
		Assert.equals(1, events[0].param);
		Assert.equals(EventType.ENTER_FUNCTION, events[0].param);
	}

	public function testTpExitFunc() {
		tpExitFunc(1);
		Assert.equals(1, events[0].param);
		Assert.equals(EventType.EXIT_FUNCTION, events[0].param);
	}
}
