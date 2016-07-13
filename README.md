# love2d_dialog
a simple library for spawning dialog boxes

### Setup

* place dialog:draw() in your love.draw() routine
* place dialog:update(dt) in your love.update() routine
* place dialog:mousepressed(x,y,button) in your love.mousepressed() routine
 
### Usage
``dialog:create("Test","This is a test message,100,100,150,200)``
 
See `main.lua` for an example.
