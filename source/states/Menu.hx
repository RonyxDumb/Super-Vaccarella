package states;

import mobile.FlxButton;
import mobile.FlxVirtualPad;
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

    /* MOBILE */
    var virtualPad:mobile.FlxVirtualPad;

    override function create() {
        super.create();

        /* INPUT disattivati */
        // FlxG.mouse.enabled = false;
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

        /* tavola gialla di selezione */
        yellowBG = new FlxSprite().loadGraphic(Paths.image('menu/yellowBG'));
        yellowBG.setGraphicSize(1280, 720);
        yellowBG.updateHitbox();
        yellowBG.screenCenter();
        yellowBG.y = -FlxG.height;
        add(yellowBG);

        /* texture scritta 'FILE SELECT' */
        selectTexture = new FlxSprite().loadGraphic(Paths.image('menu/select_file'));
        selectTexture.setGraphicSize(Std.int(selectTexture.width * 3.8)); // Ridotto leggermente da 5.0 a 3.8
        selectTexture.updateHitbox();
        selectTexture.screenCenter(X);
        selectTexture.y = -FlxG.height;
        add(selectTexture);

        /* --- POSIZIONAMENTO A SINISTRA --- */
        var startX:Float = 260; // Spostato decisamente più a sinistra (prima era 330/360)
        var startY:Float = 260;

        /* texture bottone grigio */
        buttonPlay = new FlxSprite().loadGraphic(Paths.image('menu/button'));
        buttonPlay.setGraphicSize(Std.int(buttonPlay.width * 1.0)); // Dimensioni intermedie
        buttonPlay.updateHitbox();
        buttonPlay.x = startX;
        buttonPlay.y = startY;
        add(buttonPlay);

        /* testo collegato al 'buttonPlay' */
        giocaText = new FlxText(buttonPlay.x + buttonPlay.width + 25, 0, 0, "");
        #if mobile
        giocaText.text = 'Tocca per giocare';
        #else
        giocaText.text = 'Premi A per giocare';
        #end
        giocaText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        giocaText.borderSize = 2;
        giocaText.y = buttonPlay.y + (buttonPlay.height - giocaText.height) / 2;
        add(giocaText);
        
        /* bottone rosso */
        redStone = new FlxSprite().loadGraphic(Paths.image('menu/RedStone1'));
        redStone.setGraphicSize(Std.int(redStone.width * 1.0)); // Dimensioni intermedie
        redStone.updateHitbox();
        redStone.x = startX;
        redStone.y = buttonPlay.y + buttonPlay.height + 25;
        add(redStone);

        /* testo collegato al 'redStone' */
        creditiText = new FlxText(redStone.x + redStone.width + 25, 0, 0, "");
        #if mobile
        creditiText.text = 'Tocca per i crediti';
        #else
        creditiText.text = 'Premi C per i crediti';
        #end
        creditiText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        creditiText.borderSize = 2;
        creditiText.y = redStone.y + (redStone.height - creditiText.height) / 2;
        add(creditiText);

        /* testo per tornare indietro */
        turnBackText = new FlxText(0, 560, 1280, "");
        #if mobile
        turnBackText.text = 'Tocca per tornare indietro';
        #else
        turnBackText.text = 'Premi B per tornare indietro';
        #end
        turnBackText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.GRAY, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        turnBackText.borderSize = 2;
        turnBackText.screenCenter(X);
        add(turnBackText);

        /* MOBILE VIRTUAL PAD */
        virtualPad = new FlxVirtualPad(NONE, A_B_C);
        virtualPad.scale.set(0.8, 0.8);
        virtualPad.updateHitbox();
        virtualPad.x = FlxG.width - virtualPad.width - 20;
        virtualPad.y = FlxG.height - virtualPad.height - 20;
        #if (mobile || debug)
        add(virtualPad);
        #end

        /* ANIMATION DATA */
        FlxTween.tween(yellowBG, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(selectTexture, {y: 110}, 0.6, {ease: FlxEase.quartOut, startDelay: 0.5});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        /* INPUT */
        var pressedA:Bool = FlxG.keys.justPressed.A;
        var pressedB:Bool = FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.B;
        var pressedC:Bool = FlxG.keys.justPressed.C;

        /* MOBILE ACTIONS */
        /*
        if (virtualPad.buttonA.pressed || FlxG.mouse.overlaps(virtualPad.buttonA)) {

            if (FlxG.mouse.justPressed) {
                pressedA = true;
            }
        }

        if (virtualPad.buttonB.pressed) {
            pressedB = true;
        }

        if (virtualPad.buttonC.pressed) {
            pressedC = true;
        }
        */
        /////////////////////

        /* se il mouse va sopra il buttonplay */
        if (FlxG.mouse.overlaps(buttonPlay)) {
            /* altera colore rendendolo scuro */
            // buttonPlay.color = FlxColor.GRAY;
            buttonPlay.alpha = 0.55;

            /* se con il mouse vai sopra al bottone */
            if (FlxG.mouse.justPressed) {
                pressedA = true;
            }
        } else {
            /* altrimenti, il colore del buttonplay torna normale */
            buttonPlay.alpha = 1;
        }

        /* se il mouse va sopra il redstone */
        if (FlxG.mouse.overlaps(redStone)) {
            /* altera colore rendendolo scuro */
            // redStone.color = FlxColor.GRAY;
            redStone.alpha = 0.55;

            /* se con il mouse vai sopra al bottone */
            if (FlxG.mouse.justPressed) {
                pressedC = true;
            }
        } else {
            /* altrimenti, il colore del buttonplay torna normale */
            redStone.alpha = 1;
        }

        /* se premi A */
        if (pressedA) {

            /* disabilita INPUT */
            // FlxG.mouse.enabled = false;
            FlxG.keys.enabled = false;

            /* emana suono */
            confirmTrap.play(false);
            
            /* timer per fermare la musica */
            new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                /* ferma la canzone */
                selectBGM.stop();
            });

            /* flash della camera */
            FlxG.camera.flash(FlxColor.WHITE, 1, funcOpenComandi);
        }

        /* se il mouse va sopra la scritta "torna indietro" */
        if (FlxG.mouse.overlaps(turnBackText)) {
            /* schiarisci il testo */
            turnBackText.alpha = 0.55;

            /* se clicchi col mouse */
            if (FlxG.mouse.justPressed) {
                pressedB = true; /* sarà come aver cliccato dalla tastiera */
            }
        } else {
            turnBackText.alpha = 1;
        }

        /* se premi C */
        if (pressedC) {

            /* disabilita INPUT */
            // FlxG.mouse.enabled = false;
            FlxG.keys.enabled = false;
 
            /* emana suono */
            sparkleSound.play(false);
 
            /* fade-out della camera */
            FlxG.camera.fade(FlxColor.WHITE, 1, false, funcCrediti);
 
            /* fade-out della BGM */
            selectBGM.stop();
        }

        /* se premi B */
        if (pressedB) {

            /* disabilita INPUT */
            // FlxG.mouse.enabled = false;
            FlxG.keys.enabled = false;
  
            /* emana suono */
            confirmTrap.play(false);
  
            /* fade-out della camera */
            FlxG.camera.fade(FlxColor.BLACK, 1, false, funcTurnBack);
  
            /* fade-out della BGM */
            selectBGM.stop();
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