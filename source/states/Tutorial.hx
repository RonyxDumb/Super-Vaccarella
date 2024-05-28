package states;

import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxSubState;
/**
 * date: 26/05/2024
 * 
 * SubState nel quale vengono spiegati:
 * - Trama principale del gioco
 * - Comandi del giocatore
 */
class Tutorial extends FlxSubState {

    /* SPRITES */
    var cubeGrid:FlxBackdrop;
    var blackTopper:FlxSprite;
    var tutorialText:FlxText;
    var exitText:FlxText;
    var cosaFareContesto:FlxSprite;
    
    /* SOUNDS */
    var confirmTrap:FlxSound;
    var sparkleSound:FlxSound;
    var mario_okayDokay:FlxSound;

    /* MUSIC */
    var tutorialBGM:FlxSound;

    public function new(xPos:Float, yPos:Float) {
        super();

        /* abilita i comandi */
        FlxG.keys.enabled = true;
        FlxG.mouse.enabled = false;

        /* MUSIC */
        tutorialBGM = new FlxSound().loadEmbedded(Paths.music('tutorial/BGM_TUTORIAL'), true);
        tutorialBGM.fadeIn(1);
        tutorialBGM.play();

        /* SOUNDS */
        confirmTrap = new FlxSound().loadEmbedded(Paths.sound('confirm_trap_A1'), false);
        sparkleSound = new FlxSound().loadEmbedded(Paths.sound('sparkle'), false);
        mario_okayDokay = new FlxSound().loadEmbedded(Paths.sound('mario_voice/mario_okayDokay'), false);

        /* cube grid bg */
        var cubeGrid = new FlxBackdrop(FlxGridOverlay.createGrid(50, 50, 100, 100, true, 0xFFFECC5C, 0xFFFDC05C));
        cubeGrid.alpha = 0.0;
        cubeGrid.velocity.set(20, 20);
        add(cubeGrid);

        /* piccolo rettangolo in alto allo schermo */
        blackTopper = new FlxSprite().makeGraphic(FlxG.width, 28, FlxColor.BLACK);
        blackTopper.y = 0;
        add(blackTopper);

        /* testo 'COSA FARE' */
        tutorialText = new FlxText();
        tutorialText.x = 100;
        // tutorialText.screenCenter(X);
        // credText.y = 0.5;
        tutorialText.y = -FlxG.height;
        tutorialText.text = 'COSA FARE';
        tutorialText.setFormat(Paths.font("vcr.ttf"), 23, FlxColor.WHITE, CENTER);
        // credText.screenCenter(X);
        add(tutorialText);

        /* texture nella quale troviamo scritta la trama e comandi del gioco */
        cosaFareContesto = new FlxSprite();
        cosaFareContesto.loadGraphic(Paths.image('menu/CosaFareMenu'));
        cosaFareContesto.y = -FlxG.height;
        add(cosaFareContesto);

        /* testo per tornare al Menu */
        exitText = new FlxText();
        exitText.color = FlxColor.WHITE;
        exitText.size = 15;
        // exitText.screenCenter(X);
        exitText.x = 1;
        // exitText.y = 220;
        exitText.text = 'A: Continua       B: Torna indietro';
        exitText.font = 'vcr.ttf';
        exitText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 0.3, 1);
        exitText.y = -FlxG.height;
        add(exitText);

        /* ANIMATION DATA */
        FlxTween.tween(cubeGrid, {alpha: 1}, 0.4, {ease: FlxEase.smoothStepIn});
        FlxTween.tween(blackTopper, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(tutorialText, {y: 0.5}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(exitText, {y: 225}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(cosaFareContesto, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        /* input */
        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.A;    
        var pressedBack:Bool = FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.B;

        /* se clicchi INVIO */
        if (pressedEnter) {

            /* fade-out della camera */
            FlxG.camera.fade(FlxColor.WHITE, 1, false, goPlay);

            /* fade-out della canzone */
            tutorialBGM.fadeOut(1, 0);

            /* emana suono 1, suono di transizione */ 
            sparkleSound.play();

            /* emana suono 2, Mario - Okay Dokay! */
            mario_okayDokay.play();
        }

        /* se clicchi INDIETRO */
        if (pressedBack) {
            
            /* passa allo state del Menu */
            confirmTrap.play(false);

            /* fade-out della canzone */
            tutorialBGM.fadeOut(0.5, 0);

            /* apri nuovamente lo state del Menu */
            FlxG.switchState(new Menu());
        }
    }

    /* funzione per procedere con il gioco */
    function goPlay() {

        /* passa allo state della partita principale */
        FlxG.switchState(new Game());
    }
}