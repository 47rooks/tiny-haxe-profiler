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

   * add a client configurable event name table
     * initially this will be set up in tpInit()
   * support multi-threading
     * this will likely require converting to a class based model
   * support caller defining output file
  
Later things to add

   * add macro based instrumentation
     * from manually inserted metadata
     * from a file listing what to instrument
   * support micro-second timing in JS
   * support output file in JS
  
Much later if it's still interesting

   * support for the new Perfetto UI

## Instrumenting Code
FIXME - this is subject to change very soon. At the moment this portion is
not very usable at all and really requires, for any useful case modification
of the event names table, which is obviously not tenable for a real client
program.

Before any entry and exit calls can be marked `TinyProfiler.tpInit()` must
be called.

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
|js|Windows|OK|js should work on any plaform

Build support exists for HXCPP and Lime builds. For HL, Lime has enough tooling
in place to copy the required extern library to the application output location.
For a simple HL build outside of Lime there is no such support and you will
need to copy the `tpLib.hdll` from the haxelib location
`tiny-profiler\ndll\<Platform>` to your output manually.