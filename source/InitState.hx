package;

import states.TitleScreen;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData.TransitionTileData;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
/**
 * autore@ Francesco Pio Pipino
 * date: 13/07/2024
 * 
 * State con cui inizia il gioco.
 * Svolge le seguenti funzioni:
 * - Inizializza parte del codice del gioco (transizione tra i menu, etc.)
 * - Determina alcune caratteristiche/impostazioni da mantenere
 */
class InitState extends FlxState {

    public override function create():Void {

        // primissimo codice che verrà eseguito all'avvio
        trace('Inizializzazione in corso...');
        
        // qui verrà impostata molta roba
        impostaGioco();

        // conclusa l'impostazione precedente, avvia il gioco
        avviaGioco();
    }

    function impostaGioco():Void {
        // il gioco deve mantenere alta qualità
        // FlxSprite.defaultAntialiasing = true;

        // rimuovi i tasti default per regolare il volume
        FlxG.sound.volumeUpKeys = []; // +
        FlxG.sound.volumeDownKeys = []; // -
        FlxG.sound.muteKeys = []; // 0

        // Imposta il gioco in modo che le prestazioni scalino in caso sia in background
        FlxG.game.focusLostFramerate = 30; // in background, andrà a 30 fps

        /* Abilita mouse (e quindi anche il touch) */
        FlxG.mouse.enabled = true;

        /* TRANSIZIONE FLIXEL */
        // Diamond Transition
        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
        diamond.persist = true;
        diamond.destroyOnNoUse = false;

        // NOTE: tileData is ignored if TransitionData.type is FADE instead of TILES.
        var tileData:TransitionTileData = {asset: diamond, width: 32, height: 32};

        FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), tileData,
        new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
        FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), tileData,
        new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

        /* IMPOSTAZIONI ANDROID */
        #if android
        FlxG.android.preventDefaultKeys = [flixel.input.android.FlxAndroidKey.BACK];
        #end
    }

    /* dopo aver impostato parte della game's data, avvia il gioco definitivamente */
    function avviaGioco():Void {
        // lei non può mancare
        trace("Ciao Viviana");

        /* passa allo state successivo */
        FlxG.switchState(new states.Logo());
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}