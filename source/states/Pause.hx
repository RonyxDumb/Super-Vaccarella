package states;

import flixel.FlxObject;
import objects.Player4Directions;
import flixel.sound.FlxSound;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
/**
 * date: 30/04/2024
 * Menu di pausa 
 * non è uno state apparte, è un substate, in modo tale da non
 * perdere progressi durante il progresso con il gioco
 * 
 * dev'essere molto simile a quello di SM64
 * 
 * preso in parte da https://github.com/Ash-Stat-SYS/Classified-Source-Public/blob/main/source/PauseSubState.hx
 */
class Pause extends FlxSubState {
    
    /* SPRITES */
    var bg:FlxSprite;
    var box:FlxSprite;
    var pauseText:FlxSprite;
    var shitterText:FlxText;
    var cubeGrid:FlxBackdrop;

    /* TEXTS */
    var exitCourse:FlxText; // testo per uscire dal livello

    /* MUSIC & SOUND */
    var pauseMusic:FlxSound;
    var musicPlayin:FlxSound;
    var pauseSFX:FlxSound;

    /* OBJECTS */
    var player:Player4Directions;
    var cameraFollow:FlxObject;

    public function new(x:Float, y:Float) {
        super();

        /* se durante la partita sta suonando una bgm */
        if (FlxG.sound.music.playing) {
            FlxG.sound.music.pause(); // mettila in pausa
        }

        /* settin' della pausa */
        FlxG.camera.zoom = 0; // bug della pausa zoomata dal Game.hx

        /* il giocatore e la sua posizione */
        player = new Player4Directions(x, y);
        player.visible = false;
        add(player);

        /* camera segue il giocatore */
        cameraFollow = new FlxObject(player.getGraphicMidpoint().x, player.getGraphicMidpoint().y, 1, 1);
        add(cameraFollow);

        /* avvia la riproduzione della canzone di sottofondo */
        pauseMusic = new FlxSound().loadEmbedded(Paths.music('pause/pauseMusic'), true, true);
		pauseMusic.volume = 0.6;
        pauseMusic.play();
		
        /* aggiungi la canzone alla lista delle BGM eseguibili */
        FlxG.sound.list.add(pauseMusic);

        /* sfondo nero semi trasparente */
        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.4;
		bg.scrollFactor.set();
		add(bg);

        /* cube grid semi trasparente */
        var cubeGrid = new FlxBackdrop(FlxGridOverlay.createGrid(50, 50, 100, 100, true, FlxColor.WHITE, FlxColor.GRAY));
        cubeGrid.alpha = 0.0;
        cubeGrid.velocity.set(20, 20);
        FlxTween.tween(cubeGrid, {alpha: 0.6}, 0.5, {ease: FlxEase.smoothStepIn});
        add(cubeGrid);

        /* box nel quale poneremo la scritta 'PAUSA' */
        box = new FlxSprite().makeGraphic(157, 65, FlxColor.BLACK);
        box.screenCenter(XY);
        box.alpha = 0.6;
        add(box);

        /* texture della scritta 'PAUSA' */
        var pauseText:FlxSprite = new FlxSprite().loadGraphic(Paths.image("pause/PAUSE"));
        pauseText.scale.set(0.4, 0.4);
        pauseText.screenCenter(XY);
        // pauseText.y += (pauseText.height) * 2;
        add(pauseText);

        /* testo per chiudere il menu della pausa */
        exitCourse = new FlxText();
        exitCourse.text = 'Premi E per tornare al menu';
        exitCourse.color = FlxColor.RED;
        // exitCourse.font = 'Mario64.ttf';
        // exitCourse.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 0.2);
        exitCourse.size = 15;
        exitCourse.y = 220;
        exitCourse.x = 1;
        add(exitCourse);

        /* texture inutilizzata */
        shitterText = new FlxText(12, FlxG.height, 315, "Resume"/*, 20*/);
        shitterText.setFormat(Paths.font("Mario64.ttf"), 34, FlxColor.WHITE, CENTER);
		shitterText.x = ((box.width - shitterText.width) / 2) + box.x;
		shitterText.y = ((box.height - shitterText.height) / 2) + box.y;
        //add(shitterText);

        /* emetti suono di pausa */
        pauseSFX = new FlxSound().loadEmbedded(Paths.sound('sm64_pause'), false);
        pauseSFX.play();
    }

    override function update(elpased:Float) {
        super.update(elpased);

        // input
        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.P;
        var pressedE:Bool = FlxG.keys.justPressed.E;

        /* aggiorna la posizione e segui il giocatore */
        FlxG.camera.follow(cameraFollow, LOCKON, 1);

        /* se premi INVIO */
        if (pressedEnter) {
            
            /* emetti suono della pausa */
            pauseSFX.play();

            /* ferma la canzone */
            pauseMusic.stop(); // ferma SOLO la musica della PAUSA
            
            /* funzione per chiudere il subState */
            close();

            /* riporta il zoom della camera al valore in partita */
            FlxG.camera.zoom = 1.9;

            /* riavvia la riproduzione della BGM */
            FlxG.sound.music.resume(); /* dal punto in cui si era interrotta */
        }

        /* se clicchi E */
        if (pressedE) {

            /* emetti suono di pausa */
            pauseSFX.play();

            /* ferma la BGM della pausa */
            pauseMusic.stop();

            /* fade-out nero della camera */
            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, returnMenu);

            /* ferma totalmente la canzone */
            FlxG.sound.music.stop();
        }
    }

    /* funzione con la quale si ritorna al Menu */
    function returnMenu() {

        /* ritorna allo state del Menu */
        FlxG.switchState(new Menu());
    }
}