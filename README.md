# asteroids
Asteroids on Gosu

Game play is just like you remember:
Shoot the asteroids and they break into smaller asteroids. Large asteroids are worth 20 points, medium 50 points, and small 100 points.
Press the thrust button to move your ship forward. Unlike in real space, there is drag which slows your ship to a stop over time.
Watch out for the flying saucer — it shoots in random directions and can crash into you. Shoot it for 500 points.
If you are in real trouble, press the hyperspace button. This transports you to a different location, but that location may be very dangerous, too!
When all the asteroids on a level are destroyed, a new level starts. Higher levels have more asteroids.
You start with 3 ships, and get an extra ship every 10,000 points.
At the end of the game you can enter your initials if you got one of the top 10 high scores. High scores are stored in EEPROM so they are not erased when power is off. Also, different games use different high score “files” in EEPROM, so your Asteroids scores won’t interfere with your Space Invaders scores, etc.

The main loop of the game looks basically like this. Some details are omitted, but this is the basic idea:
```
void loop() {
  moveAsteroids();
  moveShots();
  getInput();
  moveShip();
  drawShip();
  drawSaucer();
  killed = detectCollisions();
  if (killed) {
    // pause and reset the ship...
  }
  drawExplosions();
  if (nAsteroids == 0) {
    // reset variables...
    newLevel();
  }
  if (remainingShips == 0) {
    gameOver();
    if (score > 0) {
      enterHighScore(1);
    }
  }
}
```

This game is all about collision detection. While the game is running, the code needs to detect the following collisions:
* collisions between your ship and asteroids
* collisions between the shots you fire and asteroids
* collisions between the saucer and your ship
* collisions between the saucer’s fired shot and your ship
* collisions between the shots you fire and the saucer

The key to these collision detections is using a “point in polygon” algorithm which determines whether a point is within the bounds of a polygon defined as a set of vertices.

The point-in-polygon algorithm is surprisingly short, but not very easy to understand. Here’s the function inPolygon which takes as arguments the number of vertices, an array of the X coordinates of the vertices, an array of the Y coordinates of the vertices, and the (x,y) coordinates of the point we are testing.
```
/*                                                                                                 
 * This is the point-in-polygon algorithm adapted from                                             
 * http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html                          
 */
boolean inPolygon(byte nvert, byte *xvert, byte *yvert, int x, int y) {
  char i, j;
  byte xvi, xvj, yvi, yvj;
  boolean inside = false;
  for (i=0, j=nvert-1; i<nvert; j=i++) {
    xvi = pgm_read_byte(xvert + i);
    xvj = pgm_read_byte(xvert + j);
    yvi = pgm_read_byte(yvert + i);
    yvj = pgm_read_byte(yvert + j);
    if ( ((yvi > y) != (yvj > y)) &&
         (x < (xvj - xvi) * (y - yvi) / (yvj - yvi) + xvi) )
       inside = !inside;
  }
  return inside;
}
```

Each object displayed on the screen is defined by a set of vertices for the purpose of detecting collisions. The vertices define a polygon which let us detect if a point is in the polygon. For example, the code needs to detect if any of the shots fired by our ship are within any of the polygons that define the asteroids. This point-in-polygon algorithm is used for all collision detection in the game.

## Bonus Features

These additional features are not required for basic gameplay, but they do add to the playability of the game.

* Once a level is cleared, the next level starts immediately. Introduce a delay to give the player a short break.
* At the start of a level, asteroids may appear directly on the player. Introduce logic to make sure asteroids are not generated within a reasonable distance from the player.
* When the player dies, create (or find!) an explosion animation. Animations in Gosu are handled with [tiles](https://www.libgosu.org/rdoc/Gosu/Image.html#load_tiles-class_method).
* The original game also included a small alien saucer. It had a shorter bullet range but was far more accurate, able to hit the player in only 2-3 shots. The small saucer did not appear until the player hit 10,000 points.
* When game entities reach the edge of the screen, they remain on their current side until their midpoint becomes offscreen, at which point, they immediately jump to the opposite side of the screen. It would be nicer if, as some of their body went offscreen, that part would appear on the opposite side.
