package states;

import flixel.ui.FlxVirtualPad;
import shaders.Filter3D;
import mobile.Vibradroid;
import flixel.util.FlxTimer;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.sound.FlxSound;
import shaders.GuassianBlur;
import shaders.OldTVShader;
import openfl.display.ShaderData;
import openfl.filters.ShaderFilter;
import shaders.VCRDistortionShader;
import openfl.display.Sprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
/**
 * date:28/04/2024
 * 
 * Schermata del titolo con le seguenti opzioni eseguibili:
 * - Procedere al Menu di selezione
 */
class TitleScreen extends FlxState {

    /* SPRITES */
    var bg:FlxSprite;
    var superVaccarellaLogo:FlxSprite;
    var pressEnter:FlxSprite;
    var topBlackBar:FlxSprite;
    var animatedMario:FlxSprite;
    var vaccarellaFace:FlxSprite;

    /* TEXTS */
    var pressEnterText:FlxText; // testo "PREMI INVIO"

    /* MUSIC */
    var titleBGM_VACCARELLA:FlxSound;

    /* SOUNDS */
    var mario_Hello:FlxSound;
    var sparkleSound:FlxSound;

    /* TECHNICAL FEATURES */
    var time:Float = 0.8; // TIME per la scritta "PREMI INVIO" 

    /* SHADERS DATA */ 
    var shadey:OldTVShader; // shaders data
    var shady:VCRDistortionShader; // shaders data
    var gBlur:GuassianBlur; // shaders data GUASSIAN
    var filter3d:Filter3D;
    public static var filter:ShaderFilter; // shaders data
    public static var filter2:ShaderFilter; // shaders data
    public static var filter3:ShaderFilter; // shaders data GUASSIAN
    public static var filter4:ShaderFilter; // shaders data 3D

    /* MOBILE */
    var virtualPad:mobile.FlxVirtualPad;

    override function create() {
        super.create();

        /* input disattivati */
        FlxG.keys.enabled = false;
        // FlxG.mouse.enabled = false;

        /* fade-in della camera (nero) */
        FlxG.camera.fade(FlxColor.BLACK, 0.5, true);

        /* mario 'Hello!' sound */
        mario_Hello = new FlxSound().loadEmbedded(Paths.sound('mario_voice/mario_hello'), false);

        /* sparkle transition sound */
        sparkleSound = new FlxSound().loadEmbedded(Paths.sound('sparkle'), false);

        /* timer */
        new FlxTimer().start(0.7, function(tmr:FlxTimer) {
            
            /* emana suono di Mario */
            mario_Hello.play();

            /* abilita gli input */
            FlxG.keys.enabled = true;
        });

        /* title theme - BGM */
        titleBGM_VACCARELLA = new FlxSound().loadEmbedded(Paths.music('title/BGM_VACCARELLA_THEME'), true);
        titleBGM_VACCARELLA.play(false);
        titleBGM_VACCARELLA.fadeIn(2);

        /* bg di Super Mario 64 */
        bg = new FlxSprite().loadGraphic(Paths.image('title/SuperVaccbg'));
        bg.setGraphicSize(1280, 720);
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);

        /* parte sovrastante gradiente nera */
        topBlackBar = new FlxSprite().loadGraphic(Paths.image('title/topBlackBar2'));
        topBlackBar.setGraphicSize(1280, 720);
        topBlackBar.updateHitbox();
        topBlackBar.screenCenter(X);
        topBlackBar.y = -topBlackBar.height;
        add(topBlackBar);

        /* FACCIA VACCARELLA */
        vaccarellaFace = new FlxSprite().loadGraphic(Paths.image("player/superVacc"));
        vaccarellaFace.setGraphicSize(450, 450); // Prima imposti la grandezza...
        vaccarellaFace.updateHitbox();           // ...poi aggiorni la hitbox!
        vaccarellaFace.centerOrigin();           // Punto di rotazione al centro
        vaccarellaFace.screenCenter(X);
        vaccarellaFace.y = -1500;                 // -15000 è troppo lontano, -1500 va benissimo
        add(vaccarellaFace);

        /* ANIMAZIONE INGRESSO (Effetto rimbalzo stile Mario 64) */
        FlxTween.tween(vaccarellaFace, {y: 170}, 0.8, {
            ease: FlxEase.bounceOut,
            startDelay: 0.5
        });

        /* animated mario face */
        animatedMario = new FlxSprite();
        animatedMario.frames = Paths.getSparrowAtlas('title/marioFaceSprite');
        animatedMario.animation.addByPrefix('idle loop', 'marioFace_title_', 30, true, false, false);
        animatedMario.animation.finishCallback = function(_) {
            animatedMario.animation.play('idle loop', true, false);
        }
        animatedMario.setGraphicSize(1280, 720);
        animatedMario.updateHitbox();
        animatedMario.screenCenter(X);
        animatedMario.y = -720; // Posizione fuori schermo in alto
        animatedMario.animation.play('idle loop', true, false);
        // add(animatedMario);

        /* SUPER VACCARELLA LOGO */
        superVaccarellaLogo = new FlxSprite().loadGraphic(Paths.image("title/SuperVaccarellaNewLogoColored"));
        superVaccarellaLogo.setGraphicSize(1280, 720);
        superVaccarellaLogo.updateHitbox();
        superVaccarellaLogo.screenCenter(X);
        superVaccarellaLogo.y = -topBlackBar.height;
        add(superVaccarellaLogo);

        /* (inutilizzato) texture press enter */
        pressEnter = new FlxSprite(0, 0).loadGraphic(Paths.image("title/pressenter"));
        pressEnter.setGraphicSize(Std.int(pressEnter.width * 0.2));
        pressEnter.updateHitbox();
        pressEnter.screenCenter(X);
        pressEnter.visible = false;
        add(pressEnter);

