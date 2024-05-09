package;

import tinyprofiler.Timing;
import utest.Assert;
import utest.Test;

/**
 * Unit tests for the Timing class.
 */
class TimingTests extends Test {
	public function testHRTime() {
		var hrt = Timing.get_hirestime();
		trace('hrt=${hrt}');
		Assert.isTrue(hrt > 0);
	}
}
