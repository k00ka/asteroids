Ruby Hack Night Asteroids
=========================

Slides and assets for the Asteroids workshop [first presented at Toronto Ruby Hack Night, February 25, 2016]  
Workshop for learning Gosu and Chipmunk  
Created by David Andrews and Jason Schweier  

Slides for the workshop are here:  
https://gnab.github.io/remark/remarkise?url=https://raw.githubusercontent.com/k00ka/asteroids/master/SLIDES.md

###Introduction

This project is a simple Ruby + Gosu + Chipmunk project. If you follow the instructions below, you can test your machine in advance of the workshop.

We have provided a repository which mimics the setup we used last time, so it should be familiar. The code to be created is found in the ``lib/`` directory.

###Setup

Here are the steps to get you started with the repo.

1. For this workshop, you will need a laptop with the following:
  - [x] Ruby 2.x  
  - [x] A github account  
  Note: We have included a ``.ruby-version`` file locked to 2.2.3, which you can change to any Ruby 2.x version if you don't have 2.2.3 installed  
  More detailed instructions for each platform are included in the footer. Refer there if you are having issues.

1. Fork the repo (optional, recommended):
  From the page https://github.com/k00ka/asteroids, click the Fork button in the top-right corner. Copy the new repo address (in a box just below the thick red line) into your clipboard. Detailed instructions on forking a repo can be found here: https://help.github.com/articles/fork-a-repo/

1. At Ryatta Group we use rbenv, and so we've included some optional elements - just skip them if you're using rvm or are not versioning your Ruby. If you forked the repo above, your repo_address will be in your clipboard. If not, you should use my repo_address ``git@github.com:k00ka/asteroids.git``

  ```sh
  % git clone <repo_address>
  % cd asteroids
  % gem install bundler
  Fetching: bundler-1.7.4.gem (100%)
  Successfully installed bundler-1.7.4
  1 gem installed
  % bundle
  Fetching gem metadata from https://rubygems.org/.........
  Resolving dependencies...
  Installing rake 10.3.2
  ...
  Using bundler 1.7.4
  Your bundle is complete!
  Use `bundle show [gemname]` to see where a bundled gem is installed.
  ```
  Note: if you use rbenv...
  ```sh
  % rbenv rehash
  ```
  You are (almost) there!

1. To test your machine:
  ```sh
  % git checkout epic1
  % ruby asteroids.rb
  ```
  You should see a black window with Ruby Hack Night Asteroids in the title bar.

1. If you're keen, have a look at the source to prepare.

## Additional resources

Additional instructions for your platform are here:  
Linux => https://github.com/gosu/gosu/wiki/Getting-Started-on-Linux  
OSX => https://github.com/gosu/gosu/wiki/Getting-Started-on-OS-X  
Windows => https://github.com/gosu/gosu/wiki/Getting-Started-on-OS-X  

## Rules of the game

Game play is just like you remember:
* Shoot the asteroids and they break into smaller asteroids. Large asteroids are worth 20 points, medium 50 points, and small 100 points.
* Press the thrust button to move your ship forward. Unlike in real space, there is drag which slows your ship to a stop over time.
* Watch out for the flying saucer — it shoots in random directions and can crash into you. Shoot it for 500 points.
* If you are in real trouble, press the hyperspace button. This transports you to a different location, but that location may be very dangerous, too!
* When all the asteroids on a level are destroyed, a new level starts. Higher levels have more asteroids.
* You start with 3 ships, and get an extra ship every 10,000 points.
* At the end of the game you can enter your initials if you got one of the top 10 high scores. High scores are stored in EEPROM so they are not erased when power is off. Also, different games use different high score “files” in EEPROM, so your Asteroids scores won’t interfere with your Space Invaders scores, etc.

## Gosu main loop

Gosu will call your #update and #draw methods in an infinite loop. You will need to do all of the updates the on-screen objects in #update, and draw the objects in #draw. More about this later...

The main loop of the game will look like this.
```
def update
  run the physics engine (chipmunk) to move your objects around and cause collisions
  get_player_input
  if killed
    // pause and reset the ship...
  end
  if asteroids.count == 0
    // reset variables...
    Level.new
  end
  if remaining_ships == 0
    game_over_dude!
  end
end

def draw
  draw_asteroids
  draw_ship
  draw_shots
  draw_aliens
  drawExplosions
end
```

This game is all about collision detection. While the game is running, the code needs to detect the following collisions:
* collisions between your ship and asteroids
* collisions between the shots you fire and asteroids
* collisions between the alien and your ship
* collisions between the alien’s fired shot and your ship
* collisions between the shots you fire and the alien
...and more.

## Epic 1 - Main loop and the Player class
1. Create the Player class with body, shape and draw methods (plus others)
1. Use the keyboard to control movement (left, right, thrust, hyperspace)
1. Create damping on the Player so that they slow down over time
1. Thrusting makes noise
1. More hints as we work through this tonight

## Epic 2 - Asteroids
1. Create the asteroids in three sizes with body, shape and draw
1. Asteroids don't bump into each other
1. Detect collisions between the Player and Asteroids (infinite respawn!)
1. Asteroids split into smaller chunks
1. Asteroids move in random directions and speeds
1. Asteroids crash as they hit things
1. More hints as we work through this tonight

## Epic 3 - Shooting
1. Create shots/bullets
1. Shots move fast in the direction you are pointing
1. Shooting makes noise
1. Shots collide with asteroids
1. There is a limit of 4 shots on-screen
1. More hints as we work through this tonight

## Epic 4 - Scoring and the Dock
1. Create a dock showing the score and number of ships
1. Asteroids score 20, 50 and 100 points going from small to large
1. You get three lives to start the game
1. Once you lose three lives you are done the game
1. You get a free life each 10k
1. More hints as we work through this tonight

## Epic 5 - Aliens!
## Epic 6 - Levels

## Bonus Features

These additional features are not required for basic gameplay, but they do add to the playability of the game.

* Once a level is cleared, the next level starts immediately. Introduce a delay to give the player a short break.
* At the start of a level, asteroids may appear directly on the player. Introduce logic to make sure asteroids are not generated within a reasonable distance from the player.
* When the player dies, create (or find!) an explosion animation. Animations in Gosu are handled with [tiles](https://www.libgosu.org/rdoc/Gosu/Image.html#load_tiles-class_method).
* The original game also included a small alien saucer. It had a shorter bullet range but was far more accurate, able to hit the player in only 2-3 shots. The small saucer did not appear until the player hit 10,000 points.
* When game entities reach the edge of the screen, they remain on their current side until their midpoint becomes offscreen, at which point, they immediately jump to the opposite side of the screen. It would be nicer if, as some of their body went offscreen, that part would appear on the opposite side.
