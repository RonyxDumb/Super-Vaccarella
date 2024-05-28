package states;

import flixel.util.FlxTimer;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.FlxState;
/**
 * date: 22/05/2024
 * 
 * Menu con le seguenti opzioni selezionabili:
 * - Procedere con il gioco
 * - Crediti
 * - Ritorno alla schermata del titolo
 */
class Menu extends FlxState {

    /* SPRITES */
    var blackBG:FlxSprite;
    var yellowBG:FlxSprite;
    var buttonPlay:FlxSprite;
    var selectTexture:FlxSprite;
    var redStone:FlxSprite;

    /* MUSIC */
    var selectBGM:FlxSound;

    /* SOUNDS */
    var sparkleSound:FlxSound;
    var confirmTrap:FlxSound;

    /* TEXT */
    var giocaText:FlxText;
    var creditiText:FlxText;
    var turnBackText:FlxText;

    override function create() {
        super.create();

        /* INPUT disattivati */
        FlxG.mouse.enabled = false;
        FlxG.keys.enabled = false;

        /* timer per rendere i comandi accessibili */
        new FlxTimer().start(1, function(tmr:FlxTimer) {
            /* abilita gli input */
            FlxG.keys.enabled = true;
        });

        /* fade-in della camera (bianca) */ 
        FlxG.camera.fade(FlxColor.WHITE, 1, true);

        /* BGM - File Select */
        selectBGM = new FlxSound().loadEmbedded(Paths.music('select/BGM_SELECT'), true);
        selectBGM.fadeIn(1);
        selectBGM.play(false);

        /* suono di transizione */
        sparkleSound = new FlxSound().loadEmbedded(Paths.sound('sparkle'), false);

        /* suono di annullamento */
        confirmTrap = new FlxSound().loadEmbedded(Paths.sound('confirm_trap_A1'), false);

        /* bg nero */
        blackBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(blackBG);

        /* tavola gialla di selezione  */
        yellowBG = new FlxSprite().loadGraphic(Paths.image('menu/yellowBG'));
        yellowBG.y = -FlxG.height;
        add(yellowBG);

        /* texture scritta 'FILE SELECT' */
        selectTexture = new FlxSprite().loadGraphic(Paths.image('menu/select_file'));
        selectTexture.screenCenter(X);
        // selectTexture.y = 40;
        selectTexture.y = -FlxG.height;
        add(selectTexture);

        /* texture bottone grigio */
        buttonPlay = new FlxSprite().loadGraphic(Paths.image('menu/button'));
        buttonPlay.scale.set(0.4, 0.4);
        buttonPlay.updateHitbox();
        buttonPlay.x = 60;
        buttonPlay.y = 70;
        // buttonPlay.y = -FlxG.height;
        add(buttonPlay);

        /* testo collegato al 'buttonPlay' per procedere con il gioco */
        giocaText = new FlxText();
        giocaText.size = 10;
        giocaText.text = 'Premi A per giocare';
        giocaText.x = buttonPlay.x + 65;
        // giocaText.y = -FlxG.height;
        giocaText.y = buttonPlay.y + 12;
        add(giocaText);
        
        /* bottone rosso */
        redStone = new FlxSprite().loadGraphic(Paths.image('menu/RedStone1'));
        redStone.x = 60;
        redStone.y = 130;
        redStone.scale.set(0.4, 0.4);
        redStone.updateHitbox();
        add(redStone);

        /* testo collegato al 'redStone' per procedere con i crediti */
        creditiText = new FlxText();
        creditiText.size = 10;
        creditiText.text = 'Premi C per i crediti';
        creditiText.x = redStone.x + 65;
        creditiText.y = redStone.y + 12;
        add(creditiText);

        /* testo per tornare indietro */
        turnBackText = new FlxText();
        turnBackText.text = 'Premi B per tornare indietro';
        turnBackText.size = 10;
        turnBackText.screenCenter(X);
        turnBackText.y = 190;
        add(turnBackText);

        /* ANIMATION DATA */
        FlxTween.tween(yellowBG, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(selectTexture, {y: 40}, 0.6, {ease: FlxEase.quartOut, startDelay: 0.5});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        /* INPUT */
        var pressedA:Bool = FlxG.keys.justPressed.A;
        var pressedB:Bool = FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.B;
        var pressedC:Bool = FlxG.keys.justPressed.C;

        /* se premi A */
        if (pressedA) {

            /* disabilita INPUT */
            FlxG.mouse.enabled = false;
            FlxG.keys.enabled = false;

            /* emana suono */
            confirmTrap.play(false);

            /* fade-out della canzone */
            selectBGM.fadeOut(1, 0);
            
            /* timer per fermare la musica */
            new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                /* ferma la canzone */
                selectBGM.fadeOut(0.5, 0);
            });

            /* flash della camera */
            FlxG.camera.flash(FlxColor.WHITE, 1, funcOpenComandi);
        }

        /* se premi C */
        if (pressedC) {

            /* disabilita INPUT */
            FlxG.mouse.enabled = false;
            FlxG.keys.enabled = false;
 
            /* emana suono */
            sparkleSound.play(false);
 
            /* fade-out della camera */
            FlxG.camera.fade(FlxColor.WHITE, 1, false, funcCrediti);
 
            /* fade-out della BGM */
            selectBGM.fadeOut(0.5, 0);
        }

        /* se premi B */
        if (pressedB) {

            /* disabilita INPUT */
            FlxG.mouse.enabled = false;
            FlxG.keys.enabled = false;
  
            /* emana suono */
            confirmTrap.play(false);
  
            /* fade-out della camera */
            FlxG.camera.fade(FlxColor.BLACK, 1, false, funcTurnBack);
  
            /* fade-out della BGM */
            selectBGM.fadeOut(0.5, 0);
        }
    }

    /* funzione collegata al flash della camera per aprire il SubState dei comandi */
    function funcOpenComandi() {

        /* apri SubState */
        openSubState(new Tutorial(0, 0));
    }

    /* funzione collegata al fade-out (bianco) della camera per visualizzare i crediti */
    function funcCrediti() {

        /* apri lo state dei crediti */
        FlxG.switchState(new Crediti());
    }

    /* funzione collegata al fade-out nero della camera per il ritorno al menu */
    function funcTurnBack() {

        /* apri lo state della schermata del Titolo */
        FlxG.switchState(new TitleScreen());
    }
}