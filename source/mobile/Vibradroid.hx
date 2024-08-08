package mobile;

import lime.system.JNI;
/**
 * autore@ Nicolás Capel
 * data: 13 Gennaio 2019
 * 
 * consente al gioco di far vibrare il tuo dispositivo Android
 */
class Vibradroid {
	
	private static var __Vibrate:Int->Void = function(duration:Int) { return; };
	private static var __VibrateIndefinitely:Void->Void = function() { return; };
	private static var __VibratePatterns:Dynamic->Int->Void = function(pattern:Array<Int>, repeat:Int) { return; };

	public static function Vibrate(duration:Int):Void
	{
		__Vibrate = JNI.createStaticMethod("vibradroid.Vibradroid", "Vibrate", "(I)V");
		__Vibrate(duration);
	}

	public static function VibrateIndefinitely():Void
	{
		__VibrateIndefinitely = JNI.createStaticMethod("vibradroid.Vibradroid", "VibrateIndefinitely", "()V");
		__VibrateIndefinitely();
	}

	public static function VibratePatterns(pattern:Array<Int>, repeat:Int = 0):Void
	{
		__VibratePatterns = JNI.createStaticMethod("vibradroid.Vibradroid", "VibratePatterns", "([II)V");
		__VibratePatterns(pattern, repeat);
	}

}