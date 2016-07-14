# love2d_dialog
a simple library for spawning dialog boxes

![screenshot](https://cloud.githubusercontent.com/assets/1535179/16829675/d7e62658-4991-11e6-9cc7-4a249081dbd5.png)

### Setup

* place dialog:draw() in your love.draw() routine
* place dialog:update(dt) in your love.update() routine
* place dialog:mousepressed(x,y,button) in your love.mousepressed() routine
 
### Usage
``dialog:new("Test","This is a test message",100,150,100,"left")``
 
See `main.lua` for an example.
