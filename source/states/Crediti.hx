package states;

import mobile.FlxVirtualPad;
import flixel.util.FlxGradient;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import openfl.Lib;
import openfl.text.TextFormat;
import openfl.Assets;
import openfl.text.TextField;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.FlxState;
/**
 * date: 07/05/2024
 * Menu dei crediti
 */
class Crediti extends FlxState {
    
    /* VARIOUS TEXT */
    var credText:FlxText; // crediti (The Vaccarella Crew)
    var protoText:TextField; // inutilizzato
    var protoText2:FlxText; // testo "PROTOTIPO"
    var exitText:FlxText; // testo per uscire dal menu

    /* SPRITES */
    var bgGradient:FlxSprite;
    var blackTopBar:FlxSprite; // generato by (lettura) texture
    var nutsTeamLogo:FlxSprite;
    var blackTopper:FlxSprite; // generato by code
    var creditsUpdate:FlxSprite; // vi adoro guys

    /* AUDIO */
    var credMusic:FlxSound; // BGM di sottofondo
    var stefySound:FlxSound; // audio di stefano
    var confirmTrap:FlxSound; // suono di backspace menu
    
    /* THE VACCARELLA CREW */
    var mAleD:FlxText; // Alessandro D'Antuono (1C)
    var mFraP:FlxText; // Francesco Pio Pipino (1C)
    var mStef:FlxText; // Stefano Cristino (1C)
    var mEman:FlxText; // Emanuele Tarantella (1C)
    var mAleQ:FlxText; // Alessio Guitadamo (1C)
    var mDanM:FlxText; // Daniele Martucci (1D)

    /* MOBILE */
    var virtualPad:mobile.FlxVirtualPad;

