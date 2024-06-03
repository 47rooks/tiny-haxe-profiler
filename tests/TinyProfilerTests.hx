package;

import tinyprofiler.TinyProfiler.TPEventType;
import tinyprofiler.TinyProfiler.events;
import tinyprofiler.TinyProfiler.tpEnterFunc;
import tinyprofiler.TinyProfiler.tpExitFunc;
import tinyprofiler.TinyProfiler.tpInit;
import utest.Assert;
import utest.Test;

/**
 * Unit tests for the TinyProfiler class.
 */
@:access(TinyProfiler)
class TinyProfilerTests extends Test {
	public function testTpEnterFunc() {
		tpInit();
		tpEnterFunc(1);
		Assert.equals(1, events[0].param);
		Assert.equals(TPEventType.ENTER_FUNCTION, events[0].type);
	}

	public function testTpExitFunc() {
		tpInit();
		tpExitFunc(1);
		Assert.equals(1, events[0].param);
		Assert.equals(TPEventType.EXIT_FUNCTION, events[0].type);
	}
}
