package tinyprofiler;

/**
 * The EventId class is populated from the <config>.json file by a
 * build macro. These symbols are then used in your profiler invocation
 * functions.
 */
@:build(tinyprofiler.Macros.createEventIds())
@:keep class EventId {}