    override function create() {
        super.create();

        /* fade-in della camera */
        FlxG.camera.fade(FlxColor.WHITE, 1, true);

        /* bgm di sottofondo - Mario Madness MOD (fnf) */
        credMusic = new FlxSound().loadEmbedded(Paths.music('credits/BGM_CREDITS'), true);
        
        /* se non sta già suonando */ 
        if (credMusic.playing == false) {

            /* fade-in della canzone */
            credMusic.fadeIn(1);
            
            /* avvia la riproduzione della canzone */
            credMusic.play();
        }
        
        // audio di Stefano XD
        stefySound = new FlxSound().loadEmbedded(Paths.sound('voice/stefaAudio1'), false, false, suonoTerminato);
        stefySound.exists = true;

        // suono di backspace
        confirmTrap = new FlxSound().loadEmbedded(Paths.sound('confirm_trap_A1'), false);

        // bg gradiente
        var bgGradient:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0xFFFECC5C, 0xFFFDC05C], 90);
        bgGradient.scrollFactor.set();
        add(bgGradient);

        // cube grid
        var cubeGrid = new FlxBackdrop(FlxGridOverlay.createGrid(50, 50, 100, 100, true, 0xFFFFBE33, 0xFFFDAD2B));
        cubeGrid.alpha = 0.0;
        cubeGrid.velocity.set(20, 20);
        FlxTween.tween(cubeGrid, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepIn});
        add(cubeGrid);

        // top bar black (by loading texture)
        blackTopBar = new FlxSprite().loadGraphic(Paths.image('title/topBlackBar2'));
        blackTopBar.setGraphicSize(1280, 720);
        blackTopBar.updateHitbox();
        blackTopBar.y = -FlxG.height;
        // add(blackTopBar);

        // blackTopper (barra nera superiore per la risoluzione 720p)
        blackTopper = new FlxSprite().makeGraphic(FlxG.width, 80, FlxColor.BLACK); // Ingrandita l'altezza della barra a 80px per il titolo più grande
        blackTopper.y = -blackTopper.height;
        add(blackTopper);

        // prototipo (early build)
        protoText2 = new FlxText(0, 0, 0, 'PROTOTIPO', 18);
        protoText2.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE);
        protoText2.screenCenter(X);
        protoText2.y = 680;
        // add(protoText2); 

        creditsUpdate = new FlxSprite();
        creditsUpdate.loadGraphic(Paths.image("credits/Credits_31072024_update"));
        creditsUpdate.setGraphicSize(1280, 720);
        creditsUpdate.updateHitbox();
        creditsUpdate.y = -FlxG.height;
        // add(creditsUpdate);

        // THE VACCARELLA CREW - TITOLO (MOLTO PIÙ GRANDE)
        credText = new FlxText(0, -FlxG.height, FlxG.width, 'CREDITI');
        credText.setFormat(Paths.font("vcr.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        credText.borderSize = 3;
        add(credText);

        // NUTS TEAM LOGO - BY ALESSANDRO!
        nutsTeamLogo = new FlxSprite().loadGraphic(Paths.image('credits/nutsTeam_logo_posizionato'));
        nutsTeamLogo.visible = true;
        nutsTeamLogo.y = -blackTopBar.height;
        // add(nutsTeamLogo);

        /* TEXT DATA (DIMENSIONI MOLTO PIÙ IMPONENTI) */
        mAleD = new FlxText(0, -FlxG.height, FlxG.width, "Alessandro D'Antuono");
        mFraP = new FlxText(0, -FlxG.height, FlxG.width, "Francesco Pio Pipino");
        mStef = new FlxText(0, -FlxG.height, FlxG.width, "Stefano Cristino");
        mEman = new FlxText(0, -FlxG.height, FlxG.width, "Emanuele Tarantella");
        mAleQ = new FlxText(0, -FlxG.height, FlxG.width, "Alessio Quitadamo");
        mDanM = new FlxText(0, -FlxG.height, FlxG.width, "Daniele Martucci");

        var creditTexts:Array<FlxText> = [mAleD, mFraP, mStef, mEman, mAleQ, mDanM];

        /* FORMATTAZIONE E BORDI */
        for (txt in creditTexts)
        {
            txt.setFormat(Paths.font('vcr.ttf'), 50, FlxColor.WHITE, CENTER); // Dimensione portata a 42px
            txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
            add(txt);
        }

        // testo per tornare al menu (In basso)
        exitText = new FlxText(0, 630, FlxG.width, "");
        #if mobile
        exitText.text = 'Tocca per tornare indietro';
        #else
        exitText.text = 'Premi B per tornare indietro';
        #end
        exitText.setFormat(Paths.font('vcr.ttf'), 40, FlxColor.GRAY, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        exitText.borderSize = 2.5;
        add(exitText);

        /* MOBILE VIRTUAL PAD */
        virtualPad = new FlxVirtualPad(NONE, A_B);
        virtualPad.scale.set(0.8, 0.8);
        virtualPad.updateHitbox();
        virtualPad.x = FlxG.width - virtualPad.width - 20;
        virtualPad.y = FlxG.height - virtualPad.height - 20;
        #if (mobile || debug)
        // add(virtualPad);
        #end

        /* ANIMATION DATA */
        var startY:Float = 140; // Punto d'inizio verticale
        var spacingY:Float = 75; // Distanza aumentata tra i nomi per distanziarli bene con i caratteri grandi

        FlxTween.tween(blackTopper, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(credText, {y: 10}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});

        FlxTween.tween(mAleD, {y: startY}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(mFraP, {y: startY + spacingY}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(mStef, {y: startY + (spacingY * 2)}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(mEman, {y: startY + (spacingY * 3)}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(mAleQ, {y: startY + (spacingY * 4)}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(mDanM, {y: startY + (spacingY * 5)}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        /* INPUT */
        var pressedB:Bool = FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.B;
        var pressedS:Bool = FlxG.keys.justPressed.S;

        /* se il mouse va sulla scritta per tornare indietro */
        if (FlxG.mouse.overlaps(exitText)) {
            // schiarisci il testo
            exitText.alpha = 0.55;

            // se clicchi il mouse
            if (FlxG.mouse.justPressed) {
                pressedB = true;
            }
        } else {
            exitText.alpha = 1;
        }

        /* se premi B */
        if (pressedB) {
            
            // fade out della camera
            FlxG.camera.fade(FlxColor.BLACK, 1, false, returnMenu);

            // emetti suono
            confirmTrap.play();

            // interrompi la canzone
            credMusic.stop();
        }

        /* se il mouse rientra nella HitBox della scritta di Stefano */
        if (FlxG.mouse.overlaps(mStef) || pressedS) {
           
            /* altera il colore della scritta da BIANCA a ROSSA */
            mStef.color = FlxColor.RED;

            /* se clicchi il mouse/clicchi S */
            if (FlxG.mouse.justPressed || pressedS) {
                
                /* colore della scritta sempre rossa */
                mStef.color = FlxColor.RED;
                
                /* metti in pausa la canzone dei Crediti */
                credMusic.pause();

                /* riavviva suono di Stefano */
                stefySound.revive();

                /* avvia la riproduzione del suono */
                stefySound.play(); // VAII SIIII
                stefySound.onComplete = suonoTerminato;
            }
        } else {
            mStef.color = FlxColor.WHITE;
        }
    }

    // torna al menu
    function returnMenu() {
        FlxG.switchState(new Menu());
    }

    // al termine del suono
    function suonoTerminato() {
        stefySound.stop(); // interrompi il suono di stefano
        credMusic.resume(); // fai tornare la hit
        mStef.color = FlxColor.WHITE;
    }
}