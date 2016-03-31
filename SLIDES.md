title: Asteroids on Gosu and Chipmunk
name: inverse
layout: true
class: inverse

---
class: center middle

# Ruby Hack Night Asteroids
Gosu and Chipmunk Game Workshop  
David Andrews  

Big thanks to Jason Schweier

---
class: middle

# Gosu (gem)

* Gosu is a gaming framework composed of a gem with 9 classes and around 100 methods
* Load and draw sprites, tiles, fonts
* Load and play sounds
* Gather player input
* Your game inherits from Gosu::Window
* *#initialize* sets up for your game
* *#show* starts the game loop
* The game loop consists of these two calls:
  * *#update* is called after each *tick* and should update your game model (user input, random events, physics)
  * *#draw* is called whenever the model is updated and the screen needs refreshing
* Normally, your game needs to compute "delta" (milliseconds since last update) and use it in calculations to support smooth transitions, but today we're pairing Gosu with...

---
class: middle

# Chipmunk (gem)

* Chipmunk is a 2D rigid body physics library
* A Body holds the physical properties of an object (mass, position, spin, velocity, etc.)
* Shapes to a body and define surface properties (friction, elasticity)
* Constraints and joints describe how bodies are attached to each other
* Spaces are containers for simulation (a place where bodies, shapes and joints can interact)
* (Scaled) vectors (Vec2 class) are used in many places along with Ruby Floats
* Forces can be applied to bodies
* The event of bodies colliding can be captured in a callback

---
class: middle

# Gosu main loop

![](https://raw.githubusercontent.com/wiki/gosu/gosu/main_loop.png)

---
class: middle

# Skeleton for Gosu

```
require 'gosu'
class Game << Gosu::Window
  def initialize
    super width, height
    # create objects
  end
  def update
    # calculate delta
    # move objects around, manage collisions, etc. on your own
  end
  def draw
    @objects.each(&:draw)
  end
end
Game.new.show
```
---
class: middle

# Skeleton for Gosu + Chipmunk

```
require 'gosu'
require 'chipmunk'
class Game << Gosu::Window
  def initialize
    super width, height # open window
    @space = CP::Space.new
    # create @objects adding each one to @space
    # define collision callbacks
  end
  def update
    @space.step(dt) # CP moves objects forward-in-time by dt
    # react to callbacks
  end
  def draw
    @objects.each(&:draw)
  end
end
Game.new.show
```
---
class:middle

#CP::Space

* applies gravity
* applies damping
* holds bodies and shapes
* manages constraints
* time is applied via #step method
* calls collision callbacks

---
class: middle

#CP::Body

* stores properties mass, momentum
* measures position, velocity, force
* also angle, angular velocity, torque
* has no shape

---
class: middle

#CP::Shape

* defines boundary of body (collision perimeter)
* body can have multiple shapes
* circles, line segments, polygons
* cannot have dimples
---
