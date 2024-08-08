package objects;

import states.Game;
import flixel.FlxSprite;

class VaccarellaEnemy extends FlxSprite {
    final SPEED:Int = 175;

    public function new(/*xPos, yPos*/) {
        super(/*xPos, yPos*/);

        loadGraphic(Paths.image('enemy/vaccarella'));

        /* imposta la grandezza */
        setGraphicSize(30, 30);

        /* rallenta il giocatore in mancanza di inputs */
        drag.x = drag.y = 1600;

        updateHitbox();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        /* aggiorna la posizione e traccia quella del giocatore */
        
    }
}