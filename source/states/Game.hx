package states;

import mobile.FlxVirtualPad;
import flixel.FlxCamera;
import flixel.input.FlxKeyManager;
import openfl.text.TextField;
import objects.VaccarellaEnemy;
import shaders.VCRDistortionShader;
import openfl.filters.ShaderFilter;
import openfl.display.ShaderData;
import shaders.ScaryShader;
import flixel.system.FlxAssets.FlxShader;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxTileFrames;
import flixel.addons.tile.FlxTilemapExt;
import flixel.FlxG;
import objects.Player4Directions;
import flixel.FlxState;
import states.Pause;
/**
 * date: 23/05/2024
 * 
 * La partita principale, nella quale puoi:
 * - Muovere il giocatore in 4 angolazioni diverse
 * - Raccogliere una stella
 * 
 * preso in buonissima parte da: https://github.com/HaxeFlixel/flixel-demos/tree/dev/Platformers/FlxTilemapExt
 */
class Game extends FlxState {

    /* OBJECTS */
    var player:Player4Directions; // il giocatore
    var level1:FlxTilemapExt;
    var FLOOR:FlxObject;
    var hud:FlxGroup;
    var angle:Float = 0;

    /* CAMERA */
    public var gameCamera:FlxCamera;
    public var hudCamera:FlxCamera;

    /* TECHNICAL FEATURES */
    var time:Float = 0.8; // TIME per la scritta "CORRI" 
    
    /* TEXTS */
    var pauseText:FlxText;
    var runText:FlxText;

    /* SPRITES */
    var star:FlxSprite;
    var vaccarellaEnemy:FlxSprite; /* mini-update 07/07/2024 */

    /* MUSIC */
    var starGet:FlxSound;
    var subterfuge_chase:FlxSound;

    /* SOUNDS */
    var sparkleSound:FlxSound;

    /* shaders */
    var scaryShader:ScaryShader;
    var filterScary:ShaderFilter;
    var shady:VCRDistortionShader;
    var filterblur:ShaderFilter;

    /* MOBILE CONTROLS */
    var virtualPad:FlxVirtualPad;

    /* funzione che inizializza le camera(s) del gioco */
    function initCameras():Void {
        
        /* camera principale del gioco */
        gameCamera = new FlxCamera();

        /* camera secondaria (hud) del gioco */
        hudCamera = new FlxCamera();
        hudCamera.bgColor.alpha = 0; // mostra la camera principale "gameCamera"

        /* aggiungi camera e specifica chi è la principale camera del gioco */
        FlxG.cameras.reset(gameCamera);
        FlxG.cameras.add(hudCamera, false);
    }

