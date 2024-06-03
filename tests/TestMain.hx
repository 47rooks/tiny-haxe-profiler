package;

import utest.Runner;
import utest.ui.Report;

class TestMain {
	public static function main() {
		var runner = new Runner();
		runner.addCase(new TimingTests());
		runner.addCase(new TinyProfilerTests());
		runner.addCase(new MacrosTests());
		Report.create(runner);
		runner.run();
	}
}
