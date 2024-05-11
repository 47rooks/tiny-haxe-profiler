# tiny-haxe-profiler
Small simple profiler for Haxe

## Building HL/C

### Manually from the command line

Run the build-hlc.hxml to generate the C source

`haxe build.hlc.hxml`

Then run the following from a VS2022 Powershell - you need the dev setup to get to the compiler and linker
First set the HASHLINK environment variable to point to your Hashlink install directory.

```
$env:HASHLINK = "D:\Program Files\HashLink1.14\"
cl.exe /Ox /Feexport\hlc\TestMain.exe -I $env:HASHLINK\include -I "export\hlc" "export\hlc\main.c" $env:HASHLINK\libhl.lib .\lib\tpLib\x64\Debug\tpLib.lib
```

### Visual Studio

Follow the setup for HL/C define in reference [1] below.

After running build-hlc.hxml open a Visual Studio Developer Powershell and set the HASHLINK environment variable.

```
haxe --main TestMain --hl export/hlc/main.c -D hlgen.makefile=vs2019 -p src -p lib -p tests -lib utest

$env:HASHLINK = "D:\Program Files\HashLink1.14\"
cd export\hlc
devenv.exe main.sln
```

When the solution opens it will ask to upgrade it to VS 2022 (or whatever version you are using if it's later than VS 2019). Let it upgrade.

Modify the solution propeties to set
   1. the VC++ Directories -> Library Directories to include `<Project Dir>/lib/tpLib/x64/Debug` to it can find tpLib.

Then build the solution and it will create a `main.exe`.

## Using this haxelib in a project

If you use a local haxelib in your project you will need to set HAXEPATH to the project directory, the
directory containing `.haxelib` before running the build. This is due to issue https://github.com/HaxeFoundation/haxelib/issues/618.

## References

[1] https://haxe.org/manual/target-hl-c-compilation.html

  The official instructions.

[2] https://gist.github.com/Yanrishatum/d69ed72e368e35b18cbfca726d81279a

  A helpful Gist that explains how to do this from the command line on Windows and Linux.
