# tiny-haxe-profiler
A small simple profiler for Haxe.

This is a very simple and very manual profiling tool. The key features are that
it can run in any target, though not all are implemented yet, and that it
provide microsecond resolution timing. It does this through externs in C++ to
access the RDTSC tick counter. Thus the absolute count value is not related to
wallclock time and only differences between times are useful.

Instrumention at present is entirely manual. Macro support will eventually come
if this has any legs.

There are now high resolution timers on js as yet. And only Windows is
implemented. However, it should be easy to add this in the future,
again, if there is any longevity in this project.

Dump to a Chrome tracing compatible file is supported by must be requested in
the code by calling `TinyProfiler.tpOutputChromeTracing()`. This will only dump
a single file name currently but that will change soon.

- [tiny-haxe-profiler](#tiny-haxe-profiler)
  - [Structure](#structure)
  - [Building and Running Tests](#building-and-running-tests)
    - [JS](#js)
    - [HL](#hl)
    - [C++](#c)
    - [HL/C](#hlc)
      - [Manually from the command line](#manually-from-the-command-line)
      - [Visual Studio](#visual-studio)
  - [Using this haxelib in a project](#using-this-haxelib-in-a-project)
  - [References](#references)

## Structure

There is an extern layer which currently only has a Windows C++ library to
obtain microsecond resolution timings. Other target and platform implementations
can be added. The `lib\tpLib` directly contains this implementation and is a
Visual Studio 2022 DLL project.

The `tinyprofiler` directory contains the Haxe interface layer in the
`Timing.hx` file and the profiler module `TinyProfiler.hx`.

The project directory contains `hxml` build files for all support targets and
platforms to run the unit tests in the `tests` directory. These are `utest`
tests. All are configured to place output in `export\<target>` directories.

## Building and Running Tests

Before you try to build you will need to install the haxelib in development
mode.

`haxelib dev tiny-profiler <tiny-profiler git clone directory>`

All `build-*./hxml` files set `-D UTEST_PRINT_TESTS` so that the unit tests
are printed as they complete.

### JS

`haxe build-js/hxml`

Load the `index.html` file in the top level directory up in a browser. You
will need to open the browser's developer console to see the test output.

### HL

`haxe build-hl.hxml`

Then `export/hl` will contain `main.hl`. You will need to set PATH to include
the `ndll\Windows64` directory so that the `tpLib.hdll` file can be found. Then
run 

`&"<HASHLINK directory>\hl.exe" export\hl\main.hl`

### C++

`haxe build-cpp.hxml`

The `export\cpp` directory will contain the executables. The `tpLib.dll` will
already have been copied to this directory, so all you need to do is run

`export\cpp\TestMain.exe`

Note: if you have Haxe installed in paths with spaces in them you may well see 
an error after it links the exe, with something like 

`Error: Could not find build target "Files\\HaxeToolkit433\\haxe\\extraLibs/"`

which is the bit after the space in "Program Files". You can usually ignore this
as the exe has already been built. Just check in the `export\cpp` directory.
This is due to a bug in HXCPP command line escaping.

### HL/C

#### Manually from the command line

Run the build-hlc.hxml to generate the C source

`haxe build.hlc.hxml`

Then run the following from a VS2022 Powershell - you need the dev setup to get
to the compiler and linker. First set the HASHLINK environment variable to
point to your Hashlink install directory.

```
$env:HASHLINK = "D:\Program Files\HashLink1.14\"
cl.exe /Ox /Feexport\hlc\TestMain.exe -I $env:HASHLINK\include -I "export\hlc"
 "export\hlc\main.c" $env:HASHLINK\libhl.lib .\lib\tpLib\x64\Release\tpLib.lib
```

Before running it you will either need to copy `ndll\Windows64\tpLib.dll` to the 
`export\hlc` directory or add the
`<tiny-profiler git clone directory>\ndll\Windows64` directory to the PATH
variable.

#### Visual Studio

Follow the setup for HL/C define in reference [1] below.

After running build-hlc.hxml open a Visual Studio Developer Powershell and set
the HASHLINK environment variable.

```
haxe --main TestMain --hl export/hlc/main.c -D hlgen.makefile=vs2019 -p src -p lib -p tests -lib utest

$env:HASHLINK = "D:\Program Files\HashLink1.14\"
cd export\hlc
devenv.exe main.sln
```

When the solution opens it will ask to upgrade it to VS 2022 (or whatever
version you are using if it's later than VS 2019). Let it upgrade.

Modify the solution propeties to set
   1. the VC++ Directories -> Library Directories to include 
   `<Project Dir>/lib/tpLib/x64/Release` to it can find tpLib.

Then build the solution and it will create a `main.exe`.

## Using this haxelib in a project

If you use a local haxelib in your project you will need to set HAXEPATH to the
project directory, the directory containing `.haxelib` before running the build.
This is due to issue https://github.com/HaxeFoundation/haxelib/issues/618.

Note, that all libs are under the `ndll` directory in the standard Lime
arrangment. This is only done because Lime support does not appear to support
pulling ndll/hdlls from a different location though it can pull dlls. But as
HXCPP is flexible enough to handle this, this seems the simplest way to go
without duplicating the libs in the haxelib, well beyond the necssary
duplication already present because `tpLib.dll` and `tpLib.hdll` are the same.

## References

[1] https://haxe.org/manual/target-hl-c-compilation.html

  The official instructions.

[2] https://gist.github.com/Yanrishatum/d69ed72e368e35b18cbfca726d81279a

  A helpful Gist that explains how to do this from the command line on Windows
  and Linux.
