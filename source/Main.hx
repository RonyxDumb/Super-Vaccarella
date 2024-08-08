package;

import flixel.FlxG;
import debug.MemoryCounter;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;

/**
 * Classe principale che inizializza HaxeFlixel e avvia il gioco nel suo state iniziale.
 */
class Main extends Sprite
{
  var gameWidth:Int = 320; // Larghezza del gioco in pixel (potrebbe essere inferiore/superiore in pixel effettivi a seconda dello zoom).
  var gameHeight:Int = 240; // Altezza del gioco in pixel (potrebbe essere inferiore/superiore in pixel effettivi a seconda dello zoom).
  var initialState:Class<FlxState> = InitState; // FlxState con cui il gioco comincia
  var zoom:Float = -1; // Se -1, lo zoom viene calcolato automaticamente per adattarsi alle dimensioni della finestra.
  #if web
  var framerate:Int = 60; // A quanti fotogrammi per secondo deve correre il gioco (se esportato per web)
  #else
  var framerate:Int = 144; // A quanti fotogrammi per secondo deve correre il gioco (se esportato per qualunque altro target)
  #end
  var skipSplash:Bool = true; // Se saltare la schermata iniziale di flixel che appare nella modalità di rilascio.
  var startFullscreen:Bool = false; // Se avviare il gioco a schermo intero sui target desktop

  public static function main():Void
  {
    Lib.current.addChild(new Main());
  }

  public function new()
  {
    super();

    if (stage != null)
    {
      init();
    }
    else
    {
      addEventListener(Event.ADDED_TO_STAGE, init);
    }
  }

  function init(?event:Event):Void
  {
    if (hasEventListener(Event.ADDED_TO_STAGE))
    {
      removeEventListener(Event.ADDED_TO_STAGE, init);
    }

    setupGame();
  }

  /**
   * Un contatore di fotogrammi mostrato in alto a sinistra.
   */
  public static var fpsCounter:FPS;

  /**
   * Un contatore di RAM mostrato in alto a sinistra.
   */
  public static var memoryCounter:MemoryCounter;

  function setupGame():Void
  {
    // addChild gets called by the user settings code.
    fpsCounter = new FPS(10, 3, 0xFFFFFF);

    // addChild gets called by the user settings code.
    #if !html5
    memoryCounter = new MemoryCounter(10, 13, 0xFFFFFF);
    #end

    var game:FlxGame = new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen);

    addChild(game);

    addChild(fpsCounter);

    addChild(memoryCounter);

    FlxG.mouse.enabled = true;

    #if hxcpp_debug_server
    trace('hxcpp_debug_server attivato! Puoi ora connetterti al gioco con il debugger..');
    #else
    trace('hxcpp_debug_server disattivato! Questa build non supporta debugging.');
    #end
  }
}