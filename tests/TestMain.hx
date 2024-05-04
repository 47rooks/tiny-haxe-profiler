package;

import utest.Runner;

class TestMain {
	public static function main() {
		var runner = new Runner();
		runner.addCase(new TimingTests());
		runner.addCase(new TinyProfilerTests());
		runner.run();
	}
}
