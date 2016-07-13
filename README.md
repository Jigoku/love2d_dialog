# love2d_dialog
a simple library for spawning dialog boxes

![screenshot_20160713_102317](https://cloud.githubusercontent.com/assets/1535179/16798425/db39e776-48e3-11e6-93d8-618b92f2c35e.png)

### Setup

* place dialog:draw() in your love.draw() routine
* place dialog:update(dt) in your love.update() routine
* place dialog:mousepressed(x,y,button) in your love.mousepressed() routine
 
### Usage
``dialog:create("Test","This is a test message",100,150,100)``
 
See `main.lua` for an example.
