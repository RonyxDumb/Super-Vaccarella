package objects;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.display.Sprite;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
/**
 * date:02/05/2024
 * Il giocatore, con il quale puoi:
 * 
 * - Muoverti in 4 direzioni diverse
 * - Interagire con gli elementi (updateHitBox)
 * - Animarlo (Mario che fa la default dance)
 */
class Player4Directions extends FlxSprite {

    final SPEED:Int = 80; // player speed

    public function new(xPos, yPos) {
        super(xPos, yPos);
        
        // makeGraphic(8, 14, FlxColor.RED);

        frames = FlxAtlasFrames.fromSparrow('assets/images/player/marioDefaultDance.png', 'assets/images/player/marioDefaultDance.xml');
        animation.addByPrefix('dancin', 'df3jhrp-2cef341a-5ee8-4c5f-9906-bba784b80eb6_', 30, false);
        

        /* imposta la grandezza */
        setGraphicSize(14, 14);

        /* aggiorna la hitbox */
        updateHitbox();

        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);

       /* rallenta il giocatore in mancanza di inputs */
       drag.x = drag.y = 1600;

       // in caso non si tocchi nulla, il giocatore sta fermo
       velocity.x = 0;
       velocity.y = 0;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        /* aggiorna i movimenti del giocatore */
        movimenti();
    }

    /* inputs da part del giocatore */
    function movimenti():Void {
        /*
        final up = FlxG.keys.anyPressed([UP, W]);
        final down = FlxG.keys.anyPressed([DOWN, S]);
        final left = FlxG.keys.anyPressed([LEFT, A]);
        final right = FlxG.keys.anyPressed([RIGHT, D]);
        */

        // dichiara variabili
        var up:Bool = false;
        var down:Bool = false;
        var left:Bool = false;
        var right:Bool = false;

        // quando clicchi uno dei tasti
        up = FlxG.keys.anyPressed([UP, W]);
        down = FlxG.keys.anyPressed([DOWN, S]);
        left = FlxG.keys.anyPressed([LEFT, A]);
        right = FlxG.keys.anyPressed([RIGHT, D]);

        // annulla movimenti opposti se:
        // su e giù
        if (up && down) {
            up = down = false;
        }
        // e
        // destra e sinistra
        if (right && left) {
            right = left = false;
        }

        // se si muove, definisci l'angolo
        if (up || down || left || right) {
            
            // inizializza l'angolo
            var angle:Float = 0;

            if (up) {
                angle = -90;

                if (left) 
                    angle -= 45;
                else if (right)
                    angle += 45;
            }
            else if (down) {
                angle = 90;

                if (left)
                    angle += 45;
                else if (right)
                    angle -= 45;
            }
            else if (left) {
                angle = 180;
            }
            else if (right) {
                angle = 0;
            }

            // definisci caratteristiche + angolo
            velocity.set(SPEED, 0);
            // velocity.rotate is deprecated
            velocity.pivotDegrees(FlxPoint.weak(0, 0), angle);
        }
    }
}