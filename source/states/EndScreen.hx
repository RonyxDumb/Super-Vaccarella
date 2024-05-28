package states;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.FlxSprite;
import flixel.FlxState;
/**
 * date: 27/05/2024
 */
class EndScreen extends FlxState {

    /* SPRITES */
    var theEndScreen:FlxSprite;
    var underTextBack:FlxSprite;
 
    /* SOUNDS */
    var sparkleSound:FlxSound;
    var mario_thankGame:FlxSound;

    override function create() {
        super.create();

        /* abilita i comandi */
        FlxG.keys.enabled = false;

        /* SOUNDS */
        sparkleSound = new FlxSound().loadEmbedded(Paths.sound('sparkle'), false);
        mario_thankGame = new FlxSound().loadEmbedded(Paths.sound('mario_voice/mario_thankGame'), false);

        /* fade-out (lento) della camera */
        FlxG.camera.fade(FlxColor.BLACK, 5, true);

        /* texture della schermata finale */
        theEndScreen = new FlxSprite().loadGraphic(Paths.image('theEnd/TheEndScreen'));
        theEndScreen.y = 0;
        theEndScreen.x = 0;
        add(theEndScreen);
 
        /* texture scritta per tornare al menu */
        underTextBack = new FlxSprite().loadGraphic(Paths.image('theEnd/underTextBack'));
        underTextBack.x = 0;
        underTextBack.y = -FlxG.height;
        add(underTextBack);

        /* timer */
        new FlxTimer().start(5.3, function(tmr:FlxTimer) {
            
            /* emana suono */
            mario_thankGame.play();

            /* abilita i comandi */
            FlxG.keys.enabled = true;

            /* animazione per la scritta */
            FlxTween.tween(underTextBack, {y: 0}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        });
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        /* INPUT */
        var pressedEnter:Bool = FlxG.keys.justPressed.A || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE;

        /* se clicchi invio */
        if (pressedEnter) {

            /* emana suono */
            sparkleSound.play();

            /* fade-out della camera */
            FlxG.camera.fade(FlxColor.WHITE, 1, false, tornaAlMenu);
        }
    }

     /* funzione per tornare al menu */
     function tornaAlMenu() {
        FlxG.switchState(new Menu());
    }
}