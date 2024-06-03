package;

import tinyprofiler.TinyProfiler.tpEnterFunc;
import tinyprofiler.TinyProfiler.tpExitFunc;
import tinyprofiler.TinyProfiler.tpInit;

/**
 * Simple test class to test build macros with.
 */
class Main {
	static public function main() {
        trace('macrotestproject Main running');
        tpInit();
		tpEnterFunc(1);
        tpExitFunc(1);
        trace('macrotestproject Main ending');
    }
}