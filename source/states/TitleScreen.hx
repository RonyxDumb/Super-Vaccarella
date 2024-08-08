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
        bg = new FlxSprite();
		bg.loadGraphic(Paths.image('title/SuperMariobg'));
		bg.screenCenter();
		//bg.scale.set(1.5, 1.5);
		add(bg);

        /* parte sovrastante gradiente nera */
        topBlackBar = new FlxSprite().loadGraphic(Paths.image('title/topBlackBar2'));
        topBlackBar.y = -topBlackBar.height;
        add(topBlackBar);

        /* animated mario face */
        animatedMario = new FlxSprite();
        animatedMario.frames = FlxAtlasFrames.fromSparrow('assets/images/title/marioFaceSprite.png', 'assets/images/title/marioFaceSprite.xml');
        animatedMario.animation.addByPrefix('idle loop', 'marioFace_title_', 30, true, false, false);
        animatedMario.animation.finishCallback = function(_) {
            animatedMario.animation.play('idle loop', true, false);
        }
        animatedMario.screenCenter(X);
        animatedMario.y = -topBlackBar.height;
        animatedMario.animation.play('idle loop', true, false);
        add(animatedMario);

        /* SUPER VACCARELLA LOGO */
        superVaccarellaLogo = new FlxSprite(0, 0).loadGraphic(Paths.image("title/SuperVaccarellaNewLogoColored"));
        superVaccarellaLogo.scale.set(1, 1);
        superVaccarellaLogo.screenCenter(X);
        superVaccarellaLogo.y = -topBlackBar.height;
        add(superVaccarellaLogo);

        /* (inutilizzato) texture press enter [utilizzata per il timer della scritta generata by code] */
        pressEnter = new FlxSprite(superVaccarellaLogo.x, superVaccarellaLogo.y + 3).loadGraphic(Paths.image("title/pressenter"));
        pressEnter.scale.set(0.2, 0.2);
        pressEnter.screenCenter(X);
        pressEnter.visible = false;
        add(pressEnter);

        /* scritta per procedere munita di timer di visualizzazione*/
        pressEnterText = new FlxText();
        #if mobile
        pressEnterText.text = "CLICCA SULLO SCHERMO";
        pressEnterText.setFormat("SuperMario64DOT.ttf", 13, FlxColor.ORANGE);
        
        #else
        pressEnterText.text = "PREMI INVIO";
        pressEnterText.setFormat("SuperMario64DOT.ttf", 18, FlxColor.ORANGE);
        #end
        pressEnterText.font = 'SuperMario64DOT.ttf';
        pressEnterText.autoSize = false;
        pressEnterText.wordWrap = false;
        pressEnterText.fieldWidth = FlxG.width;
        pressEnterText.color = FlxColor.ORANGE;
        pressEnterText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5);
        pressEnterText.alignment = CENTER;
        pressEnterText.screenCenter(X);
        pressEnterText.y = -topBlackBar.height;
        add(pressEnterText);

        /* VIRTUALPAD for MOBILE */
        virtualPad = new mobile.FlxVirtualPad(NONE, A);
        virtualPad.y = 28;
        virtualPad.x = 15;
        virtualPad.scale.set(0.7, 0.7);
        virtualPad.updateHitbox();
        virtualPad.visible = false;
        #if (mobile || debug)
        add(virtualPad);
        #end
        
        /* ANIMATION DATA */
        FlxTween.tween(topBlackBar, {y: 0}, 0.5, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(animatedMario, {y: CENTER}, 0.5, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(superVaccarellaLogo, {y: -10}, 0.6, {ease: FlxEase.quartOut, startDelay: 0.5});
        FlxTween.tween(pressEnterText, {y: 200}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.5});

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

    override function update(elpased:Float) {
        super.update(elpased);

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
                pressEnterText.text = "CLICCA SULLO SCHERMO";
                #else
                pressEnterText.text = "PREMI INVIO";
                #end
            }
        }

        /* INPUT */
        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.A;

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
    }

    /* funzione per procedere al menu (collegata al fade-out della camera) */
    function funcNextState() {
        FlxG.switchState(new Menu());
    }
}