package tinyprofiler;

import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType.FFun;
import haxe.macro.Expr;
import haxe.ValueException;

using haxe.macro.ExprTools;
using haxe.macro.MacroStringTools;
using StringTools;

/**
 * Structures to read the JSON configuration file.
 */
typedef EventData = {
	var symbol:String;
	var displayName:String;
}

/**
 * The top level configuration file data structure.
 */
typedef ConfigData = {
	var events:Array<EventData>;
}

/**
 * Read and parse the configuration file and handle errors.
 * 
 * @return ConfigData
 */
function readConfigFile():ConfigData {
    #if macro
    var cfgFilePath = haxe.macro.Context.definedValue('tiny-profiler-cfg-file');
    cfgFilePath = cfgFilePath.trim();
    if (cfgFilePath.startsWith('"')) {
        cfgFilePath = cfgFilePath.replace('"', '');
    }
    if (cfgFilePath.startsWith("'")) {
        cfgFilePath = cfgFilePath.replace("'", "");
    }
    #else
    var cfgFilePath = null;
    #end
    if (cfgFilePath == null) {
        return null;
    }
    var data;
    try {
        var content = sys.io.File.getContent(cfgFilePath);
        data = Json.parse(content);
    } catch (ve:ValueException) {
        if (ve.message != null) {
            throw('Got error processing ${cfgFilePath}.\n${ve}');
        }
        throw ve;
    }
    return data;
}

/**
 * Create EventId constants from the configuration file.
 * Ids are monotonically increasing from 0. They are intended
 * to be used as array indexes.
 * 
 * @return Array<Field>
 */
macro function createEventIds():Array<Field> {
    var data = readConfigFile();
	var metricId = 0;
	var fields = Context.getBuildFields();

	var eventsConstFields = new Array<Field>();
    if (!Reflect.hasField(data, "events")) {
        throw "No 'events' property found in configuration file.";
    }
	for (evt in data.events) {
		// Add final constants of symbol = metricId++
		eventsConstFields.push({
			name: evt.symbol,
			access: [Access.APublic, Access.AStatic, Access.AFinal],
			kind: FieldType.FVar(macro :Int, macro $v{metricId++}),
			pos: Context.currentPos()
		});
	}
	fields = fields.concat(eventsConstFields);
	return fields;
}

/**
 * Create the initializer code for the eventNames list mapping the symbol
 * to its displayName. These must be mapped in the same order as
 * EventIds so that event ids can use the correct displayName in 
 * profiler output.
 * 
 * @return Expr
 */
macro function createInitializer():Expr {
    var data = readConfigFile();
	var rv = new Array<Expr>();
    var idx = 0;
	for (evt in data.events) {
        var sArr = new Array<String>();
        sArr.push('EventId');
        sArr.push(evt.symbol);
        var d = '${evt.displayName}';
        rv.push(macro { eventNames[$p{sArr}] = $e{d.formatString(Context.currentPos())}; });
	}

	return macro $b{rv};
}

function printExpr(e:Expr) {
    switch(e.expr){
        case EArray(a,b):
            trace('$e');
            ExprTools.iter(a, printExpr);
            ExprTools.iter(b, printExpr);
        case EBinop(_,a,b):
            trace('$e');
            ExprTools.iter(a, printExpr);
            ExprTools.iter(b, printExpr);
        case _:
            trace('$e');
    }
}
