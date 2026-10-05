package states;

import mobile.FlxVirtualPad;
import mobile.Vibradroid;
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
    var cosaFareContesto:FlxSprite;

    /* TESTI */
    var tutorialText:FlxText;
    var exitText:FlxText;
    var continuaText:FlxText;
    
    /* SOUNDS */
    var confirmTrap:FlxSound;
    var sparkleSound:FlxSound;
    var mario_okayDokay:FlxSound;

    /* MUSIC */
    var tutorialBGM:FlxSound;

    /* MOBILE */
    var virtualPad:mobile.FlxVirtualPad;

    public function new(xPos:Float, yPos:Float) {
        super();

        /* abilita i comandi */
        FlxG.keys.enabled = true;
        // FlxG.mouse.enabled = false;

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
        blackTopper = new FlxSprite().makeGraphic(FlxG.width, 70, FlxColor.BLACK);
        blackTopper.y = -blackTopper.height;
        add(blackTopper);

        /* testo 'COSA FARE' */
        tutorialText = new FlxText(0, -100, FlxG.width, 'COSA FARE');
        tutorialText.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, CENTER);
        tutorialText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
        add(tutorialText);

        /* texture con la trama */
        cosaFareContesto = new FlxSprite();
        cosaFareContesto.loadGraphic(Paths.image('menu/CosaFareMenu'));
        cosaFareContesto.setGraphicSize(950); 
        cosaFareContesto.updateHitbox();
        cosaFareContesto.screenCenter(X);
        cosaFareContesto.y = -FlxG.height;
        add(cosaFareContesto);

        /* ORA A SINISTRA: testo per procedere (A / Continua) */
        continuaText = new FlxText();
        #if mobile
        continuaText.text = 'Continua';
        #else
        continuaText.text = 'A: Continua';
        #end
        continuaText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, LEFT);
        continuaText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
        continuaText.x = 60; // Posizionato a SINISTRA
        continuaText.y = -FlxG.height;
        add(continuaText);

        /* ORA A DESTRA: testo per tornare al Menu (B / Torna indietro) */
        exitText = new FlxText();
        #if mobile
        exitText.text = 'Torna indietro';
        #else
        exitText.text = 'B: Torna indietro';
        #end
        exitText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, RIGHT);
        exitText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2, 1);
        exitText.x = FlxG.width - exitText.width - 60; // Posizionato a DESTRA
        exitText.y = -FlxG.height;
        add(exitText);

        /* mobile pad */
        virtualPad = new mobile.FlxVirtualPad(NONE, A_B);
        virtualPad.scale.set(1.0, 1.0);
        virtualPad.x = 20;
        virtualPad.y = FlxG.height - virtualPad.height - 20;
        #if (mobile || debug)
        // add(virtualPad);
        #end

        /* ANIMATION DATA */
        var bottomY:Float = FlxG.height - exitText.height - 25;

        FlxTween.tween(cubeGrid, {alpha: 1}, 0.4, {ease: FlxEase.smoothStepIn});
        
        FlxTween.tween(blackTopper, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(tutorialText, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(cosaFareContesto, {y: 10}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        
        FlxTween.tween(continuaText, {y: bottomY}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(exitText, {y: bottomY}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        /* input */
        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.A;    
        var pressedBack:Bool = FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.B;

        /* MOBILE INPUT */
        // se il mouse va sopra la scritta continua
        if (FlxG.mouse.overlaps(continuaText)) {
            continuaText.alpha = 0.55;

            if (FlxG.mouse.justPressed) {
                pressedEnter = true;
            }
        } else {
            continuaText.alpha = 1;
        }

        // se il mouse va sopra la scritta torna indietro
        if (FlxG.mouse.overlaps(exitText)) {
            exitText.alpha = 0.55;

            if (FlxG.mouse.justPressed) {
                pressedBack = true;
            }
        } else {
            exitText.alpha = 1;
        }


        /* se clicchi INVIO */
        if (pressedEnter) {

            /* fade-out della camera */
            FlxG.camera.fade(FlxColor.WHITE, 1, false, goPlay);

            /* fade-out della canzone */
            tutorialBGM.stop();

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
            tutorialBGM.stop();

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