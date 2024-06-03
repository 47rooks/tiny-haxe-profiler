package;

import sys.io.Process;
import utest.Assert;
import utest.Test;

typedef SubpResponse = {
    var rc:Int;          // the returncode from the build subprocess
    var stdout:String;   // the stdout captured from the subprocess
    var stderr:String;   // the stderr captured from the subprocess
}

/**
 * Unit tests for the tinyprofiler.Macros class.
 */
@:access(TinyProfiler)
class MacrosTests extends Test {
    /**
     * Run a build in the macrotestproject and capture result.
     * @param additionalArgs an Array<String> containing additional compiler
     * flags to be used. Each string that is separated by a space from the 
     * next is a separate array element. For example,
     * '-D tiny-profiler-cfg-file=.\\noeventscfg.json' must be passed as
     * ['-D', 'tiny-profiler-cfg-file=.\\noeventscfg.json']
     * @return SubpResponse the result of the build command execution
     */
    function runbuildtest(additionalArgs:Array<String> = null):SubpResponse {
        var cwd = Sys.getCwd();
        var rc;
        var out;
        var err;
        try {
            Sys.setCwd('./tests/data/macrotestproject');
            var cmd = 'haxe';
            var args = ['.\\buildtestproject-hl.hxml'];
            if (additionalArgs != null) {
                args = args.concat(additionalArgs);
            }
            var proc = new Process(cmd, args);
            rc = proc.exitCode();
            out = proc.stdout.readAll().toString();
            err = proc.stderr.readAll().toString();
        } catch (e) {
            if (cwd != null) {
                Sys.setCwd(cwd);
                cwd = null;
            }
            throw e;
        }
        if (cwd != null) {
            Sys.setCwd(cwd);
        }
        return {rc:rc, stdout:out, stderr:err};
    }

    public function testConfigBadJSON() {
        var resp = runbuildtest(['-D',
                                 'tiny-profiler-cfg-file=.\\badcfg.json']);

        Assert.equals(1, resp.rc);
        Assert.equals("", resp.stdout);
        Assert.stringContains("Invalid char 93 at position 36", resp.stderr);
    }

    public function testConfigNoEvents() {
        var resp = runbuildtest(['-D',
                                 'tiny-profiler-cfg-file=.\\noeventscfg.json']);

        Assert.equals(1, resp.rc);
        Assert.equals("", resp.stdout);
        Assert.stringContains("No 'events' property found in configuration",
                              resp.stderr);        
    }

    public function testConfigGood() {
        var resp = runbuildtest(['-D',
                                 'tiny-profiler-cfg-file=.\\tp.json']);

        Assert.equals(0, resp.rc);
        Assert.equals("", resp.stdout);
        Assert.equals("", resp.stderr);
    }

    public function testBadConfigPath() {
        var resp = runbuildtest(['-D',
                                 'tiny-profiler-cfg-file=.\\nonexistent.json']);

        Assert.equals(1, resp.rc);
        Assert.equals("", resp.stdout);
        Assert.stringContains('Could not read file .\\nonexistent.json',
                              resp.stderr);
    }

    public function testUnquotedConfigPath() {
        var resp = runbuildtest(['-D',
                                 'tiny-profiler-cfg-file=.\\tp.json']);

        Assert.equals(0, resp.rc);
        Assert.equals("", resp.stdout);
        Assert.equals("", resp.stderr);
    }

    public function testSingleQuotedConfigPath() {
        var resp = runbuildtest(['-D',
                                 "tiny-profiler-cfg-file='.\\tp.json'"]);

        Assert.equals(0, resp.rc);
        Assert.equals("", resp.stdout);
        Assert.equals("", resp.stderr);
    }

    public function testDoubleQuotedConfigPath() {
        var resp = runbuildtest(['-D',
                                 'tiny-profiler-cfg-file=".\\tp.json"']);

        Assert.equals(0, resp.rc);
        Assert.equals("", resp.stdout);
        Assert.equals("", resp.stderr);
    }
}