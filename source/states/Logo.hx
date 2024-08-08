package states;

import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxState;
import states.TitleScreen;
/**
 * date: 18/04/2024
 * 
 * Presentazione logo della scuola "I.T.E.S A.Fraccacreta"
 * 
 * Funzioni disponibili:
 * - Nulla, visualizza il logo e basta
 */
class Logo extends FlxState {

    /* SPRITES */
    var ites_logo:FlxSprite;

    /* SOUNDS */
    var coinSound:FlxSound;

    override function create() {
        super.create();

        /* INPUT */
        FlxG.keys.enabled = true;
        // FlxG.mouse.enabled = false;

        /* texture logo 'I.T.E.S A.Fraccacreta' */
		var ites_logo:FlxSprite = new FlxSprite(Paths.image("title_logo/ites_logo"));
        ites_logo.visible = false;
        add(ites_logo);

        /* suono della moneta */
        coinSound = new FlxSound().loadEmbedded(Paths.sound('logo/coin'), false);

        /* timer per inizializzare il gioco */
        new FlxTimer().start(4, function(tmr:FlxTimer) {

            /* timer con il quale inizia la presentzione del logo */
		    new FlxTimer().start(0.5, function(tmr:FlxTimer)
            {
                /* fade-in (nero) della camera */
                FlxG.camera.fade(FlxColor.BLACK, 1, true, removeEv);
                
                /* funzione per rendere il logo visibile */
                ites_logo.visible = true;
            });
            
        });
    }

    /* funzione con la quale inizierà il fade-out del logo */
    function removeEv() {

        /* emana suono */
        coinSound.play();
        
        /* timer il quale lascerà il logo visibile per 1 secondo */
        new FlxTimer().start(0.5, function(tmr:FlxTimer) {

            /* timer con il quale avviene il fade-out della camera */
            new FlxTimer().start(0.5, function(tmr:FlxTimer) {

                /* fade-out della camera */
				FlxG.camera.fade(FlxColor.BLACK, 1, false, funcNextState);
            });

        });
    }

    /* funzione con la quale si procede al Menu */
    function funcNextState() {

        /* passa allo state della schermata del Titolo */
        FlxG.switchState(new TitleScreen());
    }
    
    override function update(elpased:Float) {
        super.update(elpased);
    }
}