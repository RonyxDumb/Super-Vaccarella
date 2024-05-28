package;

import flixel.util.FlxColor;
import flixel.FlxCamera;
import openfl.Assets;
import openfl.display.FPS;
import openfl.Lib;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.Logo;

/**	
 * date: 27/04/2024
 * Impostazioni generali del gioco
**/
class Main extends Sprite
{
	/* IL GIOCO */
	var game:FlxGame; // il gioco

	/* GRANDEZZA SCHERMO */
	var gameWidht:Int = 320; // grandezza schermo (larghezza)
	var gameHeight:Int = 240; // grandezza schermo (altezza)

	/* FPS */
	var FPS:FPS; // fps

	/* SALTARE HAXEFLIXEL LOGO*/
	var skipSplash:Bool = true; // scegli se saltare o meno l'intro di HaxeFlixel

	/* STATE CON CUI COMINCIA IL GIOCO */
	var initialState:Class<FlxState> = Logo; // inserisci qui lo state con cui inizia il gioco

	/* A QUANTI FRAMERATE DEVE CORRERE IL GIOCO */
	/* se il gioco viene esportato per html5 */
	#if html5
	var framerate:Int = 60; // inserisci a quanti frame dovrebbe girare il gioco
	#else
	/* se il gioco viene esportato per qualunque altra platform */
	var framerate:Int = 120; // inserisci a quanti frame dovrebbe girare il gioco
	#end

	/* CAMERA PRINCIPALE DEL GIOCO */
	private var camera:FlxCamera; // la camera del gioco

	public function new()
	{
		super();

		/* all'avvio del gioco, imposta le impsotazioni del gioco chiamando la funzione apposita */
		setupGame();
	}

	public function main():Void
	{
		Lib.current.addChild(new Main());
	}

	/* funzione che imposta ed applica le impostazioni del gioco */
	private function setupGame():Void
	{
		/* impostazioni del gioco durante l'avvio */
		game = new FlxGame(gameWidht, gameHeight, initialState, framerate, framerate, true, false);
		
		/* applica le impostazioni del gioco aggiungendole */
		addChild(game);

		/* GRANDEZZA SCHERMO */
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var stageWidht:Int = Lib.current.stage.stageWidth;

		/* testo che visualizza a quanti FPS gira il gioco */
		FPS = new FPS(10, 10, FlxColor.WHITE);
		#if !html5
		addChild(FPS);
		#end

		/* all'avvio, carica tutti i suoni */
		FlxG.sound.cacheAll();

		/* all'uscita della finestra, non interrompere il gioco */
		FlxG.autoPause = false;

		/* rendi il mouse inutilizzabile */
		#if html5
		FlxG.mouse.visible = false;
		FlxG.mouse.enabled = false;
		#end

		/////////////////////// OTTIMIZZAZIONE ////////////////////

		/* pulisci cache delle canzoni */
		Assets.cache.clear("music");
		Assets.cache.clear("assets/music");

		/* pulisci cache delle immagini */
		Assets.cache.clear("images");
		Assets.cache.clear("assets/images");

		/* pulisci cache dei suoni */
		Assets.cache.clear("sounds");
		Assets.cache.clear("assets/sounds");

		/* pulisci cache dei dati del gioco */
		Assets.cache.clear("data");
		Assets.cache.clear("assets/data");

		///////////////////////////////////////////////////////////
	}
}