        /* scritta per procedere munita di timer di visualizzazione */
        pressEnterText = new FlxText(0, -topBlackBar.height, 1280, "");
        #if mobile
        pressEnterText.text = "CLICCA   SULLO   SCHERMO";
        pressEnterText.setFormat(Paths.font("Delfino.ttf"), 50, FlxColor.ORANGE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        #else
        pressEnterText.text = "PREMI  INVIO";
        pressEnterText.setFormat(Paths.font("Delfino.ttf"), 60, FlxColor.ORANGE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        #end
        pressEnterText.borderSize = 2;
        pressEnterText.screenCenter(X);
        add(pressEnterText);

        /* VIRTUALPAD for MOBILE */
        virtualPad = new mobile.FlxVirtualPad(NONE, A);
        virtualPad.scale.set(0.7, 0.7);
        virtualPad.updateHitbox();
        virtualPad.x = 15;
        virtualPad.y = FlxG.height - virtualPad.height - 15; // Ancorato in basso a sinistra in modo proporzionale
        virtualPad.visible = false;
        #if (mobile || debug)
        add(virtualPad);
        #end
        
        /* ANIMATION DATA */
        // Target Y per far centrare esattamente la faccia di Mario
        var marioTargetY:Float = (720 - animatedMario.height) / 2;

        FlxTween.tween(topBlackBar, {y: 0}, 0.5, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(animatedMario, {y: marioTargetY}, 0.5, {ease: FlxEase.quartOut, startDelay: 0.5});
        // FlxTween.tween(vaccarellaFace, {y: -250}, 0.6, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(superVaccarellaLogo, {y: 0}, 0.6, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(pressEnterText, {y: 620}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5}); // 620px lo posiziona bene in basso visibile

        /* SHADERS */
        shady = new VCRDistortionShader();
        shady.iTime.value = [1.25];
        shadey = new OldTVShader();
        shadey.iTime.value = [1.25];
        gBlur = new GuassianBlur();
        filter3d = new Filter3D();
        filter3d.iTime.value = [1.25];
        
        filter = new ShaderFilter(shady);
        filter2 = new ShaderFilter(shadey);
        filter3 = new ShaderFilter(gBlur);
        filter4 = new ShaderFilter(filter3d);

        /* applica i filtri allo schermo */
        // FlxG.game.setFilters([]);
    }

    var danceTimer:Float = 0;

    override function update(elpased:Float) {
        super.update(elpased);

        // Incrementiamo il timer per le funzioni trigonometriche
        danceTimer += elpased * 5; // Aumenta/diminuisci il 5 per cambiare la velocità del ballo

        if (vaccarellaFace != null)
        {
            // 1. ROTAZIONE (Dondola a destra e sinistra)
            vaccarellaFace.angle = Math.sin(danceTimer) * 10; 

            // 2. ELASTICITÀ MARIO 64 (Mantiene la base di 450px schiacciandosi a ritmo)
            var sizeX:Int = Std.int(450 + (Math.sin(danceTimer * 2) * 35));
            var sizeY:Int = Std.int(450 + (Math.cos(danceTimer * 2) * 35));
            
            vaccarellaFace.setGraphicSize(sizeX, sizeY);

            // 3. FLUTTUAZIONE VERTICALE (Galleggia in aria dopo essere scesa)
            if (vaccarellaFace.y > 0) {
                vaccarellaFace.y = 170 + (Math.sin(danceTimer * 1.5) * 15);
            }
        }

        /* timer per la visualizzazione della scritta per procedere */
        time -= elpased;

        if (time <= 0) {
            time = 0.8; // durata del tempo 

            if (pressEnter.alive) {
                pressEnter.kill(); /* non visibile ma utilizzato come object di riferimento */
               
                /* modifica testo in modo da non visualizzare nulla */
                pressEnterText.text = "";
            }
            else
            {
                pressEnter.revive(); /* riavviva lo sprite (sempre non visibile) */
                
                /* altera nuovamente il testo */
                #if mobile
                pressEnterText.text = "CLICCA  SULLO  SCHERMO";
                #else
                pressEnterText.text = "PREMI  INVIO";
                #end
            }
        }

        /* INPUT */
        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.A;
        var pressedFullScreen:Bool = FlxG.keys.justPressed.F;

        /* se clicchi il tasto A (mobile) */
        if (virtualPad.buttonA.pressed) {
            pressedEnter = true;
        }

        /*
        if (FlxG.mouse.overlaps(pressEnterText)) {
            pressEnterText.alpha = 0.55;

            if (FlxG.mouse.justPressed) {
                pressedEnter = true;
            }
        } else {
            pressEnterText.alpha = 1;
        }
            */

        #if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				pressedEnter = true;
		}
		#end

        /* se clicchi invio */
        if (pressedEnter) {

            /* emetti suono transizione */
            sparkleSound.play();

            /* per rendere la scritta visibile a lungo, altera il tempo di visualizzazione */
            time = 10000; /* un eternità */

            pressEnterText.text = "";
            // pressEnterText.y = 185; /* poni la scritta più in alto */

            /* fade-out della camera */
            FlxG.camera.fade(FlxColor.WHITE, 1, false, funcNextState);

            /* disabilita gli input */
            FlxG.keys.enabled = false;

            /* stop della BGM */
            titleBGM_VACCARELLA.stop();
        }

        /* se clichi F*/
        if (pressedFullScreen) {
            FlxG.fullscreen = true;
        }
    }

    /* funzione per procedere al menu (collegata al fade-out della camera) */
    function funcNextState() {
        FlxG.switchState(new Menu());
    }
}