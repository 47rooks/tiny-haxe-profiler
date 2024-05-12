del tiny-profiler.zip
7z a -tzip tiny-profiler.zip ^
    -i!tinyprofiler\* ^
    -i!buildsupport\* ^
    -i!ndll\*^
    -xr!**\*.md ^
    -i!lib\tpLib\timing.h ^
    -i!include.xml ^
    -i!ATTRIBUTIONS.md -i!CHANGELOG.md -i!LICENSE -i!README.md -i!haxelib.json 