    /* funzione che inizializza gli elementi della camera secondaria (hudCamera) */
    function initHudCamera():Void {

        /* testo per mettere in pausa il gioco (inutilizzata lol) */
        var pauseText = new FlxText();
        pauseText.color = FlxColor.RED;
        pauseText.text = 'Clicca qui per mettere in pausa';
        pauseText.size = 15;
        pauseText.x = 1;
        pauseText.y = 10;
        pauseText.scrollFactor.set();
        pauseText.visible = false;
        add(pauseText);
        // hud.add(pauseText);

        /* testo "CORRI" */
        var runText = new FlxText();
        runText.text = 'CORRI!';
        runText.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.RED, CENTER);
        runText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1);
        runText.color = FlxColor.RED;
        runText.x = 50;
        runText.y = 0.5;
        runText.visible = true;
        // add(runText);

        virtualPad = new FlxVirtualPad(FULL, NONE);
        // virtualPad.scale.set(0.5, 0.5);
        virtualPad.alpha = 0.80;
        virtualPad.updateHitbox();

        virtualPad.forEach((s)-> {
            s.setGraphicSize(Std.int(s.width * 0.5));
            s.updateHitbox();
        });

        // CAZZO FINALMENTE!
        // 30/07/2024 LAYOUT DEI COMANDI MOBILE PERFEZIONATI
        // (la loro posizione intendo eh)
        virtualPad.buttonUp.x = 30.5; // done
        virtualPad.buttonUp.y = 37; // done

        virtualPad.buttonDown.x = 30.5; // done
        virtualPad.buttonDown.y = 145; // done

        virtualPad.buttonRight.x = 87; // done
        virtualPad.buttonRight.y = 90; // done

        virtualPad.buttonLeft.y = 90; // done
        virtualPad.buttonLeft.x = -30; // done

        virtualPad.x = 30;
        virtualPad.y = 30;
        #if mobile
        this.add(virtualPad);
        #end

        /* passa questi elementi alla "hudCamera" */
        pauseText.cameras = [hudCamera];
        runText.cameras = [hudCamera];
        virtualPad.cameras = [hudCamera];
    }

    public override function create():Void {
        super.create();

        /* maggiore accuracy della fisica */
        FlxG.fixedTimestep = false;

        /* inizializza la camera e l'hud del gioco */
        initCameras();
        initHudCamera();

        /* shaders da applicare durante l'inseguimento */
        scaryShader = new ScaryShader();
        shady = new VCRDistortionShader();
        shady.iTime.value = [1.25];
        filterScary = new ShaderFilter(shady);

        /* applica filtro */
        // FlxG.game.setFilters([filterScary]);
        // gameCamera.setFilters([filterScary]);
        // hudCamera.setFilters([filterScary]);

        /* SETTIN */
        FlxG.keys.enabled = true;

        /* MUSIC */
        FlxG.sound.playMusic(Paths.music('basement/BGM_BASEMENT_FRACC'), 1, true);
        // FlxG.sound.playMusic(Paths.music('chase/BGM_SUBTERFUGE_CHASE'), 1, true);

        /* SOUNDS */
        sparkleSound = new FlxSound().loadEmbedded(Paths.sound('sparkle'), false);
        sparkleSound.pitch = 1.7;

        /* camera background */
        FlxG.camera.bgColor = 0xff050509;

        /* fade della camera */
        FlxG.camera.fade(FlxColor.WHITE, 1, true/*, avviaFlxGMusic*/);

        /* starGet music */
        starGet = new FlxSound().loadEmbedded(Paths.music('starGet/BGM_STAR_GET'), false, true/*, starGetFinished*/);
        starGet.looped = false;

        /* STELLA */
        star = new FlxSprite(448, 468);
        star.updateHitbox(); // aggiorna l'hitbox della stella (contatto con il player)
        star.frames = FlxAtlasFrames.fromSparrow('assets/data/map2/star.png', 'assets/data/map2/star.xml');
        star.animation.addByPrefix('idle loop', 'idle', 30, true);
        star.animation.play('idle loop', true, false);
        add(star);

        /* giocatore */
        player = new Player4Directions(60, 20);
        player.maxVelocity.set(120, 220); // massima velocità del player
        // player.acceleration.y = 200; // simula velocità del giocatore sul pavimento
        // player.drag.x = player.maxVelocity.x * 4;
        player.updateHitbox(); // aggiorna l'hitbox del giocatore (contatto con la stella)
        player.drag.x = 1600;
        player.drag.y = 1600;
        player.velocity.x = 0; // in caso non si tocchi nulla
        player.velocity.y = 0; // in caso non si tocchi nulla
        player.velocity.set(80, 0);
        player.velocity.pivotDegrees(FlxPoint.weak(0, 0), angle);
        add(player);

        /* vaccarella (enemy) */
        vaccarellaEnemy = new VaccarellaEnemy(/*player.x - 30, player.y*/);
        // add(vaccarellaEnemy);

        /* livello */
        level1 = new FlxTilemapExt();
        add(level1.loadMapFromCSV('assets/data/map2/slopemap.txt', 'assets/data/map2/colortiles.png', 10, 10));

        var levelTiles = FlxTileFrames.fromBitmapAddSpacesAndBorders("assets/data/map2/colortiles.png", new FlxPoint(10, 10), new FlxPoint(2, 2), new FlxPoint(2, 2));
		level1.frames = levelTiles;

        var tempNW:Array<Int> = [5, 9, 10, 13, 15];
		var tempNE:Array<Int> = [6, 11, 12, 14, 16];
		var tempSW:Array<Int> = [7, 17, 18, 21, 23];
		var tempSE:Array<Int> = [8, 19, 20, 22, 24];

		level1.setSlopes(tempNW, tempNE, tempSW, tempSE);
		level1.setDownwardsGlue(true);

		// set tiles steepness
		level1.setGentle([10, 11, 18, 19], [9, 12, 17, 20]);
		level1.setSteep([13, 14, 21, 22], [15, 16, 23, 24]);

		// set cloud tiles
		level1.setTileProperties(4, NONE, fallInClouds);

        /* camera settings */
        FlxG.camera.setScrollBoundsRect(0, 0, 500, 500, true); // imposta lo scroll

        /* quali camera(s) devonon seguire il giocatore */
        gameCamera.follow(player, LOCKON); // segui il giocatore
		// hudCamera.follow(player); // segui il giocatore

        /* zoom della camera */
        FlxG.camera.zoom = 1.9;
    }

    function fallInClouds(Tile:FlxObject, Object:FlxObject):Void
        {
            if (FlxG.keys.anyPressed([DOWN, S]))
            {
                Tile.allowCollisions = NONE;
            }
            else if (Object.y >= Tile.y)
            {
                // Tile.allowCollisions = CEILING;
            }
        }

    override function update(elapsed:Float) {
        super.update(elapsed);

        /* COLLISIONE */
        FlxG.collide(level1, player);

        /* CAMERA UPDATE */
        FlxG.camera.follow(player, LOCKON);

        /* INPUT */
        var pressedPause:Bool = FlxG.keys.justPressed.P || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.BACKSPACE;
        var pressedUp = virtualPad.buttonUp.pressed;
        var pressedDown = virtualPad.buttonDown.pressed;
        var pressedLeft = virtualPad.buttonLeft.pressed;
        var pressedRight = virtualPad.buttonRight.pressed;

        /* calcola la distanza dal giocatore e vaccarellaEnemy */
        var dx:Float = player.x - vaccarellaEnemy.x;
        var dy:Float = player.y - vaccarellaEnemy.y;
        var distance:Float = Math.sqrt(dx * dx + dy * dy);

        /* vaccarellaEnemy deve inseguire il giocatore */
        vaccarellaEnemy.x += dx / distance * 2.40; // velocità del chaser
        vaccarellaEnemy.y += dy / distance * 2.40;

        if (pressedUp || pressedDown || pressedLeft || pressedRight) {
            // inizializza l'angolo
            var angle:Float = 0;

            if (pressedUp) {
                angle = -90;

                if (pressedLeft) 
                    angle -= 45;
                else if (pressedRight)
                    angle += 45;
            }
            else if (pressedDown) {
                angle = 90;

                if (pressedLeft)
                    angle += 45;
                else if (pressedRight)
                    angle -= 45;
            }
            else if (pressedLeft) {
                angle = 180;
            }
            else if (pressedRight) {
                angle = 0;
            }

            // definisci caratteristiche + angolo
            player.velocity.set(80, 0);
            // velocity.rotate is deprecated
            player.velocity.pivotDegrees(FlxPoint.weak(0, 0), angle);
        }

        /*
        if (pressedUp) {
            player.velocity.y -= 80;
        }

        if (pressedDown) {
            player.velocity.y += 80;
        }

        if (pressedRight) {
            player.velocity.x += 80;
        }

        if (pressedLeft) {
            player.velocity.x -= 80;
        }
        */

        /* se il giocatore entra a contatto con l'HitBox della stella */
        if (player.overlaps(star)) {

            /* il pad non sarà più visibile */
            virtualPad.visible = false;
            
            /* rimuovi la stella */
            star.kill();
            star.destroy();

            /* sposta il giocatore */
            player.x = 420;
            player.y = 445;

            /* velocità del giocatore pari a 0 */
            player.velocity.x = 0;
            player.velocity.y = 0;

            /* flash della camera */
            FlxG.camera.flash(FlxColor.WHITE, 0.7);

            /* emana suono */
            sparkleSound.play();

            /* timer per disattivare in comandi disattiva i comandi */
            new FlxTimer().start(0.1, function(tmr:FlxTimer) {

                /* disabilitare i comandi */
                FlxG.keys.enabled = false;

                /* fade-out della camera */
                new FlxTimer().start(5, function(tmr:FlxTimer) {

                    /* fade-out della camera con la quale poi si passerà alla schermata finale */
                    FlxG.camera.fade(FlxColor.BLACK, 0.5, false, endScreen);
                });
            });

            /* ferma la canzone attualemte in esecuzione */
            FlxG.sound.music.stop();

            /* avvia la riproduzione della bgm 'starGet' */
            starGet.play(false);
            starGet.pitch = 1.3; /* velocità della canzone */

            /* ingrandisci il player */
            player.setGraphicSize(20, 20);

            /* avvia l'animazione */
            player.animation.play('dancin', false);
        }

        /* se clicchi P, entra in pausa */
        #if (!mobile)
        if (pressedPause) {
            /* apri SubState della Pausa */
            openSubState(new Pause(0, 0));
        }
        #end

        /* POSIZIONE ATTUALE DEL GIOCATORE */
        #if debug
        trace("posizione player X: " + player.x, "posizione playerY: " + player.y);
        #end
    }

    /* funzione con la quale si passa alla schermata finale */
    function endScreen() {

        /* apri lo state della schermata finale */
        FlxG.switchState(new EndScreen());
    }
}