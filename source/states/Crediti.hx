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
        blackTopBar.y = -FlxG.height;
        // add(blackTopBar);

        // blackTopper (by code)
        blackTopper = new FlxSprite().makeGraphic(FlxG.width, 28, FlxColor.BLACK);
        blackTopper.y = 0;
        add(blackTopper);

        // prototipo fino al 22/05/2024, ora è nella sua fase di rilascio
        protoText2 = new FlxText(0, 0, 0, 'PROTOTIPO', 10);
        protoText2.screenCenter(X);
        protoText2.y = 230;
        protoText2.setFormat(Paths.font('vcr.ttf'), 10, FlxColor.WHITE);
        // add(protoText2); 

        /* uhhh il progetto ha preso una svolta, tanta gente lo adora adesso.
        A dirla tutta sono felicissimo, eh nessuno ha mai supportato così tanto
        un progetto diretto dal sottoscritto. Tutta questa hype mi motiva tantissimo
        e chissà, nuovi contenuti? Beh per ora posso solo dirvi, thank you! */
        creditsUpdate = new FlxSprite(); // un piccolo pensierino per voi...
        creditsUpdate.loadGraphic(Paths.image("credits/Credits_31072024_update"));
        creditsUpdate.y = -FlxG.height;
        add(creditsUpdate);

        // testo per tornare al menu
        exitText = new FlxText();
        exitText.color = FlxColor.WHITE;
        exitText.size = 15;
        // exitText.screenCenter(X);
        exitText.x = 30;
        exitText.y = 215;
        #if mobile
        exitText.text = 'Clicca per tornare indietro';
        #else
        exitText.text = 'Premi B per tornare indietro';
        #end
        exitText.font = 'vcr.ttf';
        exitText.setFormat(Paths.font('vcr.ttf'), 15, FlxColor.WHITE);
        exitText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 0.5, 1);
        exitText.updateHitbox();
        add(exitText);

        // THE VACCARELLA CREW
        credText = new FlxText(/*0, 10, 0, "The Vaccarella Crew", 20*/);
        credText.x = 114;
        // credText.y = 0.5;
        credText.y = -FlxG.height;
        credText.text = 'CREDITI';
        credText.setFormat(Paths.font("vcr.ttf"), 23, FlxColor.WHITE, CENTER);
        // credText.screenCenter(X);
        add(credText);

        // NUTS TEAM LOGO - BY ALESSANDRO!
        nutsTeamLogo = new FlxSprite().loadGraphic(Paths.image('credits/nutsTeam_logo_posizionato'));
        // nutsTeamLogo.x = -80;
        // nutsTeamLogo.updateHitbox();
        nutsTeamLogo.visible = true;
        nutsTeamLogo.y = -blackTopBar.y;
        // nutsTeamLogo.scale.set(0.6, 0.6);
        // nutsTeamLogo.setGraphicSize(70);
        // add(nutsTeamLogo);

        /* TEXT DATA */
        mAleD = new FlxText(0, /*60*/-FlxG.height, 0, "Alessandro D'Antuono", 20);
        mFraP = new FlxText(0, /*80*/-FlxG.height, 0, "Francesco Pio Pipino", 20);
        mStef = new FlxText(0, /*100*/-FlxG.height, 0, "Stefano Cristino", 20);
        mEman = new FlxText(0, /*120*/-FlxG.height, 0, "Emanuele Tarantella", 20);
        mAleQ = new FlxText(0, /*140*/-FlxG.height, 0, "Alessio Quitadamo", 20);
        mDanM = new FlxText(0, /*160*/-FlxG.height, 0, "Daniele Martucci", 20);

        /* FONT DATA */
        mAleD.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, CENTER);
        mFraP.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, CENTER);
        mStef.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, CENTER);
        mEman.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, CENTER);
        mAleQ.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, CENTER);
        mDanM.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, CENTER);

        /* BORDER STYLE DATA */
        mAleD.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 0.5, 1);
        mFraP.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 0.5, 1);
        mStef.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 0.5, 1);
        mEman.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 0.5, 1);
        mAleQ.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 0.5, 1);
        mDanM.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 0.5, 1);

        /* POSITION DATA */
        mAleD.screenCenter(X);
        mFraP.screenCenter(X);
        mStef.screenCenter(X);
        mEman.screenCenter(X);
        mAleQ.screenCenter(X);
        mDanM.screenCenter(X);

        /* AGGIUNGI TUTTI ALLO STATE */
        // add(mAleD);
        // add(mFraP);
        // add(mStef);
        // add(mEman);
        // add(mAleQ);
        // add(mDanM);

        /* ANIMATION DATA */
        FlxTween.tween(mAleD, {y: 60}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(mFraP, {y: 80}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(mStef, {y: 100}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(mEman, {y: 120}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(mAleQ, {y: 140}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(mDanM, {y: 160}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        // FlxTween.tween(blackTopBar, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(blackTopper, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(credText, {y: 0.5}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(creditsUpdate, {y: 0.5}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});
        // FlxTween.tween(exitText, {y: 215}, 0.8, {ease: FlxEase.quartOut, startDelay: 0.5});
        // FlxTween.tween(nutsTeamLogo, {y: 0}, 0.7, {ease: FlxEase.quartOut, startDelay: 0.5});
        // FlxTween.tween(credText, {y: 0}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});

        // protoText = new FlxText(200, 10, 0, "PROTOTIPO");
        /*
        protoText = new TextField();
        var font = Assets.getFont('assets/fonts/vcr.ttf');
        var fontFormat = new TextFormat(font.fontName, 20, FlxColor.WHITE);
        protoText.text = "PROTOTIPO";
        protoText.embedFonts = true;
        protoText.defaultTextFormat = fontFormat;
        protoText.x = Lib.current.stage.width - protoText.textWidth - 10;
        protoText.y = Lib.current.stage.height - protoText.textHeight - 10;
        */

        /* MOBILE */
        virtualPad = new FlxVirtualPad(NONE, A_B);
        virtualPad.scale.set(0.5, 0.5);
        virtualPad.x = 35;
        virtualPad.y = 40;
        #if (mobile || debug)
        // add(virtualPad);
        #end
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