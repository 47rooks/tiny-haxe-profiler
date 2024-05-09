package tinyprofiler;

import haxe.Int64;
#if sys
import sys.io.File;
#end

/**
 * The event types for which timings may be collected.
 */
enum TPEventType {
	/**
	 * Must be called for each function of interest. Must be paired
	 * with EXIT_FUNCTION events.
	 */
	ENTER_FUNCTION;

	/**
	 * Exit of a function. When instrumenting a function this event should be recorded
	 * at all returns and exception throws. Must be paired with ENTER_FUNCTION events.
	 */
	EXIT_FUNCTION;
}

/**
 * A single event timing record.
 */
@:structInit
class TPEvent {
	public var type:TPEventType;
	public var time:Int64;

	/**
	 * `param` is specific to the event but must be resolvable to a unique event description
	 * when reporting.
	 */
	public var param:Int;
}

/**
 * Define all measurable events. 
 * FIXME - this needs to be constructed some other way. It cannot be hardcoded.
 */
var metricId = 0;

final ON_ENTER_FRAME = metricId++;
final UPDATE = metricId++;
final DRAW = metricId++;
final QUADTREE_DESTROY = metricId++;
final FLXSPRITE_DRAW = metricId++;
var events:Array<TPEvent>;
var eventNames:Array<String>;

function tpInit():Void {
	events = new Array<TPEvent>();
	eventNames = new Array<String>();
	eventNames[ON_ENTER_FRAME] = 'flixel.FlxGame.onEnterFrame';
	eventNames[UPDATE] = 'flixel.FlxGame.update';
	eventNames[DRAW] = 'flixel.FlxGame.draw';
	eventNames[QUADTREE_DESTROY] = 'flixel.system.FlxQuadTree.destroy';
	eventNames[FLXSPRITE_DRAW] = 'flixel.FlxSprite.draw';
}

function tpEnterFunc(param:Int):Void {
	events.push({type: ENTER_FUNCTION, time: Timing.get_hirestime(), param: param});
}

function tpExitFunc(param:Int):Void {
	events.push({type: EXIT_FUNCTION, time: Timing.get_hirestime(), param: param});
}

/**
 * Struct def for the Chrome event format as defined in
 * https://docs.google.com/document/d/1CvAClvFfyA5R-PhYUmn5OOQtYMH4h6I0nSsKchNAySU/edit#heading=h.yr4qxyxotyw
 * 
 * Note, that this is a legacy format now from Google's standpoint. But it is very simple to use.
 */
typedef ChromeTEF = {
	var name:String;
	var cat:String;
	var ph:String;
	var ts:Int64;
	var pid:Int;
	var tid:Int;
}

#if sys
/**
 * Create a Google Trace Event Format output readable with Chrome Tracing.
 * 
 * The dumped file may be view with `chrome://tracing` in the Chrome browser.
 */
function tpOutputChromeTracing():Void {
	var evts:Array<ChromeTEF> = [];
	for (i in 0...events.length) {
		switch (events[i].type) {
			case ENTER_FUNCTION:
				evts.push({
					name: eventNames[events[i].param],
					cat: 'enter',
					ph: 'B',
					ts: events[i].time,
					pid: 0,
					tid: 0
				});
			case EXIT_FUNCTION:
				evts.push({
					name: eventNames[events[i].param],
					cat: 'exit',
					ph: 'E',
					ts: events[i].time,
					pid: 0,
					tid: 0
				});
		}
	}

	var evtFile = File.write('trace.json', false);
	evtFile.writeString('{"traceEvents": [');
	for (i in 0...evts.length) {
		var o = '{"cat":"${evts[i].cat}",';
		o += '"name":"${evts[i].name}",';
		o += '"ph":"${evts[i].ph}",';
		o += '"pid": 0,';
		o += '"tid": 0,';
		o += '"ts":' + evts[i].ts + '}';
		evtFile.writeString(o);
		if (i != evts.length - 1) {
			evtFile.writeString(',');
		}
	}
	evtFile.writeString(']}');
	evtFile.close();
}
#end
