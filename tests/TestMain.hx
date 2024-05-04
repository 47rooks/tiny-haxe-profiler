package;

import utest.Runner;

class TestMain {
	public static function main() {
		var runner = new Runner();
		trace('running timing tests');
		runner.addCase(new TimingTests());
		runner.run();
	}
}
