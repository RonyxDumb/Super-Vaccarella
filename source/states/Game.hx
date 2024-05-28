package states;

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
    
    /* TEXTS */
    var pauseText:FlxText;

    /* SPRITES */
    var star:FlxSprite;

    /* MUSIC */
    var starGet:FlxSound;

    /* SOUNDS */
    var sparkleSound:FlxSound;

    override function create():Void {
        super.create();

        /* SETTIN */
        FlxG.keys.enabled = true;

        /* MUSIC */
        FlxG.sound.playMusic(Paths.music('basement/BGM_BASEMENT_FRACC'), 1, true);

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
        add(player);

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

        /* hud */
        // add(hud);

        /* testo per mettere in pausa il gioco (inutilizzata lol) */
        pauseText = new FlxText();
        pauseText.color = FlxColor.RED;
        pauseText.text = 'P: Metti in pausa il gioco';
        pauseText.size = 15;
        pauseText.x = 1;
        pauseText.y = 10;
        pauseText.scrollFactor.set();
        // add(pauseText);
        // hud.add(pauseText);

        /* camera settings */
        FlxG.camera.setScrollBoundsRect(0, 0, 500, 500, true); // imposta lo scroll
		FlxG.camera.follow(player, LOCKON); // segui il giocatore
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

        /* INPUT */
        var pressedPause:Bool = FlxG.keys.justPressed.P || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.BACKSPACE;

        /* COLLISIONE */
        FlxG.collide(level1, player);

        /* CAMERA UPDATE */
        FlxG.camera.follow(player, LOCKON);

        /* se il giocatore entra a contatto con l'HitBox della stella */
        if (player.overlaps(star)) {
            
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
        if (pressedPause) {

            /* apri SubState della Pausa */
            openSubState(new Pause(0, 0));
        }

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