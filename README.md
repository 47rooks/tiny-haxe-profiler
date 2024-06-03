# tiny-haxe-profiler
A small simple profiler for Haxe.

This is a very simple, very lightweight and very manual profiling tool. The key
features are that it can run in any target, though not all are implemented yet,
and that it provide microsecond resolution timing. It does this through externs
in C++ to access the RDTSC tick counter. Thus the absolute count value is not
related to wallclock time and only differences between times are useful.

Instrumention at present is entirely manual. Macro support will eventually come
if this has any legs.

There are now high resolution timers on js as yet. And only Windows is
implemented. However, it should be easy to add this in the future,
again, if there is any longevity in this project.

## To Do

Full disclosure - this isn't ready for public use yet which is why there
is no published haxelib.

Things to do to make it barely useful

   * support multi-threading
     * this will likely require converting to a class based model
   * support caller defining output file
   * add example program using this
   * change tpEnterFunc, tpExitFunc to tpStartTiming, tpEndTiming
  
Later things to add

   * add macro based instrumentation
     * from manually inserted metadata
     * from a file listing what to instrument
   * support micro-second timing in JS
   * support output file in JS
  
Much later if it's still interesting

   * support for the new Perfetto UI

## Configuration File
You will need to set up a configuration file somewhere to define the symbolic
and display names for the events you want to measure. An event is anything
that you measure a start and end time for. It could be function execution,
so that you would tag entry to and exit from the function. It could just be
a section of code within a function.

A configuration file has a very simple JSON format. An example

```
{
    "events": [
        { "symbol": "ON_ENTER_FRAME",
          "displayName": "flixel.FlxGame.onEnterFrame"},
        { "symbol": "UPDATE",
          "displayName": "flixel.FlxGame.update"},
        { "symbol": "DRAW",
          "displayName": "flixel.FlxGame.draw"},
        { "symbol": "QUADTREE_DESTROY",
          "displayName": "flixel.system.FlxQuadTree.destroy"},
        { "symbol": "FLXSPRITE_DRAW",
          "displayName": "flixel.FlxSprite.draw"}
    ]
}
```

Save this configuration somewhere in your project and then provide the 
compiler with this flag to tell it where it is.

```
-D tiny-profiler-cfg-file="D:\\my-project\\tp.json"
```

The file name path may be fully quoted with single or double quotes, to handle
spaces, or may be unquoted. This can be a relative or an absolute path.
If relative the path is evaluated relative to the directory the compile
is running from - the current working directory.

The symbol names are what you will refer to in your instrumentation calls, and
the displayName is what will appear in the output logs or graphs. It is entirely
up to you what they are, though the symbol must be a valid Haxe identifier.

## Instrumenting Code
Before any entry and exit calls can be marked `TinyProfiler.tpInit()` must
be called.

The `TinyProfiler.tpEnterFunc()` and `TinyProfiler.tpExitFunc()` functions
take an EventId as a parameter. These are the event symbols from the
configuration file. As these are compiled into the program as symbols via
macros, they will produce compilation errors if you mistype, so it should
be straightforward to find any errors. You must import `tinyprofiler.EventId`
and access them in your code like this

```
tpEnterFunc(EventId.FLXSPRITE_DRAW);
```

Function entry and exit are instrumented by calling `TinyProfiler.tpEnterFunc()` 
at the top of the function, and `TinyProfiler.tpExitFunc()` at all exit points
of the function.

## Dumping the Profiling Data

Dump to a Chrome tracing compatible file is supported by must be requested in
the code by calling `TinyProfiler.tpOutputChromeTracing()`. This will only dump
a single file name currently but that will change soon.

Currently the following platforms and targets are tested and known to work.

|Target|Platform|Status|Comments|
|-|-|-|-|
|cpp|Windows|OK
|hl|Windows|OK
|hl/c|Windows|OK
|js|Windows|OK|js should work on any platform

Build support exists for HXCPP and Lime builds. For HL, Lime has enough tooling
in place to copy the required extern library to the application output location.
For a simple HL build outside of Lime there is no such support and you will
need to copy the `tpLib.hdll` from the haxelib location
`tiny-profiler\ndll\<Platform>` to your output manually.